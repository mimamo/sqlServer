USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessTranTransferVO]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessTranTransferVO]
	(
	@VoucherDetailKey int
	,@ToProjectKey int
	,@ToTaskKey int
	,@TransferDate smalldatetime
	,@TransferFromComment varchar(500)
	,@TransferToComment varchar(500)
	,@IOClientLink int
	,@BCClientLink int
	,@AdjustmentType smallint = 0
	)
AS
	SET NOCOUNT ON

  /*
  || When     Who Rel     What
  || 08/27/09 GHL 10.5  Creation for new transfers 
  ||                    Since there is an impact on GL, we need to do the following:
  ||                    - Create one tran for the new project (and get the TransferToKey)
  ||                    - Create one tran to reverse the initial transaction (old project)
  ||                    - Modify the initial transaction    
  ||                    - + 2 GL transactions   
  ||                    - Also modify the associated Expense receipt 
  ||                    - we will not transfer voucher lines which have prebilled orders 
  ||                     so no effect on transaction order accrual
  || 09/29/09 GHL 10.5  Added update of tTransaction.Overhead
  || 11/04/09 GHL 10.513 Changed DateBilled to PostingDate on the initial transaction  
  || 11/05/09 GHL 10.513 Added checking of TransferToKey before transferring  
  || 11/16/09 GHL 10.513 (68471) When creating the new GL transaction, use OfficeKey/ClassKey from project 
  || 12/21/09 GHL 10.515 (70850) Limiting now transfer comment to current transfer rather than appending 
  ||                     to old comments because it was causing an overflow 
  || 01/14/10 GHL 10.517 Move taxes with the new transaction
  || 03/12/10 GHL 10.519 (76520) Now the rule is: do not change Class if the to project has a null class  
  || 05/13/10 GHL 10.523 (80709) Rolled back logic for same projects
  || 08/27/10 GWG 10.534 (88720) Changed the source company key logic, for vouchers, this is not the client key.
  || 10/13/11 GHL 10.459 Added new entity CREDITCARD
  || 09/25/13 GHL 10.572 Added multi currency fields
  || 10/16/13 GHL 10.573 Added Commission, GrossAmount
  || 10/14/14 GHL 10.585 (224560) Added update of RootTransferFromKey + doublecheck the TransferFromKey
  || 01/06/14 GHL 10.588 Added @AdjustmentType to differentiate with real xfers (enh Abelson Taylor)
  ||                     We do a Xfer when undoing WO after posting to WIP
  || 02/21/15 GHL 10.589 (246171) Problem when a voucher detail is posted, billed, voided, then transferred to another project
  ||                     The reversal is missing a client, because there is no adjustment to voucher posting during client invoice void
  ||                     So there is no old transaction key, the client is null, the fix is to pull the client from the voucher detail upfront
 */
  
	DECLARE @TransferToKey INT
	DECLARE @ReversalDetailKey INT
	DECLARE @Error INT
	
	-- vars needed to determine the new client, new Office, new Class
	Declare @ToClientKey int
	Declare @ItemKey int
	Declare @PurchaseOrderDetailKey int
	Declare @ToOfficeKey int
	Declare @ToClassKey int
	
	-- Vars needed for spProcessTranTransferBilling
	Declare @OrigWIK int		-- WIPPostingInKey of the original initial tran, could be -1
	Declare @OrigWOK int		-- WIPPostingOutKey of the original initial tran
	Declare @Type varchar(20)	-- Initial, Reversal, New
	
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
	Declare @BR money			-- BilledRate
			  
	-- Various vars
	Declare @CompanyKey int
	Declare @VoucherKey int
	Declare @VoucherPostingDate datetime
	Declare @Posted int
	Declare @OpeningTransaction int
	Declare @InvoiceNumber varchar(250)
    Declare @OrigTransferComment varchar(2000)
	
	-- for the GL trans	
	Declare @OldTransactionKey int
	Declare @TransactionKey int
	Declare @GLAccountKey int
	Declare @ClassKey int
	Declare @ClientKey int
	Declare @ProjectKey int
	Declare @GLCompanyKey int
	Declare @OfficeKey int
	Declare @DepartmentKey int
	Declare @Reference varchar(50)
	Declare @PostingDate datetime
	Declare @Memo varchar(500)
	Declare @PostSide char(1)
	Declare @ReversalPostSide char(1)
	Declare @Amount money
    Declare @ShortDescription varchar(400)
    Declare @BillableCost money
    Declare @Overhead tinyint
	Declare @SourceCompanyKey int
    Declare @Entity varchar(20)
	Declare @CreditCard int
	Declare @ExchangeRate decimal(24,7)
	Declare @CurrencyID varchar(10)
	Declare @HAmount money
	
	--SELECT @TransferDate = CONVERT(SMALLDATETIME, (CONVERT(VARCHAR(10), GETDATE(), 101)), 101)
	
	Select @ItemKey = vd.ItemKey
	      ,@PurchaseOrderDetailKey = ISNULL(vd.PurchaseOrderDetailKey, 0)	
	      ,@OrigWIK = vd.WIPPostingInKey
	      ,@OrigWOK = vd.WIPPostingOutKey
	      ,@OrigILK = vd.InvoiceLineKey
	      ,@OrigWO = vd.WriteOff
	      ,@OrigWOReasonKey = vd.WriteOffReasonKey
	      ,@OrigDB = vd.DateBilled
	      ,@OrigAB = vd.AmountBilled
	      ,@CompanyKey = v.CompanyKey
		  ,@GLCompanyKey = v.GLCompanyKey
		  ,@InvoiceNumber = v.InvoiceNumber
	      ,@VoucherKey = vd.VoucherKey
	      ,@Posted = v.Posted
          ,@OpeningTransaction = isnull(v.OpeningTransaction, 0)	
		  ,@OfficeKey =	vd.OfficeKey
		  ,@DepartmentKey = vd.DepartmentKey
		  ,@ClassKey = vd.ClassKey
		  ,@GLAccountKey = vd.ExpenseAccountKey
		  ,@Amount = vd.TotalCost
		  ,@BillableCost = vd.BillableCost
		  ,@ShortDescription = left(rtrim(ltrim(vd.ShortDescription)), 400)
		  ,@OrigTransferComment = ISNULL(TransferComment, '')
          ,@VoucherPostingDate = v.PostingDate
	      ,@TransferToKey = TransferToKey
          ,@ProjectKey = vd.ProjectKey
          ,@CreditCard = isnull(CreditCard, 0)

		  -- This currency info is linked to the Vendor, not the project
		  ,@CurrencyID = v.CurrencyID
		  ,@ExchangeRate = isnull(v.ExchangeRate, 1)
		  ,@HAmount = ROUND(vd.TotalCost * isnull(v.ExchangeRate, 1), 2)

		  ,@ClientKey = vd.ClientKey -- 246171

	From   tVoucherDetail vd (nolock)
	   Inner Join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
	Where  vd.VoucherDetailKey = @VoucherDetailKey
		
	If isnull(@TransferToKey, 0) <> 0
		return -1

	If exists (select 1 from tVoucherDetail -- no (nolock) on purpose
		where VoucherKey = @VoucherKey -- all transfers should have the same header
		and   TransferFromKey = @VoucherDetailKey
		)
		return -1

	if @CreditCard = 1
		select @Entity = 'CREDITCARD'
	else
		select @Entity = 'VOUCHER'
	
