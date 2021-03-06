USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderGetForMediaWorksheet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderGetForMediaWorksheet]
	@MediaWorksheetKey int
AS

/*
|| When      Who Rel      What
|| 7/23/13   CRG 10.5.7.0 Created
*/

	SELECT	PurchaseOrderKey
	FROM	tPurchaseOrder (nolock)
	WHERE	MediaWorksheetKey = @MediaWorksheetKey
GO
