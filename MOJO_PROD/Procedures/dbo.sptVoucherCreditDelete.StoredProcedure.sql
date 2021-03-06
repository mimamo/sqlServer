USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherCreditDelete]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherCreditDelete]

	(
		@VoucherCreditKey int
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 01/13/12 GHL 10.552 Removed @VoucherKey parameter since we can get it from first query
  */

Declare @CreditVoucherKey int
Declare @VoucherKey int
		
Select @CreditVoucherKey = CreditVoucherKey, @VoucherKey = VoucherKey from tVoucherCredit (NOLOCK) Where VoucherCreditKey = @VoucherCreditKey

BEGIN TRAN

Delete tVoucherCredit
Where
	VoucherCreditKey = @VoucherCreditKey
If @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN -1
END	

if @VoucherKey is not null
begin	
	exec sptVoucherUpdateAmountPaid @VoucherKey
	If @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END	
end

if @CreditVoucherKey is not null
begin	
	exec sptVoucherUpdateAmountPaid @CreditVoucherKey
	If @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END	
end

COMMIT TRAN

RETURN 1
GO
