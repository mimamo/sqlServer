USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderTrafficGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderTrafficGet]
	@PurchaseOrderTrafficKey int

AS --Encrypt

		SELECT *
		FROM tPurchaseOrderTraffic (NOLOCK) 
		WHERE
			PurchaseOrderTrafficKey = @PurchaseOrderTrafficKey

	RETURN 1
GO
