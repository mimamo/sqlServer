USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentDelete]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentDelete]
	@PaymentKey int

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/23/10 GHL 10.5  Added recurring logic
  || 03/01/10 GHL 10.519 Added deletion of tRecurTran
  || 01/17/12 GHL 10.552 Corrected logic for children of recurring parents
  ||                     If we delete the parent, make the children parentless 
  */

if exists(select 1 from tPayment (NOLOCK) Where PaymentKey = @PaymentKey and Posted = 1)
	return -1
	
Declare @VoidKey int
Declare @RecurringParentKey int

	Select @VoidKey = ISNULL(VoidPaymentKey, 0)
	       ,@RecurringParentKey = ISNULL(RecurringParentKey, 0) 
	from tPayment (nolock) Where PaymentKey = @PaymentKey

	-- Can't delete a payment if a void transaction exists (void key = original check key)
	if @VoidKey = @PaymentKey
		return -2
		
begin transaction

	-- If the voided transaction is being deleted, update the original to mark as unvoided
	if @VoidKey <> @PaymentKey and @VoidKey > 0
		Update tPayment Set VoidPaymentKey = 0 Where PaymentKey = @VoidKey
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -99
		end



Declare @CurKey int
Declare @RetVal int

Select @CurKey = -1
While 1 = 1
BEGIN

	Select @CurKey = Min(PaymentDetailKey) from tPaymentDetail (NOLOCK) Where PaymentKey = @PaymentKey and PaymentDetailKey > @CurKey
	if @CurKey is null
		break
	Exec @RetVal = sptPaymentDetailDelete @CurKey
	if ISNULL(@RetVal , 0) < 0
	BEGIN
		Rollback Transaction
		Return -3
	end

END

DELETE
FROM tPayment
WHERE
	PaymentKey = @PaymentKey 

if @@ERROR <> 0 
begin
	rollback transaction 
	return -99
end

delete tRecurTran where  Entity = 'PAYMENT' and EntityKey = @PaymentKey

if @@ERROR <> 0 
begin
	rollback transaction 
	return -99
end

-- if there is a recurrence going on and this is the parent		
if @RecurringParentKey <> 0 and @RecurringParentKey = @PaymentKey
	-- if exists any children
	if exists(Select 1 from tPayment (nolock) Where RecurringParentKey = @RecurringParentKey and PaymentKey <> @RecurringParentKey)
	begin	
		-- make the children parentless
		Update tPayment
		Set RecurringParentKey = 0 
		Where RecurringParentKey = @RecurringParentKey

		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -99
		end
	end
		
commit transaction

return 1
GO
