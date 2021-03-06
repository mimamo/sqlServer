USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessTranTransferER]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessTranTransferER]
	(
	@ExpenseReceiptKey int
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
  ||                    The transaction for the new project should point to the VoucherDetailKey
  || 11/04/09 GHL 10.513 Changed DateBilled to ExpenseDate on the initial transaction
  || 11/05/09 GHL 10.513 Added checking of TransferToKey before transferring
  || 12/21/09 GHL 10.515 (70850) Limiting now transfer comment to current transfer rather than appending 
  ||                     to old comments because it was causing an overflow 
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
	Declare @ExpenseEnvelopeKey int
	Declare @UserKey int
    Declare @ExpenseDate smalldatetime 
    Declare @ExpenseType int
    Declare @ProjectKey int
    Declare @TaskKey int
    Declare @PaperReceipt tinyint
    Declare @ActualQty decimal(24,4)
    Declare @ActualUnitCost money
    Declare @ActualCost money
    Declare @Billable tinyint
    Declare @Markup decimal(24,4)
    Declare @UnitRate money
    Declare @BillableCost money
    Declare @Description varchar(100)
    Declare @Comments varchar(500)
    Declare @AmountBilled money
    Declare @OnHold tinyint
    Declare @BilledComment varchar(2000)
    Declare @VoucherDetailKey int
    Declare @Downloaded tinyint
    Declare @ItemKey int
    Declare @OrigTransferComment varchar(2000)
	Declare @PExchangeRate decimal(24,7)
	Declare @PCurrencyID varchar(10)
	Declare @PTotalCost money
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
	     
	    ,@ExpenseEnvelopeKey = ExpenseEnvelopeKey
		,@UserKey = UserKey
		,@ExpenseDate = ExpenseDate
		,@ExpenseType = ExpenseType
		,@ProjectKey = ProjectKey
		,@TaskKey = TaskKey
		,@PaperReceipt = PaperReceipt
		,@ActualQty = ActualQty
		,@ActualUnitCost = ActualUnitCost
		,@ActualCost = ActualCost
		,@Billable = Billable
		,@Markup = Markup
		,@BillableCost = BillableCost
		,@Description = Description
		,@Comments = Comments
		,@Downloaded = Downloaded
		,@OnHold = OnHold
		,@BilledComment = BilledComment
		,@UnitRate = UnitRate
		,@VoucherDetailKey = VoucherDetailKey
		,@ItemKey = ItemKey
		,@OrigTransferComment = ISNULL(TransferComment, '')
		,@TransferToKey = TransferToKey
		,@PExchangeRate = PExchangeRate
		,@PCurrencyID = PCurrencyID 
		,@PTotalCost = PTotalCost
		,@RootTransferFromKey = RootTransferFromKey     
	From   tExpenseReceipt (nolock)
	Where  ExpenseReceiptKey = @ExpenseReceiptKey
			
	If isnull(@TransferToKey, 0) <> 0
		return -1
		
	If exists (select 1 from tExpenseReceipt (nolock)
				where ExpenseEnvelopeKey = @ExpenseEnvelopeKey
				and   TransferFromKey = @ExpenseReceiptKey)
		return -1

/* see explanations in time xfer		
	if @ProjectKey = @ToProjectKey 
	begin
		update tExpenseReceipt set TaskKey = @ToTaskKey
		Where  ExpenseReceiptKey = @ExpenseReceiptKey
		
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

	INSERT INTO tExpenseReceipt
           (ExpenseEnvelopeKey
		  ,UserKey
		  ,ExpenseDate
		  ,ExpenseType
		  ,ProjectKey
		  ,TaskKey
		  ,PaperReceipt
		  ,ActualQty
		  ,ActualUnitCost
		  ,ActualCost
		  ,Billable
		  ,Markup
		  ,BillableCost
		  ,Description
		  ,Comments
		  ,AmountBilled
		  ,InvoiceLineKey
		  ,WriteOff
		  ,Downloaded
		  ,WIPPostingInKey
		  ,WIPPostingOutKey
		  ,TransferComment
		  ,WriteOffReasonKey
		  ,DateBilled
		  ,OnHold
		  ,BilledComment
		  ,UnitRate
		  ,VoucherDetailKey
		  ,ItemKey
		  ,TransferInDate
		  ,TransferOutDate
		  ,TransferFromKey
		  ,TransferToKey
		  ,PExchangeRate
		  ,PCurrencyID 
		  ,PTotalCost
		  ,RootTransferFromKey
		  )
		 VALUES 
		  (@ExpenseEnvelopeKey
		  ,@UserKey
		  ,@ExpenseDate
		  ,@ExpenseType
		  ,@ToProjectKey
		  ,@ToTaskKey
		  ,@PaperReceipt
		  ,@ActualQty
		  ,@ActualUnitCost
		  ,@ActualCost
		  ,@Billable
		  ,@Markup
		  ,@BillableCost
		  ,@Description
		  ,@Comments
		  ,@AB --AmountBilled
		  ,@ILK --InvoiceLineKey
		  ,@WO --WriteOff
		  ,@Downloaded
		  ,0 --WIPPostingInKey
		  ,0 --WIPPostingOutKey
		   --@TransferComment
           --Append: Transferred from old Project, old task
          --,@TransferFromComment + '<br>' + left(@OrigTransferComment, 500 - Len(@TransferFromComment)) 
		  ,@TransferFromComment
		  ,@WOReasonKey --WriteOffReasonKey
		  ,@DB --DateBilled
		  ,@OnHold
		  ,@BilledComment
		  ,@UnitRate
		  ,@VoucherDetailKey
		  ,@ItemKey
		  ,@TransferDate -- TransferInDate
          ,NULL		--TransferOutDate
          ,@ExpenseReceiptKey --TransferFromKey
          ,NULL		--TransferToKey 
		  ,@PExchangeRate
		  ,@PCurrencyID 
		  ,@PTotalCost
		  ,isnull(@RootTransferFromKey, @ExpenseReceiptKey)
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

	INSERT INTO tExpenseReceipt
           (ExpenseEnvelopeKey
		  ,UserKey
		  ,ExpenseDate
		  ,ExpenseType
		  ,ProjectKey
		  ,TaskKey
		  ,PaperReceipt
		  ,ActualQty
		  ,ActualUnitCost
		  ,ActualCost
		  ,Billable
		  ,Markup
		  ,BillableCost
		  ,Description
		  ,Comments
		  ,AmountBilled
		  ,InvoiceLineKey
		  ,WriteOff
		  ,Downloaded
		  ,WIPPostingInKey
		  ,WIPPostingOutKey
		  ,TransferComment
		  ,WriteOffReasonKey
		  ,DateBilled
		  ,OnHold
		  ,BilledComment
		  ,UnitRate
		  ,VoucherDetailKey
		  ,ItemKey
		  ,TransferInDate
		  ,TransferOutDate
		  ,TransferFromKey
		  ,TransferToKey
		  ,PExchangeRate
		  ,PCurrencyID 
		  ,PTotalCost
		  ,RootTransferFromKey 
		  ,AdjustmentType
		  )
		 VALUES 
		  (@ExpenseEnvelopeKey
		  ,@UserKey
		  ,@ExpenseDate
		  ,@ExpenseType
		  ,@ProjectKey
		  ,@TaskKey
		  ,@PaperReceipt
		  ,@ActualQty * -1
		  ,@ActualUnitCost
		  ,@ActualCost * -1
		  ,@Billable
		  ,@Markup
		  ,@BillableCost * -1
		  ,@Description
		  ,@Comments
		  ,@AB --AmountBilled
		  ,@ILK --InvoiceLineKey
		  ,@WO --WriteOff
		  ,@Downloaded
		  ,-99 --WIPPostingInKey
		  ,-99 --WIPPostingOutKey
		   --,@TransferComment
           ,'Reversal due to ' + @TransferToComment
		  ,@WOReasonKey --WriteOffReasonKey
		  ,@DB --DateBilled
		  ,@OnHold
		  ,@BilledComment
		  ,@UnitRate
		  ,null--@VoucherDetailKey
		  ,@ItemKey
          ,@TransferDate -- TransferInDate
          ,@TransferDate -- TransferOutDate
          ,@ExpenseReceiptKey -- TransferFromKey
          ,@TransferToKey -- TransferToKey
		  ,@PExchangeRate
		  ,@PCurrencyID 
		  ,@PTotalCost * -1
		  ,isnull(@RootTransferFromKey, @ExpenseReceiptKey)
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
     
     UPDATE tExpenseReceipt
     SET    DateBilled = @DB
			,InvoiceLineKey = @ILK 
           ,AmountBilled = @AB
           ,WriteOff = @WO
           ,WriteOffReasonKey = @WOReasonKey
           
           ,TransferComment = @TransferToComment 	
           ,TransferOutDate = @TransferDate
           ,TransferToKey = @TransferToKey
           
           ,VoucherDetailKey = null
		   ,RootTransferFromKey = isnull(@RootTransferFromKey, @ExpenseReceiptKey)
		   ,AdjustmentType = @AdjustmentType

	WHERE  ExpenseReceiptKey = @ExpenseReceiptKey
     	
	IF @@ERROR <> 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END
     	
	If (select count(*) from tExpenseReceipt (nolock)
				where ExpenseEnvelopeKey = @ExpenseEnvelopeKey
				and   TransferFromKey = @ExpenseReceiptKey)
		> 2
		begin
			rollback tran	
			return -1
		end

	COMMIT TRAN
		 	
	RETURN 1
GO
