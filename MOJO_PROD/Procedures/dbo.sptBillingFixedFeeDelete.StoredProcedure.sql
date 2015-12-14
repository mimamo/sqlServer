USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingFixedFeeDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingFixedFeeDelete]
	@BillingKey int
	,@Entity VARCHAR(50)
	
AS --Encrypt

	IF @Entity IS NULL

	DELETE
	FROM tBillingFixedFee
	WHERE
		BillingKey = @BillingKey 
	
	ELSE
		
	DELETE
	FROM tBillingFixedFee
	WHERE
		BillingKey = @BillingKey 
	AND
		Entity = @Entity
		
	RETURN 1
GO
