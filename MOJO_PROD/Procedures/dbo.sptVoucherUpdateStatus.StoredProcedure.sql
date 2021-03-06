USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherUpdateStatus]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptVoucherUpdateStatus]

	(
		@VoucherKey int,
		@Status smallint,
		@ApprovedDate smalldatetime,
		@ApprovalComments varchar(300) = NULL
	)

AS --Encrypt

  /*
  || When     Who Rel		What
  || 02/15/07 GHL 8.4		Added project rollup section    
  || 12/17/12 GWG 10.5.6.2	Added auto posting of credit cards
  */

  Declare @CompanyKey int, @CreditCard tinyint

	IF (SELECT Posted
	    FROM   tVoucher (NOLOCK)
	    WHERE  VoucherKey = @VoucherKey) = 1
	    RETURN -1
	    
if @Status < 4
BEGIN
	if @ApprovalComments is null
		UPDATE 
			tVoucher
		SET
			Status = @Status,
			ApprovedDate = NULL
		WHERE
			VoucherKey = @VoucherKey
	else
		UPDATE 
			tVoucher
		SET
			Status = @Status,
			ApprovedDate = NULL,
			ApprovalComments = @ApprovalComments
		WHERE
			VoucherKey = @VoucherKey
END
else
BEGIN

	Declare @CurKey int, @CurQty decimal(15, 3), @CurItem int, @CurItemQty decimal(9, 3)

	Begin Transaction

	if exists(Select 1 from tVoucher v (NOLOCK) inner join tPreference p (NOLOCK) on v.CompanyKey = p.CompanyKey Where v.VoucherKey = @VoucherKey and p.TrackQuantityOnHand = 1)
	BEGIN
		Select @CurKey = -1
		While 1=1
		BEGIN
			
		if @@ERROR <> 0 
			begin
				rollback transaction 
				return -1
			end
			
			Select @CurKey = Min(VoucherDetailKey) from tVoucherDetail (NOLOCK) Where VoucherKey = @VoucherKey and VoucherDetailKey > @CurKey and ISNULL(ItemKey, 0) > 0
			if @CurKey is null
				break
			Select @CurItem = ItemKey, @CurQty = Quantity from tVoucherDetail (NOLOCK) Where VoucherDetailKey = @CurKey
			Select @CurItemQty = QuantityOnHand from tItem (NOLOCK) Where ItemKey = @CurItem
			
			if @CurItemQty + @CurQty > 999999.999
				Update tItem Set QuantityOnHand = 999999.999 Where ItemKey = @CurItem
			else
				Update tItem Set QuantityOnHand = @CurItemQty + @CurQty Where ItemKey = @CurItem
			
		END
	END

	if @ApprovalComments is null
		UPDATE 
			tVoucher
		SET
			Status = @Status,
			ApprovedDate = @ApprovedDate
		WHERE
			VoucherKey = @VoucherKey
	else
		UPDATE 
			tVoucher
		SET
			Status = @Status,
			ApprovedDate = @ApprovedDate,
			ApprovalComments = @ApprovalComments
		WHERE
			VoucherKey = @VoucherKey

	if @@ERROR <> 0 
		begin
			rollback transaction 
			return -1
		end
		


		Update tVoucher
		Set Status = 4
		Where RecurringParentKey = @VoucherKey


		Select @CompanyKey = CompanyKey, @CreditCard = ISNULL(CreditCard, 0) from tVoucher (nolock) Where VoucherKey = @VoucherKey

		if @CreditCard = 1
			exec spGLPostVoucher @CompanyKey, @VoucherKey 
		
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -1
		end


	Commit Transaction


END
		
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
		
	-- Rollup project, TranType = Voucher or 4, approved rollup only
	EXEC sptProjectRollupUpdate @ProjectKey, 4, 0, 1, 0, 0
 END
 		
RETURN 1
GO
