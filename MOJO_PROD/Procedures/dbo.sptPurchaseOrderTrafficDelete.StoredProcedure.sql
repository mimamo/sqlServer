USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderTrafficDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderTrafficDelete]
	@PurchaseOrderTrafficKey int

AS --Encrypt

	DELETE
	FROM tPurchaseOrderTraffic
	WHERE
		PurchaseOrderTrafficKey = @PurchaseOrderTrafficKey 

	RETURN 1
GO
