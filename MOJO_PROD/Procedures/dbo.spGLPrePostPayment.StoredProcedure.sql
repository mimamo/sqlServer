USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPrePostPayment]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPrePostPayment]

	(
		@CompanyKey int,
		@PaymentKey int
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 10/18/06 CRG 8.35  Modified PrePosting routine to match the posting routine.
||                    Added posting of Unapplied Amount.
||                    Changed SourceCompanyKey to VendorKey in the calls to the InsertTran SPs (to match the posting routine).
|| 11/3/06  CRG 8.35  Added query to get the DiscountAccountKey for preposting of discounts.
*/

Declare @CurKey int
Declare @Memo varchar(500)

Declare @PaymentAmount money
Declare @DiscountAmount money
Declare @CheckNumber varchar(50)
Declare @CashAccountKey int
Declare @ExpenseAccountKey int
Declare @TransactionDate smalldatetime
Declare @DetailAmount money
Declare @ClassKey int
Declare @Description varchar(500)
Declare @ClientKey int, @DiscountAccountKey int
Declare @VendorKey int
Declare @UnappliedAccountKey int, @UnappliedAmt money

Select
	 @PaymentAmount = PaymentAmount
	,@TransactionDate = PostingDate
	,@CheckNumber = CheckNumber
	,@CashAccountKey = CashAccountKey
	,@ClassKey = ClassKey
	,@ClientKey = VendorKey
	,@VendorKey = VendorKey
	,@UnappliedAccountKey = ISNULL(UnappliedPaymentAccountKey, 0)
from tPayment (nolock)
Where PaymentKey = @PaymentKey

Select	@DiscountAccountKey = ISNULL(DiscountAccountKey, 0)
From	tPreference (nolock)
Where	CompanyKey = @CompanyKey
	
Select @DetailAmount = ISNULL(Sum(Amount), 0) from tPaymentDetail (nolock) Where PaymentKey = @PaymentKey
Select @UnappliedAmt = @PaymentAmount - @DetailAmount

Select @DiscountAmount = ISNULL(Sum(DiscAmount), 0) from tPaymentDetail (nolock) Where PaymentKey = @PaymentKey

-- Post the Amount to Cash
Select @Memo = 'Check Number ' + @CheckNumber
exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'PAYMENT', @PaymentKey, @CheckNumber, @CashAccountKey, @PaymentAmount, @ClassKey, @Memo, NULL, @VendorKey

-- Post the discounts
Select @Memo = 'Discounts taken from Check Number ' + @CheckNumber
if @DiscountAmount <> 0
	exec spGLPrePostInsertTran @CompanyKey, 'C', @TransactionDate, 'PAYMENT', @PaymentKey, @CheckNumber, @DiscountAccountKey, @DiscountAmount, @ClassKey, @Memo, NULL, @VendorKey

-- Post the unapplied amount
Select @Memo = 'Unapplied amount from Check Number ' + @CheckNumber
if @UnappliedAmt <> 0
	exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'PAYMENT', @PaymentKey, @CheckNumber, @UnappliedAccountKey, @UnappliedAmt, @ClassKey, @Memo, NULL, @VendorKey

Select @CurKey = -1
while 1=1
begin
	Select @CurKey = min(PaymentDetailKey) from tPaymentDetail (nolock) Where PaymentKey = @PaymentKey and PaymentDetailKey > @CurKey
	if @CurKey is null
		Break

	Select
		@ExpenseAccountKey = GLAccountKey
		,@ClassKey = ClassKey
		,@Description = Description
		,@DetailAmount = ISNULL(Amount, 0) + ISNULL(DiscAmount, 0)
	from tPaymentDetail (nolock) Where PaymentDetailKey = @CurKey
	
	Select @Memo = Left('Check Number ' + @CheckNumber + ' ' + ISNULL(@Description, ''), 500)
	exec spGLPrePostInsertTran @CompanyKey, 'D', @TransactionDate, 'PAYMENT', @PaymentKey, @CheckNumber, @ExpenseAccountKey, @DetailAmount, @ClassKey, @Memo, NULL, @VendorKey
end
GO
