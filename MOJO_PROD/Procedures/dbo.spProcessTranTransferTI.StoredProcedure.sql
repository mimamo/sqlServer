USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessTranTransferTI]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessTranTransferTI]
	(
	@TimeKey uniqueidentifier
	,@ToProjectKey int
	,@ToTaskKey int
	,@TransferDate smalldatetime
	,@TransferFromComment varchar(500)
	,@TransferToComment varchar(500)
	-- This parameter is for Abelson only
	,@ToTitleKey int = null
	,@IsAdjustment int = 0
	,@oTransferToKey uniqueidentifier output
	)
AS
	SET NOCOUNT ON

  /*
  || When     Who Rel     What
  || 08/27/09 GHL 10.5  Creation for new transfers 
  ||                    We need to do the following:
  ||                    - Create one tran for the new project (and get the TransferToKey)
  ||                    - Create one tran to reverse the initial transaction (old project)
  ||                    - Modify the initial transaction   
  || 11/04/09 GHL 10.513 Changed DateBilled to WorkDate on the initial transaction   
  || 11/05/09 GHL 10.513 Added checking of TransferToKey before transferring  
  || 12/21/09 GHL 10.515 (70850) Limiting now transfer comment to current transfer rather than appending 
  ||                     to old comments because it was causing an overflow   
  || 01/11/10 GHL 10.516 (71304) Nulling now DetailTaskKey on the new time entry because it will not match @ToProjectKey
  || 01/15/10 GHL 10.516 Nulling DetailTaskKey on the old time entries as well
  || 01/25/10 GHL 10.517 Instead of nulling DetailTaskKey on the new time entry, call sptTimeInsertFixTaskKeys
  ||                     to minimize impact on traffic screens 
  || 02/25/10 GHL 10.519 Added logic when same projects
  || 05/13/10 GHL 10.523 (80709) Rolled back logic for same projects
  || 05/23/11 GHL 10.524 (112161) Same record was transferred several times
  ||                      Checking now for existing recs where TransferFromKey = @TimeKey before proceeding with transfer
  ||                      This is redundant with checking TransferToKey on current record
  ||                      Also if transfer within same project and not in WIP, just change tasks on time entry
  || 01/24/12 GHL 10.552 (132374) Removed NOLOCK when reading tTime.TransferFromKey and tTime.TransferToKey
  ||                      because of problems with transfers occurring twice for same original transaction 
  ||                      Added final check to prevent double transfers
  || 06/26/12 GHL 10.557 (146376) Set InvoiceLineKey = 0 (Marked As Billed) 
  ||                      for initial entry instead of going through spProcessTranTransferBilling
  || 01/09/12 GWG 10.564 Added voucher key onto the transfers so that they don't get picked up a second time as payable in vouchers.
  || 09/25/13 GHL 10.572 Added multi currency fields
  || 10/14/14 GHL 10.585 (224560) Added update of RootTransferFromKey 
  || 11/05/14 GHL 10.586 Added logic for titles for Abelson (these transfers have IsAdjustment = 2)
  || 11/21/14 GHL 10.586 We cannot transfer if invoiced
  || 01/08/15 GHL 10.588 When changing Titles, do transfer even if rates are the same for traceability
  || 02/24/15 GHL 10.589 When performing a reversal after an 'Undo Write Off', the reversal should be written off, not marked as billed
  || 03/10/15 GHL 10.590 Added update of Department for Abelson 
  ||
  */
  
	/*
	I am placing here the different Adjustment types (IsAdjustment) for transfers

	AdjustmentType = 0		Real Xfers
	AdjustmentType = 1		Editing after WIPPostingInKey <> 0 (time entries only). Note: is it necessary? because of WIPAmount
	AdjustmentType = 2		Change of Title (Abelson Taylor) (time entries only)
	AdjustmentType = 3		Undo WO after WIPPostingOutKey <> 0
	*/

	Declare @CompanyKey int
	select @CompanyKey = CompanyKey from tProject (nolock) where ProjectKey = @ToProjectKey

	--use IX_tTime_12
	if exists (select 1 from tTime t -- no NOLOCK on purpose
	           inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			   where p.CompanyKey = @CompanyKey
			   and   t.TransferFromKey = @TimeKey
			  )
			  return -1			    
	 
