USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderTrafficGetList]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderTrafficGetList]

	@PurchaseOrderKey int


AS --Encrypt

		SELECT *
		FROM tPurchaseOrderTraffic (NOLOCK) 
		WHERE
		PurchaseOrderKey = @PurchaseOrderKey
		Order By ISCICode

	RETURN 1
GO
