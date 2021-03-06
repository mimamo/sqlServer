USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPrePostVoucher]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPrePostVoucher]

	(
		@CompanyKey int,
		@VoucherKey int
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 1/3/07   CRG 8.4     Prebill accrual reversals have been modified to post with the correct ClientKey.
|| 1/23/07  GHL 8.4     Changed from spGLInsertTran to spGLPrePostInsertTran for unapplied amounts
||                      Corrected problem with APAccountKey 
|| 1/31/07  RTC 8.4.0.2 Corrected exec of spGLPrePostInsertTran for unapplied amounts   
|| 03/26/07 GHL 8.41    Added logic for @WIPRecognizeCostRev case   
||                                            
*/
  
Declare @RequireAccounts tinyint
Declare @PostToGL tinyint
Declare @VoucherStatus smallint
Declare @GLKey int
Declare @CurKey int
Declare @GLClosedDate smalldatetime

Declare @InvoiceNumber varchar(100)
Declare @TransactionDate smalldatetime
Declare @EntityKey int
Declare @GLAccountKey int
Declare @Amount money
Declare @ClassKey int
Declare @Memo varchar(500)
Declare @ProjectKey int
Declare @VendorKey int
Declare @RetVal int
Declare @VendorID varchar(100)
Declare @LineSubject varchar(500)
Declare @Posted tinyint
Declare @POAccruedExpenseAccountKey int
Declare @POPrebillAccrualAccountKey int
Declare @ClientKey int

Declare @SalesTaxKey int
Declare @SalesTaxAccountKey int
Declare @SalesTaxAmount money
Declare @SalesTax2Key int
Declare @SalesTax2AccountKey int
Declare @SalesTax2Amount money
Declare @UnappliedAccountKey int, @UnappliedAmount money
Declare @APAccountKey int

Declare @WIPRecognizeCostRev tinyint
Declare @WIPMediaAssetAccountKey int
Declare @WIPExpenseAssetAccountKey int
declare @RowNum int

Select
	 @RequireAccounts = ISNULL(RequireGLAccounts, 0)
	,@PostToGL = ISNULL(PostToGL, 0)
	,@GLClosedDate = GLClosedDate
	,@POAccruedExpenseAccountKey = POAccruedExpenseAccountKey
	,@POPrebillAccrualAccountKey = POPrebillAccrualAccountKey
	
	,@WIPRecognizeCostRev = ISNULL(WIPRecognizeCostRev, 0)
	,@WIPMediaAssetAccountKey = WIPMediaAssetAccountKey
	,@WIPExpenseAssetAccountKey = WIPExpenseAssetAccountKey

From
	tPreference (nolock)
Where
	CompanyKey = @CompanyKey

IF @WIPRecognizeCostRev = 1
Begin
		Create Table #Sales
		(
			RowNum int NOT NULL IDENTITY(1,1),
			ClientKey int,
			ProjectKey int,
			POKind int,
			ClassKey int,
			SalesAccountKey int,
			Amount money
		)

		--CREATE CLUSTERED INDEX IX_temp ON #Sales (RowNumber)

End

Select 
	 @VoucherStatus = Status
	,@EntityKey = VoucherKey
	,@VendorID = rtrim(ltrim(c.VendorID))
	,@TransactionDate = PostingDate
	,@EntityKey = VoucherKey
	,@APAccountKey = ISNULL(APAccountKey, 0)
	,@Amount = ISNULL(VoucherTotal, 0)
	,@ClassKey = ClassKey
	,@InvoiceNumber = rtrim(ltrim(InvoiceNumber))
	,@ProjectKey = ProjectKey
	,@VendorKey = c.CompanyKey
	,@Posted = Posted
	,@SalesTaxKey = v.SalesTaxKey
	,@SalesTaxAmount = ISNULL(v.SalesTax1Amount, 0)
	,@SalesTax2Key = v.SalesTax2Key
	,@SalesTax2Amount = ISNULL(v.SalesTax2Amount, 0)	
From tVoucher v (nolock)
	inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
Where v.VoucherKey = @VoucherKey


Declare @VoucherDetailKey int
Declare @POKey int
Declare @LineAmount money
Declare @AppliedAmount money
Declare @OpenAmount money
Declare @CurPODetKey int, @CurPODetAmt money, @POPostedAmt money, @AccrualAmt money, @TotAccrualAmt money, @PreBillAmt money

Select @TotAccrualAmt = 0

Select @UnappliedAmount = Sum(Amount) from tPaymentDetail (nolock) Where VoucherKey = @VoucherKey and Prepay = 1

IF @PostToGL = 1
BEGIN

	-- Post the header
	Select @Memo = 'Invoice #' + @InvoiceNumber
	exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'VOUCHER', @EntityKey, @InvoiceNumber, @APAccountKey, @Amount, @ClassKey, @Memo, @ProjectKey, @VendorKey
	
	-- if there is a sales tax amount, post it
	if @SalesTaxAmount <> 0
	BEGIN
		Select @SalesTaxAccountKey = ISNULL(APPayableGLAccountKey, 0) from tSalesTax (nolock) Where SalesTaxKey = @SalesTaxKey
		Select @Memo = 'Sales Tax for Invoice #' + @InvoiceNumber
		exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'VOUCHER', @EntityKey, @InvoiceNumber, @SalesTaxAccountKey, @SalesTaxAmount, @ClassKey, @Memo, @ProjectKey, @VendorKey
	END

	-- if there is a sales tax 2 amount, post it
	if @SalesTax2Amount <> 0
	BEGIN
		Select @SalesTax2AccountKey = ISNULL(APPayableGLAccountKey, 0) from tSalesTax (nolock) Where SalesTaxKey = @SalesTax2Key
		Select @Memo = 'Sales Tax 2 for Invoice #' + @InvoiceNumber
		exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'VOUCHER', @EntityKey, @InvoiceNumber, @SalesTax2AccountKey, @SalesTax2Amount, @ClassKey, @Memo, @ProjectKey, @VendorKey

	END
	
	Select @CurKey = -1
	While 1=1
	BEGIN
		Select @CurKey = Min(VoucherDetailKey) from tVoucherDetail (nolock) Where VoucherKey = @VoucherKey and VoucherDetailKey > @CurKey
		if @CurKey is null
			break
			
		Select 
			 @GLAccountKey = ExpenseAccountKey
			,@Amount = TotalCost
			,@ClassKey = ClassKey
			,@ClientKey = ClientKey
			,@ProjectKey = ProjectKey
			,@LineSubject = ShortDescription
			,@CurPODetKey = ISNULL(PurchaseOrderDetailKey, 0)
			
		From tVoucherDetail (nolock)
		Where VoucherDetailKey = @CurKey
		
		if ISNULL(@ClientKey, 0) = 0 and @ProjectKey > 0
			Select @ClientKey = ClientKey from tProject (nolock) Where ProjectKey = @ProjectKey
		
		Select @Memo = Left('Invoice #' + @InvoiceNumber + ' - ' + rtrim(ltrim(ISNULL(@LineSubject, ''))), 500)

		exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'VOUCHER', @EntityKey, @InvoiceNumber, @GLAccountKey, @Amount, @ClassKey, @Memo, @ProjectKey, @VendorKey
		select @TotAccrualAmt = @TotAccrualAmt + ISNULL(Sum(PrebillAmount), 0) from tVoucherDetail (nolock) Where PurchaseOrderDetailKey = @CurPODetKey

	end
	
	if @TotAccrualAmt > 0
	BEGIN
	
		Select 
			 @ClassKey = ClassKey
			,@ProjectKey = ProjectKey
			,@VendorKey = VendorKey
		From tVoucher v (nolock) Where v.VoucherKey = @VoucherKey


		Declare @CurClient int
		Select @CurClient = -1
		While 1=1
		BEGIN
			Select @CurClient = MIN(i.ClientKey) from tVoucherDetail vd
				Inner join tPurchaseOrderDetail pod on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
				inner join tInvoiceLine il on pod.InvoiceLineKey = il.InvoiceLineKey
				inner join tInvoice i on il.InvoiceKey = i.InvoiceKey
				Where vd.VoucherKey = @VoucherKey and i.ClientKey > @CurClient
		
			if @CurClient is null
				Break
				
			Select @TotAccrualAmt = ISNULL(Sum(PrebillAmount), 0) from tVoucherDetail vd
				Inner join tPurchaseOrderDetail pod on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
				inner join tInvoiceLine il on pod.InvoiceLineKey = il.InvoiceLineKey
				inner join tInvoice i on il.InvoiceKey = i.InvoiceKey
				Where vd.VoucherKey = @VoucherKey and i.ClientKey = @CurClient
				
			exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'VOUCHER', @EntityKey, @InvoiceNumber, @POPrebillAccrualAccountKey, @TotAccrualAmt, @ClassKey, 'Reverse Prebill Accrual', @ProjectKey, @CurClient
			exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'VOUCHER', @EntityKey, @InvoiceNumber, @POAccruedExpenseAccountKey, @TotAccrualAmt, @ClassKey, 'Reverse Prebill Accrual', @ProjectKey, @CurClient
		END

	END
	
	
	if @UnappliedAmount > 0
	BEGIN
	
		DECLARE	@PrepaymentAccountKey int
	
		Select 
			 @ClassKey = ClassKey
			,@ProjectKey = ProjectKey
			,@VendorKey = VendorKey
		From tVoucher v (nolock) Where v.VoucherKey = @VoucherKey
		
		exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'VOUCHER', @EntityKey, @InvoiceNumber, @APAccountKey, @UnappliedAmount, @ClassKey, 'Reverse Prepayment Accrual', @ProjectKey, @VendorKey
		
		SELECT @PrepaymentAccountKey = -1
		WHILE 1=1
		BEGIN
			SELECT	@PrepaymentAccountKey = MIN(UnappliedPaymentAccountKey)
			FROM	tPayment
			INNER JOIN tPaymentDetail ON tPayment.PaymentKey = tPaymentDetail.PaymentKey
			Where VoucherKey = @VoucherKey and Prepay = 1 and UnappliedPaymentAccountKey > @PrepaymentAccountKey
			
			IF @PrepaymentAccountKey IS NULL
				BREAK
			
			Select @UnappliedAmount = Sum(Amount) FROM	tPayment
			INNER JOIN tPaymentDetail ON tPayment.PaymentKey = tPaymentDetail.PaymentKey
			Where VoucherKey = @VoucherKey and Prepay = 1 and UnappliedPaymentAccountKey = @PrepaymentAccountKey
			
			exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'VOUCHER', @EntityKey, @InvoiceNumber, @PrepaymentAccountKey, @UnappliedAmount, @ClassKey, 'Reverse Prepayment Accrual', @ProjectKey, @VendorKey
		
		END

	END

	-- Post the sales entries right now.
	if @WIPRecognizeCostRev = 1
	BEGIN
			
		Insert Into #Sales (ClientKey, ProjectKey, POKind, ClassKey, SalesAccountKey, Amount)
		Select
			p.ClientKey,
			p.ProjectKey,
			ISNULL(i.ItemType, 0),
			ISNULL(vd.ClassKey, 0),
			i.SalesAccountKey,
			ISNULL(Sum(vd.BillableCost), 0)
		From
			tVoucherDetail vd (nolock)
			inner join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
			inner join tItem i (nolock) on vd.ItemKey = i.ItemKey
		Where
			vd.VoucherKey = @VoucherKey
			and p.ClientKey is not null
			and p.NonBillable = 0
			
		Group By 
			p.ClientKey,
			p.ProjectKey,
			ISNULL(i.ItemType, 0),
			ISNULL(vd.ClassKey, 0),
			i.SalesAccountKey

		Delete #Sales Where Amount = 0

		Declare @POKind int
		Select @RowNum = -1
		While 1=1
		BEGIN
			Select @RowNum = MIN(RowNum) from #Sales Where RowNum > @RowNum
			if @RowNum is null
				Break
			Select	
			 @GLAccountKey = SalesAccountKey
			,@Amount = Amount
			,@ClassKey = ClassKey
			,@ClientKey = ClientKey
			,@ProjectKey = ProjectKey
			,@POKind = POKind
			From #Sales Where RowNum = @RowNum
			
			-- Post to the proper accrual account based on kind
			if @POKind = 0
				exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'VOUCHER', @EntityKey, @InvoiceNumber, @WIPExpenseAssetAccountKey, @Amount, @ClassKey, 'VI Post WIP Sales', @ClientKey, @ProjectKey
			else
				exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'VOUCHER', @EntityKey, @InvoiceNumber, @WIPMediaAssetAccountKey, @Amount, @ClassKey, 'VI Post WIP Sales', @ClientKey, @ProjectKey
			
			exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'VOUCHER', @EntityKey, @InvoiceNumber, @GLAccountKey, @Amount, @ClassKey, 'VI Post WIP Sales', @ClientKey, @ProjectKey


		END

	END
	

end



return 1
GO
