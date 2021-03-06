USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckDelete]
 @CheckKey int
AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/23/10 GHL 10.5  Added recurring logic
  || 03/01/10 GHL 10.519 Added deletion of tRecurTran
  || 01/17/12 GHL 10.552 Corrected logic for children of recurring parents
  ||                     If we delete the parent, make the children parentless
  || 07/31/15 WDF 10.582 (215641) Remove delete of tActionLog Receipt records
  */
  
Declare @DepositKey int
Declare @VoidCheckKey int
declare @InvoiceKey int,@AppliedAmount money, @CheckAmount money
Declare @RecurringParentKey int

if Exists(Select 1 from tCheck (nolock) Where CheckKey = @CheckKey and Posted = 1)
	Return -1

Select  @VoidCheckKey = ISNULL(VoidCheckKey, 0)
       ,@RecurringParentKey = ISNULL(RecurringParentKey, 0)
       ,@DepositKey = DepositKey 
from tCheck (nolock) Where CheckKey = @CheckKey

if @VoidCheckKey = @CheckKey
	return -2
	
if exists(Select 1 from tDeposit (nolock) Where Cleared = 1 and DepositKey = @DepositKey)
	return -3
	
if @VoidCheckKey = 0
	if exists(Select 1 from tCheckAppl (nolock) Where Prepay = 1 and CheckKey = @CheckKey)
		return -4
	
Begin Tran

-- If the voided transaction is being deleted, update the original to mark as unvoided
if @VoidCheckKey <> @CheckKey and @VoidCheckKey > 0
	Update tCheck Set VoidCheckKey = 0 Where CheckKey = @VoidCheckKey
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -98
	end
		
if @DepositKey is not null
	if not exists(select 1 from tCheck (nolock) Where DepositKey = @DepositKey and CheckKey <> @CheckKey)
	begin
		Delete tDeposit Where DepositKey = @DepositKey
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -99
		end
	end

Declare @CurKey int
Declare @RetVal int

Select @CurKey = -1
While 1 = 1
BEGIN

	if @CurKey is null
		break
	Select @CurKey = Min(CheckApplKey) from tCheckAppl (nolock) Where CheckKey = @CheckKey and CheckApplKey > @CurKey
	-- Start New
	
	Select @InvoiceKey = ISNULL(InvoiceKey, 0) from tCheckAppl (nolock) Where CheckApplKey = @CurKey
	DELETE FROM tCheckAppl WHERE CheckApplKey = @CurKey
	if @InvoiceKey > 0
		exec sptInvoiceUpdateAmountPaid @InvoiceKey
END


Select @AppliedAmount = Sum(Amount) from tCheckAppl (nolock) Where CheckKey = @CheckKey
Select @CheckAmount = CheckAmount from tCheck (nolock) Where CheckKey = @CheckKey

IF @CheckAmount > 0
BEGIN
	If ISNULL(@CheckAmount, 0) < ISNULL(@AppliedAmount, 0)
	BEGIN
		rollback transaction
		return -102
	END
END
ELSE
BEGIN
	If ISNULL(@CheckAmount, 0) > ISNULL(@AppliedAmount, 0)
	BEGIN
		rollback transaction
		return -103
	END
END

DELETE
FROM tCheck
WHERE
CheckKey = @CheckKey 

if @@ERROR <> 0 
begin
	rollback transaction 
	return -99
end

Delete tRecurTran Where Entity = 'RECEIPT' and EntityKey = @CheckKey

if @@ERROR <> 0 
begin
	rollback transaction 
	return -99
end

-- if there is a recurrence going on and this is the parent
if @RecurringParentKey <> 0 and @RecurringParentKey = @CheckKey
	-- if exists any children	
	if exists(Select 1 from tCheck (nolock) Where RecurringParentKey = @RecurringParentKey and CheckKey <> @RecurringParentKey)
	begin	
		-- make the children parentless
		Update tCheck
		Set RecurringParentKey = 0 
		Where RecurringParentKey = @RecurringParentKey

		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -99
		end
	end
		
commit transaction

RETURN 1
GO