/*
Regular Transfers

     FROM      TO
TK   TFK       TTK          WIK   ILK		Type of entry
-------------------------------------------------------
Orig NULL      New           ?     NULL->0	Original
Rev  Orig      New          -99    0		Reversal
New  Orig      null          0     NULL		New

Title Adjustment followed by Transfer

     FROM      TO
TK   TFK       TTK          WIK   ILK		Type of entry		Title Adj	Title 
----------------------------------------------------------------------------------
Orig NULL      New           ?     NULL->0  Original			1			1
Rev  Orig      New          -99    0		Reversal (Adj)		1			1
New  Orig      null->New2    0     NULL->0	New (Adj)			0    		2
Rev2 New	   New2			-99	   0		Reversal (Xfer)		0			2
New2 New	   null			 0	   Null		New (Xfer)			0			2

Transfer followed by Title Adjustment

     FROM      TO
TK   TFK       TTK          WIK   ILK		Type of entry		Title Adj	Title 
----------------------------------------------------------------------------------
Orig NULL      New           ?     NULL->0	Original			0			1
Rev  Orig      New          -99    0		Reversal (Xfer)		0			1
New  Orig      null->New2    0     NULL->0	New (Xfer)			0->1    	1
Rev2 New	   New2			-99	   0		Reversal (Adj)		1			1
New2 New	   null			 0	   Null		New (Adj)			0			2

In other words:
Title Adj = 1 on Original and Reversal (not the new)

*/

	DECLARE @TransferToKey UNIQUEIDENTIFIER
	DECLARE @ReversalDetailKey UNIQUEIDENTIFIER
	DECLARE @ToDetailTaskKey int
	DECLARE @Error INT
	DECLARE @RetVal INT
	
		  
	-- Vars needed for spProcessTranTransferBilling
	Declare @OrigWIK int		-- WIPPostingInKey of the original initial tran, could be -1
	Declare @OrigWOK int		-- WIPPostingOutKey of the original initial tran
	Declare @OrigILK int		-- InvoiceLineKey
	Declare @OrigWO int			-- WriteOff
	Declare @OrigWOReasonKey int-- WriteOff reason
	Declare @OrigDB datetime	-- DateBilled	
	Declare @OrigAB money		-- AmountBilled
	Declare @OrigBH decimal(24,4)-- BilledHours
	Declare @OrigBR money		-- BilledRate	
	Declare @ILK int 			-- InvoiceLineKey
	Declare @WO int 			-- WriteOff
	Declare @WOReasonKey int	-- WriteOff reason
	Declare @DB datetime		-- DateBilled	
	Declare @AB money			-- AmountBilled		  
	Declare @BH decimal(24,4)	-- BilledHours	
	Declare @BR money			-- BilledRate		  
			  
	-- Various vars
	--Declare @ProjectKey int
	--Declare @TaskKey int	
	Declare @ExpenseDate smalldatetime
    Declare @ShortDescription varchar(200)
    Declare @LongDescription varchar(1000)
    Declare @ItemKey int
    Declare @ClassKey int
    Declare @Quantity decimal(24,4)
    Declare @UnitCost money
    Declare @UnitDescription varchar(30)
    Declare @TotalCost money
    Declare @UnitRate money
    Declare @Markup decimal(24,4)
    Declare @Billable tinyint
    Declare @BillableCost money
    Declare @AmountBilled money
    Declare @EnteredByKey int
    Declare @DateEntered smalldatetime
    Declare @JournalEntryKey int
    --Declare @OnHold tinyint
    --Declare @BilledComment varchar(2000)
    Declare @DepartmentKey int
    
    Declare @TimeSheetKey int
    Declare @UserKey int
    Declare @ProjectKey int
    Declare @TaskKey int
    Declare @ServiceKey int
    Declare @RateLevel int
    Declare @WorkDate smalldatetime
    Declare @StartTime smalldatetime
    Declare @EndTime smalldatetime
    Declare @ActualHours decimal(24,4)
    Declare @PauseHours decimal(24,4)
    Declare @ActualRate money
    Declare @CostRate money
    Declare @BilledService int
    Declare @BilledHours decimal(24,4)
    Declare @BilledRate money
    Declare @Comments varchar(2000)
    Declare @Downloaded tinyint
    Declare @OnHold tinyint
    Declare @BilledComment varchar(2000)
    Declare @TaskAssignmentKey int
    Declare @DetailTaskKey int
    Declare @OrigTransferComment varchar(2000)
    Declare @VoucherKey int
    Declare @ExchangeRate decimal(24,7)
	Declare @CurrencyID varchar(10)
	Declare @HCostRate money
	Declare @RootTransferFromKey UNIQUEIDENTIFIER
	Declare @TitleKey int
	Declare @NewActualRate money -- for titles
	

	--SELECT @TransferDate = CONVERT(SMALLDATETIME, (CONVERT(VARCHAR(10), GETDATE(), 101)), 101)
	
	Select 
		@OrigWIK = WIPPostingInKey
		,@OrigWOK = WIPPostingOutKey
		,@OrigILK = InvoiceLineKey
		,@OrigWO = WriteOff
		,@OrigWOReasonKey = WriteOffReasonKey
		,@OrigDB = DateBilled
		,@OrigBH = BilledHours
	     
		,@TimeSheetKey = TimeSheetKey
		,@UserKey = UserKey
		,@ProjectKey = ProjectKey
		,@TaskKey = TaskKey
		,@ServiceKey = ServiceKey
		,@RateLevel = RateLevel
		,@WorkDate = WorkDate
		,@StartTime = StartTime
		,@EndTime = EndTime
		,@ActualHours = ActualHours
		,@PauseHours = PauseHours
		,@ActualRate = ActualRate
		,@CostRate = CostRate
		,@BilledService = BilledService
		,@BilledHours = BilledHours
		,@BilledRate = BilledRate
		,@Comments = Comments
		,@Downloaded = Downloaded
		,@OnHold = OnHold
		,@BilledComment = BilledComment
		,@TaskAssignmentKey = TaskAssignmentKey
		,@DetailTaskKey = DetailTaskKey
        ,@OrigTransferComment = ISNULL(TransferComment, '')
        ,@TransferToKey = TransferToKey
        ,@VoucherKey = VoucherKey
        ,@ExchangeRate = ExchangeRate
		,@CurrencyID = CurrencyID 
		,@HCostRate = HCostRate 
		,@RootTransferFromKey = TransferSourceKey
		,@TitleKey = TitleKey  
		,@DepartmentKey = DepartmentKey     
	From   tTime -- no NOLOCK on purpose
	Where  TimeKey = @TimeKey
		
	If @TransferToKey is not null
		return -1

	-- If invoiced, this is locked
	If @OrigILK > 0
		return -1

	if isnull(@ToTitleKey, 0) > 0 
	begin
		-- this is an adjustment due to a update of title
		
		-- use old project and task, because this is a change of title only
		exec @RetVal = sptTimeGetRate @UserKey, @ProjectKey, @TaskKey, @ServiceKey, @RateLevel, 0, @NewActualRate output
		
		-- or return an error 
		if @RetVal <0
			return 1

		if @NewActualRate is null
			return 1

		-- technically, there is nothing to adjust here if this is the same rate
		/* talk with GG 1/8/15 do transfer anyway for traceability
		if isnull(@NewActualRate,0) = isnull(@ActualRate, 0)
		begin
			if isnull(@TitleKey, 0) = isnull(@ToTitleKey, 0)
				return 1 
			else
			begin
				update tTime set TitleKey = @ToTitleKey where TimeKey = @TimeKey
				return 1
			end
		end
		*/

		select @ToDetailTaskKey = @DetailTaskKey
	end
	else
	begin
		-- no change of title
		select @NewActualRate = @ActualRate
			  ,@ToTitleKey = @TitleKey

		if @ToTaskKey is not null
		begin
			-- if ToTaskKey is not null, it should not be changed, but @ToDetailTaskKey MAY be correctly changed
			exec sptTimeInsertFixTaskKeys @ToProjectKey, @ToTaskKey output, @ToDetailTaskKey output
		end

		-- 80709 Allow for transfers so that the Service/Gross can be edited to adjust for WIP postings
		--After 112161, decided to put that back in place, if not in WIP yet 
		if @ProjectKey = @ToProjectKey And @OrigWIK = 0 -- if not in WIP 
		begin
			if @ToTaskKey is null
				select @ToDetailTaskKey = null
			
			update tTime set TaskKey = @ToTaskKey
					, DetailTaskKey = @ToDetailTaskKey
					, TransferComment = @OrigTransferComment + ' ' + @TransferFromComment
			where  TimeKey = @TimeKey
		
			return 1
		end
	
	end

	

	Select @OrigAB = 0 -- AmountBilled not required for time entries
		
	/*
	* First create a transaction for the new project and collect the new key
	*/
	
	-- the billing info will depend on the WIP keys
	exec spProcessTranTransferBilling @OrigWIK,@OrigWOK,'New',@TransferDate, @ActualHours, @ActualRate, 0
		,@OrigILK,@OrigDB,@OrigWO,@OrigWOReasonKey,@OrigAB,@OrigBH,@OrigBR 
		,@ILK output	-- InvoiceLineKey
		,@DB output		-- DateBilled	
		,@WO output		-- WriteOff
		,@WOReasonKey output	-- WriteOff reason
		,@AB output		-- AmountBilled
		,@BH output		-- BilledHours
		,@BR output		-- BilledRate
		
	-- however if we undo a WriteOff, make it billable
	IF @IsAdjustment = 3
	begin
		select @ILK = null, @DB = null, @BH = null, @BR = null
	end
		
	BEGIN TRAN

	SELECT @TransferToKey = NEWID()
 	
	INSERT INTO tTime
           (TimeKey
           ,TimeSheetKey
           ,UserKey
           ,ProjectKey
           ,TaskKey
           ,ServiceKey
           ,RateLevel
           ,WorkDate
           ,StartTime
           ,EndTime
           ,ActualHours
           ,PauseHours
           ,ActualRate
           ,CostRate
           ,BilledService
           ,BilledHours
           ,BilledRate
           ,InvoiceLineKey
           ,WriteOff
           ,Comments
           ,Downloaded
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,TransferComment
           ,WriteOffReasonKey
           ,DateBilled
           ,OnHold
           ,BilledComment
           ,TaskAssignmentKey
           ,DetailTaskKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
           ,VoucherKey
		   ,ExchangeRate
		   ,CurrencyID  
		   ,HCostRate 
		   ,TransferSourceKey
		   ,TitleKey
		   ,IsAdjustment 
		   ,DepartmentKey
		   )
     VALUES
           (@TransferToKey
           ,@TimeSheetKey
           ,@UserKey
           ,@ToProjectKey
           ,@ToTaskKey
           ,@ServiceKey
           ,@RateLevel
           ,@WorkDate
           ,@StartTime
           ,@EndTime
           ,@ActualHours
           ,@PauseHours
           ,@NewActualRate -- New actual rate, because of titles
           ,@CostRate
           ,@BilledService
           ,@BH
           ,@BR --BilledRate
           ,@ILK
           ,@WO
           ,@Comments
           ,@Downloaded
           ,0 --@WIPPostingInKey
           ,0 --@WIPPostingOutKey
           --@TransferComment
           --Append: Transferred from old Project, old task
           --,@TransferFromComment + '<br>' + left(@OrigTransferComment, 500 - Len(@TransferFromComment)) 
           ,@TransferFromComment
           ,@WOReasonKey
           ,@DB
           ,@OnHold
           ,@BilledComment
           ,@TaskAssignmentKey
           ,@ToDetailTaskKey   
           ,@TransferDate -- TransferInDate
           ,NULL		--TransferOutDate
           ,@TimeKey --TransferFromKey
           ,NULL		--TransferToKey
           ,@VoucherKey
           ,@ExchangeRate
		   ,@CurrencyID  
		   ,@HCostRate  
		   ,isnull(@RootTransferFromKey, @TimeKey)
		   ,@ToTitleKey 
		   ,0 -- IsAdjustment always 0 for the new record
		   ,@DepartmentKey
		   )
           
	IF @@ERROR <> 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END
	
	select @oTransferToKey = @TransferToKey
	            	
	/*
	* Second create a transaction for the reversal of the old project 
	*/

	-- the billing info will depend on the WIP keys
	exec spProcessTranTransferBilling @OrigWIK,@OrigWOK,'Reversal',@TransferDate, @ActualHours, @ActualRate, 0
		,@OrigILK,@OrigDB,@OrigWO,@OrigWOReasonKey,@OrigAB,@OrigBH,@OrigBR
		,@ILK output	-- InvoiceLineKey
		,@DB output		-- DateBilled	
		,@WO output		-- WriteOff
		,@WOReasonKey output	-- WriteOff reason
		,@AB output		-- AmountBilled
		,@BH output		-- BilledHours
		,@BR output		-- BilledRate
		
	-- if we undo a WriteOff, the reversals should be written off (with same reason) not marked as billable
	-- so that the net per reason key is 0
	IF @IsAdjustment = 3
	begin
		-- leave DateBilled as determined by spProcessTranTransferBilling, but change the WO stuff
		select @ILK = null, @BH = 0, @BR = 0, @WO = 1, @WOReasonKey = @OrigWOReasonKey
	end

	SELECT @ReversalDetailKey = NEWID()
	
	INSERT INTO tTime
           (TimeKey
           ,TimeSheetKey
           ,UserKey
           ,ProjectKey
           ,TaskKey
           ,ServiceKey
           ,RateLevel
           ,WorkDate
           ,StartTime
           ,EndTime
           ,ActualHours
           ,PauseHours
           ,ActualRate
           ,CostRate
           ,BilledService
           ,BilledHours
           ,BilledRate
           ,InvoiceLineKey
           ,WriteOff
           ,Comments
           ,Downloaded
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,TransferComment
           ,WriteOffReasonKey
           ,DateBilled
           ,OnHold
           ,BilledComment
           ,TaskAssignmentKey
           ,DetailTaskKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
           ,VoucherKey
		   ,ExchangeRate
		   ,CurrencyID  
		   ,HCostRate  
		   ,TransferSourceKey
		   ,TitleKey
		   ,IsAdjustment
		   ,DepartmentKey
		   )
     VALUES
           (@ReversalDetailKey
           ,@TimeSheetKey
           ,@UserKey
           ,@ProjectKey
           ,@TaskKey
           ,@ServiceKey
           ,@RateLevel
           ,@WorkDate
           ,@StartTime
           ,@EndTime
           ,@ActualHours * -1
           ,@PauseHours
           ,@ActualRate
           ,@CostRate
           ,@BilledService
           ,@BH * -1
           ,@BR--@BilledRate
           ,@ILK
           ,@WO
           ,@Comments
           ,@Downloaded
           ,-99 --@WIPPostingInKey
           ,-99 --@WIPPostingOutKey
           --,@TransferComment
           ,'Reversal due to ' + @TransferToComment
           ,@WOReasonKey
           ,@DB
           ,@OnHold
           ,@BilledComment
           ,@TaskAssignmentKey
           ,Null --@DetailTaskKey... will not be picked up by traffic screens
           ,@TransferDate -- TransferInDate
           ,@TransferDate --TransferOutDate
           ,@TimeKey --TransferFromKey
           ,@TransferToKey	--TransferToKey
           ,@VoucherKey
           ,@ExchangeRate
		   ,@CurrencyID  
		   ,@HCostRate  
		   ,isnull(@RootTransferFromKey, @TimeKey)
		   ,@TitleKey
		   ,@IsAdjustment
		   ,@DepartmentKey
		   )
           
	IF @@ERROR <> 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END
	
	/*     
    * Then update the inital transaction
    */
     
	-- the billing info will depend on the WIP keys
	exec spProcessTranTransferBilling @OrigWIK,@OrigWOK,'Initial',@TransferDate, @ActualHours, @ActualRate, 0
		,@OrigILK,@OrigDB,@OrigWO,@OrigWOReasonKey,@OrigAB,@OrigBH, @OrigBR
		,@ILK output	-- InvoiceLineKey
		,@DB output		-- DateBilled	
		,@WO output		-- WriteOff
		,@WOReasonKey output	-- WriteOff reason
		,@AB output		-- AmountBilled
		,@BH output		-- BilledHours
		,@BR output		-- BilledRate
		
     UPDATE tTime
     SET    DateBilled = @DB
           ,InvoiceLineKey = 0 -- @ILK -- hardcoded because of 146376 
           ,BilledHours = @BH
           ,BilledRate = @BR
           
           ,WriteOff = @WO
           ,WriteOffReasonKey = @WOReasonKey
           
           ,TransferComment = @TransferToComment 	
           ,TransferOutDate = @TransferDate
           ,TransferToKey = @TransferToKey

		   ,DetailTaskKey = null -- will not be picked up by traffic screens     
		   ,TransferSourceKey = isnull(@RootTransferFromKey, @TimeKey)  
		   ,IsAdjustment  = @IsAdjustment   
	WHERE  TimeKey = @TimeKey
     	
	IF @@ERROR <> 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END


	if (select count(*) from tTime t -- no NOLOCK on purpose
		inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
		where p.CompanyKey = @CompanyKey
		and   t.TransferFromKey = @TimeKey)
		> 2
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END


	COMMIT TRAN
			 	
	RETURN 1
GO
