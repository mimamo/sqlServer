USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckVoid]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckVoid]

	@CompanyKey int,
	@CheckKey int,
	@VoidDate smalldatetime

AS --Encrypt
/*
|| When      Who Rel     What
|| 10/5/07   GWG 8.5     Added GL Company, Office and department
|| 4/1/08	 GWG 8.56	 Removed the null on InvoiceKey. Void and Original need to stay linked to the invoice for aging purposes
|| 4/16/08   GHL 8.508   (24652) If the deposit has cleared, set DepositKey = NULL, else use same DepositKey on void
|| 6/25/08   GHL 8.514   When voiding a check, copy OpeningTransaction
|| 3/1/10    GWG 10.518  Including the company key on the void now. 
|| 03/21/12  MAS 10.554  Added TargetGLCompanyKey to the tCheckAppl insert
|| 09/28/12  RLB 10.560  Add MultiCompanyGLClosingDate preference check
*/
Declare @RequireAccounts tinyint
Declare @PostToGL tinyint
Declare @CurKey int
Declare @GLClosedDate smalldatetime
Declare @UseMultiCompanyGLCloseDate tinyint
Declare @RetVal int

Declare @ReferenceNumber varchar(50)
Declare @VoidCheckKey int
Declare @InvoiceKey int
Declare @DepositKey int
Declare @DepositCleared int
Declare @ClientKey int
Declare @GLCompanyKey int

Select
	 @PostToGL = ISNULL(PostToGL, 0)
	,@GLClosedDate = GLClosedDate
	,@UseMultiCompanyGLCloseDate = ISNULL(MultiCompanyClosingDate, 0)
From
	tPreference (nolock)
Where
	CompanyKey = @CompanyKey

Select @ReferenceNumber = c.ReferenceNumber
      ,@ClientKey = c.ClientKey
      ,@DepositKey = c.DepositKey
      ,@DepositCleared = isnull(d.Cleared, 0) 
	  ,@GLCompanyKey = c.GLCompanyKey
from tCheck c (nolock) 
	left outer join tDeposit d (nolock) on c.DepositKey = d.DepositKey
Where c.CheckKey = @CheckKey
	
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

if @DepositCleared = 1
	Select @DepositKey = NULL
	
Select @ReferenceNumber = @ReferenceNumber + ' VOID'
-- See if there is a check with this number
if exists(Select 1 from tCheck (nolock) Where ReferenceNumber = @ReferenceNumber and ClientKey = @ClientKey)
	return -2
	
-- Do not allow a void if the check has been applied as a prepayment to an invoice. This will mess up the posting of the invoice.
if exists(Select 1 from tCheckAppl ca (nolock) inner join tCheck c (nolock) on ca.CheckKey = c.CheckKey Where ca.Prepay = 1 and c.CheckKey = @CheckKey)
	return -3
	
begin transaction

Insert Into tCheck
(ClientKey, CompanyKey, CheckAmount, CheckDate, PostingDate, ReferenceNumber, Description, CashAccountKey, GLCompanyKey, ClassKey, Posted, Downloaded, PrepayAccountKey, DepositKey, CheckMethodKey, VoidCheckKey, OpeningTransaction)
Select
ClientKey, @CompanyKey, CheckAmount * -1, @VoidDate, @VoidDate, @ReferenceNumber, Description, CashAccountKey, GLCompanyKey, ClassKey, 0, 0, PrepayAccountKey, @DepositKey, CheckMethodKey, @CheckKey, OpeningTransaction
From tCheck (nolock)
Where CheckKey = @CheckKey

if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end

Select @VoidCheckKey = @@IDENTITY
	
-- Set the void keys to signify that this transaction has been voided and create a link
Update tCheck Set VoidCheckKey = @CheckKey Where CheckKey in (@CheckKey, @VoidCheckKey)
if @@ERROR <> 0 
begin
	rollback transaction 
	return -99
end
	
Insert Into tCheckAppl
( CheckKey, InvoiceKey, SalesAccountKey, OfficeKey, DepartmentKey, ClassKey, Description, Amount, Prepay, TargetGLCompanyKey )
Select
@VoidCheckKey, InvoiceKey, SalesAccountKey, OfficeKey, DepartmentKey, ClassKey, Description, Amount * -1, Prepay, TargetGLCompanyKey 
From tCheckAppl (nolock)
Where CheckKey = @CheckKey
if @@ERROR <> 0 
begin
	rollback transaction 
	return -99
end

-- loop through and update the voucher totals based on a reversed transaction
Select @CurKey = -1
While 1=1
BEGIN
	Select @CurKey = MIN(CheckApplKey) from tCheckAppl (nolock) Where CheckKey = @VoidCheckKey and CheckApplKey > @CurKey
	if @CurKey is null
		break
	
	Select @InvoiceKey = ISNULL(InvoiceKey, 0) from tCheckAppl (nolock) Where CheckApplKey = @CurKey
	if @InvoiceKey > 0
	begin
		exec sptInvoiceUpdateAmountPaid @InvoiceKey
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

commit tran

return @VoidCheckKey
GO
