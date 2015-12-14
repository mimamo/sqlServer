USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingPaymentInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingPaymentInsert]
	@BillingKey int,
	@Entity varchar(50),
	@EntityKey int,
	@Amount money
AS --Encrypt

	INSERT tBillingPayment
		(
		BillingKey,
		Entity,
		EntityKey,
		Amount
		)

	VALUES
		(
		@BillingKey,
		@Entity,
		@EntityKey,
		@Amount
		)
	

	RETURN 1
GO
