USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderTypeGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderTypeGet]
	@PurchaseOrderTypeKey int

AS --Encrypt

		SELECT *
		FROM tPurchaseOrderType (NOLOCK) 
		WHERE
			PurchaseOrderTypeKey = @PurchaseOrderTypeKey

	RETURN 1
GO
