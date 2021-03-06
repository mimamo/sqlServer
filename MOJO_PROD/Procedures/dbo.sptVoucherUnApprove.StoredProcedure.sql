USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherUnApprove]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherUnApprove]

	(
		@VoucherKey int
	)

AS --Encrypt
  /*
  || When     Who Rel    What
  || 02/15/07 GHL 8.4    Added project rollup section    
  || 12/01/09 GHL 10.514 (69337) Prevent users from unapproving when posted to WIP    
  || 03/06/13 GHL 10.565 (170746) Allowing now unapproval if a detail has been marked as billed
  ||                      (same as deletion)          
  */

If exists(Select 1 from tVoucher (NOLOCK) Where Posted = 1 and VoucherKey = @VoucherKey)
	return -1

If exists(Select 1 from tPaymentDetail (NOLOCK) Where VoucherKey = @VoucherKey)
	return -2
	
If exists(Select 1 from tVoucherCredit (NOLOCK) Where VoucherKey = @VoucherKey)
	return -2

if exists(Select 1 from tVoucherDetail (NOLOCK) Where ISNULL(WIPPostingOutKey, 0) > 0 and VoucherKey = @VoucherKey)
	return -3
		
If exists(Select 1 from tVoucherCredit (NOLOCK) Where CreditVoucherKey = @VoucherKey)
	return -4
	
if exists(Select 1 from tVoucherDetail (NOLOCK) Where (InvoiceLineKey > 0 or WriteOff = 1) and VoucherKey = @VoucherKey)
	return -5

if exists(Select 1 from tVoucherDetail (NOLOCK) Where ISNULL(WIPPostingInKey, 0) > 0 and VoucherKey = @VoucherKey)
	return -6
	
Declare @CurKey int, @CurQty decimal(24,4), @CurItem int, @CurItemQty decimal(24,4)

Begin Transaction

if exists(Select 1 from tVoucher v (NOLOCK) inner join tPreference p (NOLOCK) on v.CompanyKey = p.CompanyKey Where v.VoucherKey = @VoucherKey and p.TrackQuantityOnHand = 1)
BEGIN

	Select @CurKey = -1
	While 1=1
	BEGIN
		
		Select @CurKey = Min(VoucherDetailKey) from tVoucherDetail (NOLOCK) Where VoucherKey = @VoucherKey and VoucherDetailKey > @CurKey and ISNULL(ItemKey, 0) > 0
		if @CurKey is null
			break
		Select @CurItem = ItemKey, @CurQty = Quantity from tVoucherDetail (NOLOCK) Where VoucherDetailKey = @CurKey
		Select @CurItemQty = QuantityOnHand from tItem (NOLOCK) Where ItemKey = @CurItem
		
		Update tItem Set QuantityOnHand = @CurItemQty - @CurQty Where ItemKey = @CurItem
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -1
		end

	END
END
Update tVoucher Set Status = 1 Where VoucherKey = @VoucherKey

if @@ERROR <> 0 
	begin
		rollback transaction 
		return -1
	end

Commit Transaction

 DECLARE @ProjectKey INT
 SELECT @ProjectKey = -1
 WHILE (1=1)
 BEGIN
	SELECT @ProjectKey = MIN(ProjectKey)
	FROM   tVoucherDetail (NOLOCK)
	WHERE  VoucherKey = @VoucherKey
	AND    ProjectKey > @ProjectKey
	
	IF @ProjectKey IS NULL
		BREAK
		
	-- Rollup project, TranType = Voucher or 4, approved flag only
	EXEC sptProjectRollupUpdate @ProjectKey, 4, 0, 1, 0, 0
 END
GO
