USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailDelete]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDetailDelete]
	@VoucherDetailKey int
	,@ProjectRollup int = 1

AS --Encrypt
	   
/*
|| When     Who Rel     What
|| 02/14/07 GHL 8.4     Added project rollup section
|| 07/25/07 GWG 8.5     Blank out voucher detail key on expense reports. 
|| 02/07/08 CRG 8.5.0.3 (21007) Now setting VoucherKey = 0 on tExpenseEnvelope if it has no more lines linked to any vouchers
|| 04/21/08 GHL 8.509   (24855) Update tItem.QuantityOnHand when approved and @TrackQuantityOnHand = 1 
|| 08/24/11 GHL 10.547  Changed calculations for QuantityOnHand
|| 09/23/11 MFT 10.548  Added logic for deleting labor lines
|| 08/20/12 GHL 10.559  (152039) Added checking of tBillingDetail records
|| 12/10/12 GHL 10.563  (162102) Do not delete if the record is in WIP
*/
	    
	DECLARE @CurrentLineNumber INT
         ,@VoucherKey INT
         ,@PurchaseOrderDetailKey INT
         ,@ProjectKey INT
	     ,@WIPPostingInKey int

	Declare @Posted int, @Status int, @TrackQuantityOnHand int
		 
	SELECT @CurrentLineNumber = LineNumber
			,@VoucherKey = VoucherKey
			,@ProjectKey = ProjectKey
			,@WIPPostingInKey = WIPPostingInKey
	FROM tVoucherDetail (NOLOCK)
	WHERE
		VoucherDetailKey = @VoucherDetailKey 

	SELECT @Posted = v.Posted
			,@Status = v.Status
			,@TrackQuantityOnHand = pre.TrackQuantityOnHand
	FROM   tVoucher v (NOLOCK)
		INNER JOIN tPreference pre (NOLOCK) on pre.CompanyKey = v.CompanyKey
	WHERE  v.VoucherKey = @VoucherKey

	IF @Posted = 1
	    RETURN -1
	    
	IF EXISTS(SELECT 1 FROM tVoucherDetail (NOLOCK) WHERE VoucherDetailKey = @VoucherDetailKey and (WriteOff = 1 or InvoiceLineKey > 0) )
		Return -1
	
	if exists (select 1 from tBillingDetail bd (nolock)
	inner join tBilling b (nolock) on b.BillingKey = bd.BillingKey
	where bd.Entity = 'tVoucherDetail'
	and   bd.EntityKey = @VoucherDetailKey
	And   b.Status < 5
	And   bd.Action = 1 -- Bill
	) return -1

	IF ISNULL(@WIPPostingInKey, 0) > 0
		RETURN -1

	begin transaction

	if @Status = 4 AND @TrackQuantityOnHand = 1
	BEGIN
		Declare @CurQty decimal(9, 3), @CurItemQty decimal(9, 3), @ItemKey int, @ItemType int

		Select @ItemKey = ItemKey, @CurQty = Quantity 
		from tVoucherDetail (nolock) 
		Where VoucherDetailKey = @VoucherDetailKey

		if ISNULL(@ItemKey, 0) > 0
		begin
			Select @CurItemQty = QuantityOnHand from tItem (nolock) Where ItemKey = @ItemKey
			--Update tItem Set QuantityOnHand = @CurItemQty + @CurQty Where ItemKey = @ItemKey
			Update tItem Set QuantityOnHand = @CurItemQty - @CurQty Where ItemKey = @ItemKey

   			if @@ERROR <> 0 
			begin
			rollback transaction 
			return -1
			end
		end
	END
    
	Select @PurchaseOrderDetailKey = PurchaseOrderDetailKey
	FROM tVoucherDetail (NOLOCK)
	WHERE
		VoucherDetailKey = @VoucherDetailKey 
		
	Declare @ExpenseEnvelopeKey int
	Select @ExpenseEnvelopeKey = MIN(ExpenseEnvelopeKey) from tExpenseReceipt Where VoucherDetailKey = @VoucherDetailKey
	
	Update tExpenseReceipt Set VoucherDetailKey = NULL Where VoucherDetailKey = @VoucherDetailKey
	if not exists(Select 1 from tExpenseReceipt (nolock) Where ExpenseEnvelopeKey = @ExpenseEnvelopeKey and VoucherDetailKey is not null)
		Update tExpenseEnvelope Set Paid = 0, VoucherKey = 0 Where ExpenseEnvelopeKey = @ExpenseEnvelopeKey
		

	DELETE
	FROM tVoucherDetail
	WHERE
		VoucherDetailKey = @VoucherDetailKey 
   	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end

	DELETE
	FROM tVoucherDetailTax
	WHERE
		VoucherDetailKey = @VoucherDetailKey 
   	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end
	
	UPDATE tTime
	SET    VoucherKey = NULL
	WHERE  VoucherKey = @VoucherKey
   	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end
	
	UPDATE tVoucherDetail
	SET    LineNumber = LineNumber - 1
	WHERE
		VoucherKey = @VoucherKey 
	AND 
		LineNumber > @CurrentLineNumber
   	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end

	Exec sptVoucherRollupAmounts @VoucherKey
	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end
		
	exec sptPurchaseOrderDetailUpdateAppliedCost @PurchaseOrderDetailKey
   	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end

commit transaction
	
	DECLARE	@TranType INT,@BaseRollup INT,@Approved INT,@Unbilled INT,@WriteOff INT
	SELECT	@TranType = 4,@BaseRollup = 1,@Approved = 1,@Unbilled = 1,@WriteOff = 1

	IF @ProjectRollup = 1
		EXEC sptProjectRollupUpdate @ProjectKey, @TranType, @BaseRollup,@Approved,@Unbilled,@WriteOff

	RETURN 1
GO
