USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvPurchaseOrderGet]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spvPurchaseOrderGet]
	@PurchaseOrderKey int
	
AS --Encrypt

	SELECT	*
	FROM	vPurchaseOrder (NOLOCK)
	WHERE	PurchaseOrderKey = @PurchaseOrderKey
GO
