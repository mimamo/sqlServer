USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckApplDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckApplDelete]
 
 @CheckApplKey int

AS --Encrypt

Declare @InvoiceKey int
Declare @CheckKey int
Declare @AppliedAmount money

Declare @InvoiceAmount money
Declare @CheckAmount money
Declare @InvoiceOpenAmount money
Declare @Amount money
Declare @RequireGL tinyint

Select @InvoiceKey = ISNULL(InvoiceKey, 0), @CheckKey = CheckKey, @Amount = Amount from tCheckAppl (nolock) Where CheckApplKey = @CheckApplKey

Select @AppliedAmount = Sum(Amount) from tCheckAppl (nolock) Where CheckKey = @CheckKey and CheckApplKey <> @CheckApplKey
Select @CheckAmount = CheckAmount from tCheck (nolock) Where CheckKey = @CheckKey

IF @CheckAmount > 0
BEGIN
	If ISNULL(@CheckAmount, 0) < ISNULL(@AppliedAmount, 0)
		return -2
END
ELSE
BEGIN
	If ISNULL(@CheckAmount, 0) > ISNULL(@AppliedAmount, 0)
		return -2
END


BEGIN TRANSACTION

	DELETE
	FROM tCheckAppl
	WHERE
	CheckApplKey = @CheckApplKey

	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end


	exec sptInvoiceUpdateAmountPaid @InvoiceKey
	
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end



Commit Transaction

return 1
GO
