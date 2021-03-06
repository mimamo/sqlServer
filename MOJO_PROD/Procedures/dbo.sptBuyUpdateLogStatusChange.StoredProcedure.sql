USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBuyUpdateLogStatusChange]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sptBuyUpdateLogStatusChange]
	@CompanyKey int,
	@UserKey int,
	@PurchaseOrderKey int,
	@Action char(1)
AS

/*
|| When      Who Rel      What
|| 3/27/14   CRG 10.5.7.8 Created to log a status change in a buy such as Approve, Unapprove, Cancel, Print, Email, etc.
*/

	DECLARE	@MediaWorksheetKey int
	
	SELECT	@MediaWorksheetKey = MediaWorksheetKey
	FROM	tPurchaseOrder (nolock)
	WHERE	PurchaseOrderKey = @PurchaseOrderKey

	INSERT	tBuyUpdateLog
			(CompanyKey,
			UserKey,
			MediaWorksheetKey,
			PurchaseOrderKey,
			Action)
	VALUES	(@CompanyKey,
			@UserKey,
			@MediaWorksheetKey,
			@PurchaseOrderKey,
			@Action)
GO
