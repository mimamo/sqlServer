USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentProcessSelectionPrepay]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentProcessSelectionPrepay]
	(
	@CompanyKey int,
	@PaymentKey int
	)
	
AS --Encrypt

/*
|| 08/21/12 GHL 10.559  Creation. We need to apply over payments to credit card charges
||                      Add a payment detail with Prepay = 1
||                      Then repost if Posted = 1, on the UI we already check for GLClosedDate 
||                      Because posting creates temp tables, I do not use a SQL transaction
||                      This is why we perform validations first before inserts
||                      Then if there is an error we must delete the prepayment
|| 10/2/12 GHL 10.560   Added validation of payment applied amount
||                      Fixed errors when calling the posting routines 
|| 03/05/13 GHL 10.565  (170700) Getting now ClassKey from payment (instead of voucher)
||                      , we need to reverse it in Posting 
*/

--Assume done in vb
--Create Table #tVoucherSelect (VoucherKey int, Amount money null)

	SET NOCOUNT ON
	
declare @kErrVoucherOverApply int	select @kErrVoucherOverApply = -1
declare @kErrPaymentOverApply int	select @kErrPaymentOverApply = -2
declare @kErrUnPosting int			select @kErrUnPosting = -3
declare @kErrPosting int			select @kErrPosting = -4
declare @kErrUnexpected int			select @kErrUnexpected = -99	

	Declare @CurKey int
	Declare @Amount money
	Declare @OpenAmount money
	Declare @ClassKey int
	Declare @GLAccountKey int
	Declare @Posted int
	Declare @PaymentDetailKey int
	Declare @Error int
	Declare @RetVal int
	Declare @PaymentAmount money
	Declare @AppliedAmount money

-- Step 1: Perform validations first
	
	select @PaymentAmount = PaymentAmount
	      ,@ClassKey = ClassKey
	from   tPayment (nolock)
	where  PaymentKey = @PaymentKey

	select @AppliedAmount = sum(Amount)
	from   tPaymentDetail (nolock)
	where  PaymentKey = @PaymentKey

	select @AppliedAmount = isnull(@AppliedAmount, 0) + isnull((select sum(Amount) from #tVoucherSelect), 0)
	
	if @AppliedAmount > @PaymentAmount
		return @kErrPaymentOverApply

	Select @CurKey = -1
	while 1=1
	BEGIN
		Select @CurKey = min(VoucherKey) 
		from #tVoucherSelect 
		Where VoucherKey > @CurKey
		
		if @CurKey is null
			break
	
		Select  @Amount = Amount
		from	#tVoucherSelect
		Where	VoucherKey = @CurKey
		
		Select @OpenAmount = OpenAmount 
		from vVoucher Where VoucherKey = @CurKey
		
		if @Amount  > @OpenAmount 
			return @kErrVoucherOverApply

	END -- end VoucherKey loop


-- Step 2

	Select @CurKey = -1
	while 1=1
	BEGIN
		Select @CurKey = min(VoucherKey) 
		from #tVoucherSelect 
		Where VoucherKey > @CurKey
		
		if @CurKey is null
			break
	
		Select  @Amount = Amount
		from	#tVoucherSelect
		Where	VoucherKey = @CurKey
		
		Select @GLAccountKey = APAccountKey
			, @Posted = Posted
		from vVoucher Where VoucherKey = @CurKey

		if @Posted = 1
		begin
			-- unpost, do NOT check GLClosedDate
			exec @RetVal = spGLUnPostVoucher @CurKey, 0

			if @RetVal <> 1
			begin
				return @kErrUnPosting
			end
		end
			
		INSERT tPaymentDetail
			( PaymentKey, GLAccountKey, ClassKey, VoucherKey, Description, Quantity, UnitAmount, Amount, DiscAmount, Prepay )
		VALUES
			( @PaymentKey, ISNULL(@GLAccountKey, 0), @ClassKey, @CurKey, NULL, 0, 0, @Amount, 0, 1 )

		select @PaymentDetailKey = @@IDENTITY, @Error = @@ERROR

		if @Error <> 0 
			return @kErrUnexpected 

		exec sptVoucherUpdateAmountPaid @CurKey
		if @@ERROR <> 0 
		begin
			delete tPaymentDetail where PaymentDetailKey = @PaymentDetailKey
			return @kErrUnexpected
		end

		if @Posted = 1 -- before it was unposted
		begin
			-- post, do NOT check GLClosedDate
			exec @RetVal = spGLPostVoucher @CompanyKey, @CurKey, 0, 1, 0

			if @RetVal <> 1
			begin
				delete tPaymentDetail where PaymentDetailKey = @PaymentDetailKey
				
				exec sptVoucherUpdateAmountPaid @CurKey
				
				return @kErrPosting
			end

		end


	END -- end VoucherKey loop




	RETURN 1
GO
