USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingPaymentDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingPaymentDelete]
	@BillingKey int,
	@Entity varchar(50),
	@EntityKey int

AS --Encrypt

	DELETE
	FROM tBillingPayment
	WHERE
		BillingKey = @BillingKey and
		Entity = @Entity and
		EntityKey = @EntityKey

	RETURN 1
GO
