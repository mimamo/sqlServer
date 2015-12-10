USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailUpdateTaxes]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDetailUpdateTaxes]
	(
	@VoucherDetailKey INT
	,@VoucherKey INT
	,@SalesTaxAmount MONEY
	,@SalesTax1Amount MONEY
	,@SalesTax2Amount MONEY

	,@RollupToHeader INT = 1
	)	 
AS --Encrypt

/*
|| When     Who Rel     What
|| 11/23/11 GHL 10.550  Added param @RollupToHeader to control rollup section
|| 02/24/12 GHL 10.552  Added call to sptVoucherCreditCleanup
||                      This is the last step when saving a vendor invoice detail 
||                      and we need to make sure that the applications in tVoucherCredit are valid
||                      i.e. no credits applied to credits
*/
	SET NOCOUNT ON
	
	UPDATE tVoucherDetail
	SET    SalesTaxAmount = @SalesTaxAmount -- this contains @SalesTax1Amount + @SalesTax2Amount + other taxes
	      ,SalesTax1Amount = @SalesTax1Amount
	      ,SalesTax2Amount = @SalesTax2Amount
	WHERE  VoucherDetailKey = @VoucherDetailKey
	
	IF @RollupToHeader = 1
		EXEC sptVoucherRollupAmounts @VoucherKey
	
	exec sptVoucherCreditCleanup @VoucherKey

	RETURN 1
GO
