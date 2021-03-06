USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentVoid]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentVoid]

	(
		@CompanyKey int,
		@PaymentKey int,
		@VoidDate smalldatetime
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 11/14/06 GWG 8.35   Add back the hook so that voids still point to the voucher.
  || 10/08/07 BSH 8.5    Update GLCompany, Office and Department Keys on the void payment/details.
  || 06/18/08 GHL 8.513  Added OpeningTransaction
  || 03/17/09 MFT 10.021 (40077) Added Exclude1099
  || 02/02/11 MFT 10.540 (102496) Copied UnappliedPaymentAccountKey from original Payment record to the Void record
  || 09/28/12 RLB 10.560  Add MultiCompanyGLClosingDate preference check
  || 01/10/14 MFT 10.565 (202103) Added ClassKey to header copy
  || 02/05/15 KMC 10.588 (245252) Added CashAccountKey to check for other payments/checks
  */

Declare @RequireAccounts tinyint
Declare @PostToGL tinyint
Declare @CurKey int
Declare @GLClosedDate smalldatetime
Declare @UseMultiCompanyGLCloseDate tinyint
Declare @RetVal int

Declare @CheckNumber varchar(50)
Declare @VoidPaymentKey int
Declare @VoucherKey int
Declare @GLCompanyKey int

Declare @CashAccountKey int

Select
	 @PostToGL = ISNULL(PostToGL, 0)
	,@GLClosedDate = GLClosedDate
	,@UseMultiCompanyGLCloseDate = ISNULL(MultiCompanyClosingDate, 0)
From
	tPreference (nolock)
Where
	CompanyKey = @CompanyKey

Select
	@GLCompanyKey = GLCompanyKey
From
	tPayment (nolock)
where
	PaymentKey = @PaymentKey


if @UseMultiCompanyGLCloseDate = 1 And ISNULL(@GLCompanyKey, 0) > 0
	BEGIN
		Select 
			@GLClosedDate = GLCloseDate
		From 
			tGLCompany (nolock)
		Where
			GLCompanyKey = @GLCompanyKey			
	END	
	
if @GLClosedDate > @VoidDate
	return -1
	


Select @CheckNumber = CheckNumber, @CashAccountKey = CashAccountKey from tPayment (NOLOCK) Where PaymentKey = @PaymentKey

Select @CheckNumber = @CheckNumber + ' VOID'
-- See if there is a check with this number
if exists(Select 1 from tPayment (NOLOCK) Where CheckNumber = @CheckNumber and CompanyKey = @CompanyKey and CashAccountKey = @CashAccountKey)
	return -2
	
begin transaction

	-- Insert the header record
	Insert into tPayment
	(CompanyKey, CashAccountKey, PaymentDate, PostingDate, CheckNumber, VendorKey
	, PayToName, PayToAddress1, PayToAddress2, PayToAddress3, PayToAddress4, PayToAddress5
	, Memo, PaymentAmount, Posted, VoidPaymentKey, GLCompanyKey, OpeningTransaction, UnappliedPaymentAccountKey, ClassKey)
	Select
	CompanyKey, CashAccountKey, @VoidDate, @VoidDate, @CheckNumber, VendorKey
	, PayToName, PayToAddress1, PayToAddress2, PayToAddress3, PayToAddress4, PayToAddress5
	, Memo, -1 * PaymentAmount, 0, 0, GLCompanyKey, OpeningTransaction, UnappliedPaymentAccountKey, ClassKey
	from tPayment (NOLOCK) Where PaymentKey = @PaymentKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end

	Select @VoidPaymentKey = @@IDENTITY
	
	-- Set the void keys to signify that this transaction has been voided and create a link
	Update tPayment Set VoidPaymentKey = @PaymentKey Where PaymentKey in (@PaymentKey, @VoidPaymentKey)
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end
	
	-- Insert the detail rows
	Insert into tPaymentDetail
	(PaymentKey, GLAccountKey, ClassKey, VoucherKey, Description, Quantity, UnitAmount, DiscAmount, Amount, OfficeKey, DepartmentKey, Exclude1099)
	Select
	@VoidPaymentKey, GLAccountKey, ClassKey, VoucherKey, Description, Quantity, -1 * UnitAmount, -1 * DiscAmount, -1 * Amount, OfficeKey, DepartmentKey, -1 * Exclude1099
	from tPaymentDetail (NOLOCK) 
	Where PaymentKey = @PaymentKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end

	-- loop through and update the voucher totals based on a reversed transaction
	Select @CurKey = -1
	While 1=1
	BEGIN
		Select @CurKey = MIN(PaymentDetailKey) from tPaymentDetail (NOLOCK) Where PaymentKey = @VoidPaymentKey and PaymentDetailKey > @CurKey
		if @CurKey is null
			break
		
		Select @VoucherKey = ISNULL(VoucherKey, 0) from tPaymentDetail (NOLOCK) Where PaymentDetailKey = @CurKey
		if @VoucherKey > 0
		begin
			exec sptVoucherUpdateAmountPaid @VoucherKey
			if @@ERROR <> 0 
			begin
				rollback transaction 
				return -99
			end
		end
	
	END
	
	
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end	

commit transaction

return @VoidPaymentKey
GO
