USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorCreditDelete]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorCreditDelete]
	@VendorCreditKey int

AS --Encrypt


Begin Transaction

Declare @CurKey int, @RetVal int

Select @CurKey = -1
While 1 = 1
BEGIN

	Select @CurKey = Min(VendorCreditDetailKey) from tVendorCreditDetail (NOLOCK)
		Where VendorCreditKey = @VendorCreditKey and VendorCreditDetailKey > @CurKey
		
	if @CurKey is null
		break
	Exec @RetVal = sptVendorCreditDetailDelete @CurKey
	if ISNULL(@RetVal , 0) < 0
	BEGIN
		Rollback Transaction
		Return -3
	end

END

DELETE
FROM tVendorCredit
WHERE
	VendorCreditKey = @VendorCreditKey 

commit transaction

RETURN 1
GO