/* see explanations in time xfer		
	if @ProjectKey = @ToProjectKey 
	begin
		update tVoucherDetail set TaskKey = @ToTaskKey
		Where  VoucherDetailKey = @VoucherDetailKey	
		
		return 1
	end
*/
		
	Select @OrigBH = 0, @OrigBR = 0 -- Billed hours/rate only for time entries
		
	-- we must determine the new client
	EXEC sptVoucherDetailFindClient @ToProjectKey, @ItemKey, @PurchaseOrderDetailKey, @IOClientLink ,@BCClientLink ,@ToClientKey output	

	-- and new office/class
	select @ToOfficeKey = OfficeKey, @ToClassKey = ClassKey
	from tProject (nolock) where ProjectKey = @ToProjectKey
	
	if isnull(@ToClassKey, 0) = 0
		select @ToClassKey = @ClassKey
	
	if @ToOfficeKey = 0 select @ToOfficeKey = null
	if @ToClassKey = 0 select @ToClassKey = null
	
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
	
	INSERT INTO tVoucherDetail
           (VoucherKey
           ,LinkID
           ,LineNumber
           ,PurchaseOrderDetailKey
           ,ClientKey
           ,ProjectKey
           ,TaskKey
           ,ShortDescription
           ,ItemKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,Billable
           ,Markup
           ,BillableCost
           ,AmountBilled
           ,InvoiceLineKey
           ,WriteOff
           ,PrebillAmount
           ,ExpenseAccountKey
           ,ClassKey
           ,QuantityBilled
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,TransferComment
           ,WriteOffReasonKey
           ,DatePaidByClient
           ,DateBilled
           ,Taxable
           ,Taxable2
           ,OnHold
           ,FinalForPO
           ,BilledComment
           ,LastVoucher
           ,UnitRate
           ,OfficeKey
           ,DepartmentKey
           ,OldExpenseAccountKey
           ,AccruedExpenseOutAccountKey
           ,SourceDate
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
           ,SalesTaxAmount
           ,SalesTax1Amount
           ,SalesTax2Amount
		   ,PExchangeRate
		   ,PCurrencyID 
		   ,PTotalCost
		   ,Commission
		   ,GrossAmount
		   ,RootTransferFromKey
			)
     	
	SELECT  VoucherKey
           ,LinkID					-- Important, must be copied
           ,LineNumber
           ,PurchaseOrderDetailKey	-- Important, must be copied
           ,@ToClientKey
           ,@ToProjectKey
           ,@ToTaskKey
           ,ShortDescription
           ,ItemKey
           ,Quantity 
           ,UnitCost
           ,UnitDescription
           ,TotalCost 
           ,Billable
           ,Markup
           ,BillableCost 
           ,@AB			-- AmountBilled
           ,@ILK		-- InvoiceLineKey
           ,@WO			-- WriteOff
           ,PrebillAmount -- Important, must be copied
           ,ExpenseAccountKey
           ,@ToClassKey
           ,0			-- QuantityBilled
           ,0			-- WIPPostingInKey
           ,0			-- WIPPostingOutKey
           --@TransferComment
           --Append: Transferred from old Project, old task
           --,@TransferFromComment + '<br>' + left(@OrigTransferComment, 500 - Len(@TransferFromComment)) 
           ,@TransferFromComment
           ,@WOReasonKey
           ,DatePaidByClient
           ,@DB			-- DateBilled
           ,Taxable
           ,Taxable2
           ,OnHold
           ,FinalForPO	-- Important must be copied
           ,BilledComment
           ,LastVoucher
           ,UnitRate
           ,@ToOfficeKey
           ,DepartmentKey
           ,OldExpenseAccountKey
           ,AccruedExpenseOutAccountKey 
           ,SourceDate
           ,@TransferDate -- TransferInDate
           ,NULL		--TransferOutDate
           ,@VoucherDetailKey --TransferFromKey
           ,NULL		--TransferToKey
           ,SalesTaxAmount
           ,SalesTax1Amount
           ,SalesTax2Amount
		   ,PExchangeRate
		   ,PCurrencyID 
		   ,PTotalCost
		   ,Commission
		   ,GrossAmount
		   ,isnull(RootTransferFromKey, VoucherDetailKey)
     FROM  tVoucherDetail (NOLOCK)
     WHERE VoucherDetailKey = @VoucherDetailKey 
     
	 SELECT @TransferToKey = @@IDENTITY, @Error = @@ERROR
	 
	 IF @Error <> 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END
	 
	 -- the voucher detail tax record must follow the record	
	 UPDATE tVoucherDetailTax
	 SET    VoucherDetailKey = @TransferToKey
	 WHERE  VoucherDetailKey = @VoucherDetailKey 
	  
	 IF @@ERROR <> 0
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
			
	INSERT INTO tVoucherDetail
           (VoucherKey
           ,LinkID
           ,LineNumber
           ,PurchaseOrderDetailKey
           ,ClientKey
           ,ProjectKey
           ,TaskKey
           ,ShortDescription
           ,ItemKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,Billable
           ,Markup
           ,BillableCost
           ,AmountBilled
           ,InvoiceLineKey
           ,WriteOff
           ,PrebillAmount
           ,ExpenseAccountKey
           ,ClassKey
           ,QuantityBilled
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,TransferComment
           ,WriteOffReasonKey
           ,DatePaidByClient
           ,DateBilled
           ,Taxable
           ,Taxable2
           ,OnHold
           ,FinalForPO
           ,BilledComment
           ,LastVoucher
           ,UnitRate
           ,OfficeKey
           ,DepartmentKey
           ,OldExpenseAccountKey
           ,AccruedExpenseOutAccountKey
           ,SourceDate
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
		   ,PExchangeRate
		   ,PCurrencyID 
		   ,PTotalCost
           ,Commission
		   ,GrossAmount
		   ,RootTransferFromKey
		   ,AdjustmentType
		    )
     	
	SELECT  VoucherKey
           ,NULL				-- LinkID Important!!!! We disconnect for Strata
           ,LineNumber
           ,NULL				-- PurchaseOrderDetailKey Important!!!! We disassociate from the PO
           ,ClientKey
           ,ProjectKey
           ,TaskKey
           ,ShortDescription
           ,ItemKey
           ,CASE WHEN ISNULL(Quantity, 0) = 0 THEN -1 ELSE -1 * Quantity END
           ,UnitCost
           ,UnitDescription
           ,TotalCost * -1
           ,Billable
           ,Markup
           ,BillableCost * -1
           ,@AB			-- AmountBilled
           ,@ILK		-- InvoiceLineKey
           ,@WO			-- WriteOff
           ,0			-- PrebillAmount, Important!!!!!! We disassociate from the PO
           ,ExpenseAccountKey
           ,ClassKey
           ,0			-- QuantityBilled
           ,-99			-- WIPPostingInKey, will not be put again in WIP
           ,-99			-- WIPPostingOutKey
           --,@TransferComment
           ,'Reversal due to ' + @TransferToComment
           ,@WOReasonKey
           ,DatePaidByClient
           ,@DB			-- DateBilled
           ,0 --Taxable
           ,0 --Taxable2
           ,OnHold
           ,FinalForPO
           ,BilledComment
           ,LastVoucher
           ,UnitRate
           ,OfficeKey
           ,DepartmentKey
           ,OldExpenseAccountKey
           ,AccruedExpenseOutAccountKey
           ,SourceDate
           ,@TransferDate -- TransferInDate
           ,@TransferDate -- TransferOutDate
           ,@VoucherDetailKey -- TransferFromKey
           ,@TransferToKey -- TransferToKey
           ,PExchangeRate
		   ,PCurrencyID 
		   ,PTotalCost * -1
		   ,Commission
		   ,GrossAmount * -1  
		   ,isnull(RootTransferFromKey, VoucherDetailKey)
		   ,@AdjustmentType
     FROM  tVoucherDetail (NOLOCK)
     WHERE VoucherDetailKey = @VoucherDetailKey 

	 SELECT @ReversalDetailKey = @@IDENTITY, @Error = @@ERROR
	 
	 IF @Error <> 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END
	    
	if (select count(*) from tVoucherDetail -- no (nolock) on purpose
		where VoucherKey = @VoucherKey -- all transfers should have the same header
		and   TransferFromKey = @VoucherDetailKey
		) > 2
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
     
     UPDATE tVoucherDetail
     SET    LinkID = null -- disconnect from Strata
           ,PrebillAmount = 0 
           ,PurchaseOrderDetailKey = null -- disconnect from PO
     
           ,DateBilled = @DB
           ,InvoiceLineKey = @ILK 
           ,AmountBilled = @AB
           ,WriteOff = @WO
           ,WriteOffReasonKey = @WOReasonKey
           
           ,TransferComment = @TransferToComment 	
           ,TransferOutDate = @TransferDate
           ,TransferToKey = @TransferToKey
           
           -- this has been moved to the new one
           ,Taxable = 0
           ,Taxable2 = 0
           ,SalesTaxAmount = 0
           ,SalesTax1Amount = 0
           ,SalesTax2Amount = 0

		   ,RootTransferFromKey = isnull(RootTransferFromKey, VoucherDetailKey)
		   ,AdjustmentType = @AdjustmentType
	WHERE  VoucherDetailKey = @VoucherDetailKey
     	
	IF @@ERROR <> 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END
     	
	/*     
    * The Expense Receipt associated with the initial transaction must be updated 
    */
     	
    -- move the associated expense receipts
	UPDATE tExpenseReceipt
	SET	   tExpenseReceipt.TransferComment		= @TransferToComment
	      ,tExpenseReceipt.ProjectKey			= @ToProjectKey
	      ,tExpenseReceipt.TaskKey				= @ToTaskKey	
	      ,tExpenseReceipt.VoucherDetailKey		= @TransferToKey
	Where tExpenseReceipt.VoucherDetailKey		= @VoucherDetailKey	
	
	IF @@ERROR <> 0
	 BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END

	IF @Posted = 0
	BEGIN
	    COMMIT TRAN
		RETURN 1 
	END
			
	IF @OpeningTransaction = 1
	BEGIN
		COMMIT TRAN
		RETURN 1 
	END
			
	/*     
    * Now add corrections to the GL (because it should show an expense for the right project)
    */
	
	Select @OldTransactionKey = TransactionKey
	From   tTransaction (NOLOCK)
	Where  Entity in ('VOUCHER', 'CREDITCARD')
	And    EntityKey = @VoucherKey
	And    Section = 2
	And    DetailLineKey = @VoucherDetailKey

	If @@ROWCOUNT <> 0
		SELECT @Reference = Reference, @Entity = Entity, @GLAccountKey = GLAccountKey, @SourceCompanyKey = SourceCompanyKey
					, @ClassKey = ClassKey, @ClientKey = ClientKey, @ProjectKey = ProjectKey
					, @GLCompanyKey = GLCompanyKey, @OfficeKey = OfficeKey, @DepartmentKey = DepartmentKey
					, @PostingDate = TransactionDate, @Memo = Memo, @PostSide = PostSide, @Overhead = isnull(Overhead, 0)
					, @CurrencyID = CurrencyID, @ExchangeRate = ExchangeRate, @HAmount = ISNULL(HDebit, 0) + ISNULL(HCredit, 0)
		FROM  tTransaction (NOLOCK) WHERE TransactionKey = @OldTransactionKey		 	
	Else
		Select @Memo = 'Voucher # ' + @InvoiceNumber + ' ' + @ShortDescription
			  ,@Reference = @InvoiceNumber
			  ,@PostSide = 'D'
			  		  
	-- reversal of old project 
	IF @PostSide = 'C'
		SELECT @ReversalPostSide = 'D'
	ELSE
		SELECT @ReversalPostSide = 'C'

	exec @TransactionKey = spGLInsertTran @CompanyKey, @ReversalPostSide, @TransferDate, @Entity, @VoucherKey, 
		@Reference, @GLAccountKey, @Amount, @ClassKey,@Memo, @ClientKey, @ProjectKey, @SourceCompanyKey
		, NULL, @GLCompanyKey, @OfficeKey, @DepartmentKey, @ReversalDetailKey, 2, @Overhead, @CurrencyID, @ExchangeRate, @HAmount
		
	IF @@ERROR <> 0
	BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END

	-- If spGLInsertTran fails, it will return 0, so test NULL or 0
	If ISNULL(@TransactionKey, 0) = 0
	BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END

	SELECT @Overhead = Overhead
	FROM   tCompany (nolock)
	WHERE  CompanyKey = @ToClientKey
	
	SELECT @Overhead = ISNULL(@Overhead, 0)
	
	-- add new project 
	exec @TransactionKey = spGLInsertTran @CompanyKey, @PostSide, @TransferDate, @Entity, @VoucherKey, 
		@Reference, @GLAccountKey, @Amount, @ToClassKey,@Memo, @ToClientKey, @ToProjectKey, @SourceCompanyKey
		, NULL, @GLCompanyKey, @ToOfficeKey, @DepartmentKey, @TransferToKey, 2, @Overhead, @CurrencyID, @ExchangeRate, @HAmount
		
	IF @@ERROR <> 0
	BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END

	-- If spGLInsertTran fails, it will return 0, so test NULL or 0
	If ISNULL(@TransactionKey, 0) = 0
	BEGIN	
		ROLLBACK TRAN
		RETURN -1
	 END
		 
	COMMIT TRAN
		 	
	RETURN 1
GO
