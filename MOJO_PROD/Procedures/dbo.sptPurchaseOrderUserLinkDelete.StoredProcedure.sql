USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderUserLinkDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderUserLinkDelete]
	
	@PurchaseOrderKey int

AS --Encrypt

	DELETE
	FROM tPurchaseOrderUser
	WHERE PurchaseOrderKey = @PurchaseOrderKey 

	RETURN 1
GO
