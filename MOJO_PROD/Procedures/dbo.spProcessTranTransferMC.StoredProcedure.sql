USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessTranTransferMC]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessTranTransferMC]
	(
	@MiscCostKey int
	,@ToProjectKey int
	,@ToTaskKey int
	,@TransferDate smalldatetime
	,@TransferFromComment varchar(500)
	,@TransferToComment varchar(500)
	,@AdjustmentType smallint = 0
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
  || 11/05/09 GHL 10.513 Added checking of TransferToKey before transferring 
  || 11/16/09 GHL 10.513 (68471) When creating the new transaction, use ClassKey from new project    
  || 12/21/09 GHL 10.515 (70850) Limiting now transfer comment to current transfer rather than appending 
  ||                     to old comments because it was causing an overflow 
  || 03/12/10 GHL 10.519 (76520) Now the rule is: do not change Class if the to project has a null class
  || 05/13/10 GHL 10.523 (80709) Rolled back logic for same projects
  || 09/25/13 GHL 10.572 Added multi currency fields
  || 10/14/14 GHL 10.585 (224560) Added update of RootTransferFromKey + doublecheck the TransferFromKey
  || 01/06/15 GHL 10.588 Added @AdjustmentType to differentiate with real xfers (enh Abelson Taylor)
  ||                     We do a Xfer when undoing WO after posting to WIP
  || 02/24/15 GHL 10.589 When performing a reversal after an 'Undo Write Off', the reversal should be written off, not marked as billed
  */
  
	DECLARE @TransferToKey INT
	DECLARE @ReversalDetailKey INT
	DECLARE @Error INT
	
		  
	-- Vars needed for spProcessTranTransferBilling
	Declare @OrigWIK int		-- WIPPostingInKey of the original initial tran, could be -1
	Declare @OrigWOK int		-- WIPPostingOutKey of the original initial tran
	Declare @OrigILK int		-- InvoiceLineKey
	Declare @OrigWO int			-- WriteOff
	Declare @OrigWOReasonKey int-- WriteOff reason
	Declare @OrigDB datetime	-- DateBilled	
	Declare @OrigAB money		-- AmountBilled
	Declare @OrigBH decimal(24,4)-- BilledHours	
	Declare @OrigBR money       -- BilledRate
	Declare @ILK int 			-- InvoiceLineKey
	Declare @WO int 			-- WriteOff
	Declare @WOReasonKey int	-- WriteOff reason
	Declare @DB datetime		-- DateBilled	
	Declare @AB money			-- AmountBilled		  
	Declare @BH decimal(24,4)	-- BilledHours	
	Declare @BR money           -- BilledRate
			  
	-- Various vars
	Declare @ProjectKey int
	Declare @TaskKey int	
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
    Declare @OnHold tinyint
    Declare @BilledComment varchar(2000)
    Declare @DepartmentKey int
    Declare @OrigTransferComment varchar(2000)
    Declare @CompanyKey int
	Declare @ToClassKey int
	Declare @ExchangeRate decimal(24,7)
	Declare @CurrencyID varchar(10)
	Declare @RootTransferFromKey int

	--SELECT @TransferDate = CONVERT(SMALLDATETIME, (CONVERT(VARCHAR(10), GETDATE(), 101)), 101)
	
	Select 
		@OrigWIK = WIPPostingInKey
		,@OrigWOK = WIPPostingOutKey
		,@OrigILK = InvoiceLineKey
		,@OrigWO = WriteOff
		,@OrigWOReasonKey = WriteOffReasonKey
		,@OrigDB = DateBilled
		,@OrigAB = AmountBilled
	     
	    ,@ProjectKey = ProjectKey
	    ,@TaskKey = TaskKey
	    ,@ExpenseDate = ExpenseDate
		,@ShortDescription = ShortDescription
		,@LongDescription = LongDescription
		,@ItemKey = ItemKey
		,@ClassKey = ClassKey
		,@Quantity = Quantity
		,@UnitCost = UnitCost
		,@UnitDescription = UnitDescription
		,@TotalCost = TotalCost
		,@UnitRate = UnitRate
		,@Markup = Markup
		,@Billable = Billable
		,@BillableCost = BillableCost
		,@EnteredByKey = EnteredByKey
		,@DateEntered = DateEntered
        ,@JournalEntryKey = JournalEntryKey
        ,@OnHold = OnHold
        ,@DepartmentKey = DepartmentKey
        ,@OrigTransferComment = ISNULL(TransferComment, '')
        ,@TransferToKey = TransferToKey
        ,@ExchangeRate = ExchangeRate
		,@CurrencyID = CurrencyID
		,@RootTransferFromKey = RootTransferFromKey         
	From   tMiscCost (nolock)
	Where  MiscCostKey = @MiscCostKey
		
	If isnull(@TransferToKey, 0) <> 0
		return -1

	-- get new class
	select @CompanyKey = CompanyKey, @ToClassKey = ClassKey
	from tProject (nolock) where ProjectKey = @ToProjectKey
	
	if isnull(@ToClassKey, 0) = 0 select @ToClassKey = @ClassKey
	
	if @ToClassKey = 0 select @ToClassKey = null

	if exists (select 1 from tMiscCost mc (nolock)
				inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey
				where p.CompanyKey = @CompanyKey
				and   mc.TransferFromKey = @MiscCostKey
				)
				return -1


/* see explanations in time xfer		
	if @ProjectKey = @ToProjectKey 
	begin
		update tMiscCost set TaskKey = @ToTaskKey
		Where  MiscCostKey = @MiscCostKey
		
		return 1
	end
*/		
	Select @OrigBH = 0, @OrigBR = 0 -- Billed hours/rate only for time entries
	

	
	/*
	* First create a transaction for the new project and collect the new key
	*/
	
	-- the billing info will depend on the WIP keys
	exec spProcessTranTransferBilling @OrigWIK,@OrigWOK,'New',@TransferDate, 0, 0, @BillableCost
		,@OrigILK,@OrigDB,@OrigWO,@OrigWOReasonKey,@OrigAB,@OrigBH,@OrigBR
		,@ILK output	-- InvoiceLineKey
		,@DB output		-- DateBilled	
		,@WO output		-- WriteOff
		,@WOReasonKey output	-- WriteOff reason
		,@AB output		-- AmountBilled
		,@BH output		-- BilledHours
		,@BR output		-- BilledRate

	-- however if we undo a WriteOff, make it billable
	IF @AdjustmentType = 3
	begin
		select @ILK = null, @DB = null, @AB = null
	end

	BEGIN TRAN

	INSERT INTO tMiscCost
           (ProjectKey
           ,TaskKey
           ,ExpenseDate
           ,ShortDescription
           ,LongDescription
           ,ItemKey
           ,ClassKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,UnitRate
           ,Markup
           ,Billable
           ,BillableCost
           ,AmountBilled
           ,EnteredByKey
           ,DateEntered
           ,InvoiceLineKey
           ,WriteOff
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,TransferComment
           ,WriteOffReasonKey
           ,DateBilled
           ,JournalEntryKey
           ,OnHold
           ,BilledComment
           ,DepartmentKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
		   ,ExchangeRate
		   ,CurrencyID
		   ,RootTransferFromKey 
		   )
     VALUES
           (@ToProjectKey
           ,@ToTaskKey
           ,@ExpenseDate
           ,@ShortDescription
           ,@LongDescription
           ,@ItemKey
           ,@ToClassKey
           ,@Quantity
           ,@UnitCost
           ,@UnitDescription
           ,@TotalCost
           ,@UnitRate
           ,@Markup
           ,@Billable
           ,@BillableCost
           ,@AB
           ,@EnteredByKey
           ,@DateEntered
           ,@ILK
           ,@WO
           ,0 --@WIPPostingInKey
           ,0--@WIPPostingOutKey
           --@TransferComment
           --Append: Transferred from old Project, old task
           --,@TransferFromComment + '<br>' + left(@OrigTransferComment, 500 - Len(@TransferFromComment)) 
           ,@TransferFromComment
           ,@WOReasonKey
           ,@DB --DateBilled
           ,@JournalEntryKey
           ,@OnHold
           ,@BilledComment
           ,@DepartmentKey
           ,@TransferDate -- TransferInDate
           ,NULL		--TransferOutDate
           ,@MiscCostKey --TransferFromKey
           ,NULL		--TransferToKey
		   ,@ExchangeRate
		   ,@CurrencyID
		   ,isnull(@RootTransferFromKey, @MiscCostKey)
		   )
   
	 SELECT @TransferToKey = @@IDENTITY, @Error = @@ERROR
	 
	 IF @Error <> 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END
	 	
	/*
	* Second create a transaction for the reversal of the old project 
	*/
	
	-- the billing info will depend on the WIP keys
	exec spProcessTranTransferBilling @OrigWIK,@OrigWOK,'Reversal',@TransferDate, 0, 0, @BillableCost
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
	IF @AdjustmentType = 3
	begin
		-- leave DateBilled as determined by spProcessTranTransferBilling, but change the WO stuff
		select @ILK = null, @AB = 0, @WO = 1, @WOReasonKey = @OrigWOReasonKey
	end

	INSERT INTO tMiscCost
           (ProjectKey
           ,TaskKey
           ,ExpenseDate
           ,ShortDescription
           ,LongDescription
           ,ItemKey
           ,ClassKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,UnitRate
           ,Markup
           ,Billable
           ,BillableCost
           ,AmountBilled
           ,EnteredByKey
           ,DateEntered
           ,InvoiceLineKey
           ,WriteOff
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,TransferComment
           ,WriteOffReasonKey
           ,DateBilled
           ,JournalEntryKey
           ,OnHold
           ,BilledComment
           ,DepartmentKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
		   ,ExchangeRate
		   ,CurrencyID
		   ,RootTransferFromKey
		   ,AdjustmentType
		   )
     VALUES
           (@ProjectKey
           ,@TaskKey
           ,@ExpenseDate
           ,@ShortDescription
           ,@LongDescription
           ,@ItemKey
           ,@ClassKey
           ,@Quantity * -1
           ,@UnitCost
           ,@UnitDescription
           ,@TotalCost * -1
           ,@UnitRate
           ,@Markup
           ,@Billable
           ,@BillableCost * -1
           ,@AB
           ,@EnteredByKey
           ,@DateEntered
           ,@ILK
           ,@WO
           ,-99 --@WIPPostingInKey
           ,-99--@WIPPostingOutKey
           ,'Reversal due to ' + @TransferToComment
            ,@WOReasonKey
           ,@DB --DateBilled
           ,@JournalEntryKey
           ,@OnHold
           ,@BilledComment
           ,@DepartmentKey
           ,@TransferDate -- TransferInDate
           ,@TransferDate -- TransferOutDate
           ,@MiscCostKey -- TransferFromKey
           ,@TransferToKey -- TransferToKey
		   ,@ExchangeRate
		   ,@CurrencyID
		   ,isnull(@RootTransferFromKey, @MiscCostKey)
		   ,@AdjustmentType
			)
   		
	 SELECT @ReversalDetailKey = @@IDENTITY, @Error = @@ERROR
	 
	 IF @Error <> 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END
	     
	/*     
    * Then update the inital transaction
    */
     
	-- the billing info will depend on the WIP keys
	exec spProcessTranTransferBilling @OrigWIK,@OrigWOK,'Initial',@TransferDate, 0, 0, @BillableCost
		,@OrigILK,@OrigDB,@OrigWO,@OrigWOReasonKey,@OrigAB,@OrigBH,@OrigBR
		,@ILK output	-- InvoiceLineKey
		,@DB output		-- DateBilled	
		,@WO output		-- WriteOff
		,@WOReasonKey output	-- WriteOff reason
		,@AB output		-- AmountBilled
		,@BH output		-- BilledHours
		,@BR output		-- BilledRate
     
     UPDATE tMiscCost
     SET    DateBilled = @DB
           ,InvoiceLineKey = @ILK 
           ,AmountBilled = @AB
           ,WriteOff = @WO
           ,WriteOffReasonKey = @WOReasonKey
           
           ,TransferComment = @TransferToComment 	
           ,TransferOutDate = @TransferDate
           ,TransferToKey = @TransferToKey
           ,RootTransferFromKey = isnull(RootTransferFromKey, MiscCostKey)
		   ,AdjustmentType = @AdjustmentType
	WHERE  MiscCostKey = @MiscCostKey
     	
	IF @@ERROR <> 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END
     	
	if (select count(*) from tMiscCost mc (nolock)
				inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey
				where p.CompanyKey = @CompanyKey
				and   mc.TransferFromKey = @MiscCostKey
				) > 2
	begin
		rollback tran
		return -1
	end

	COMMIT TRAN
		 	
	RETURN 1
GO
