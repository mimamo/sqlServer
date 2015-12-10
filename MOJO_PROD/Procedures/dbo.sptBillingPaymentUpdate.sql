USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingPaymentUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingPaymentUpdate]
	@BillingPaymentKey int,
	@Amount money

AS --Encrypt

	UPDATE
		tBillingPayment
	SET
		Amount = @Amount
	WHERE
		BillingPaymentKey = @BillingPaymentKey 

	RETURN 1
GO
