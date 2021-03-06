USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderTypeDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderTypeDelete]
	@PurchaseOrderTypeKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 03/12/07 CRG 8.4.0.7 Added code to set the DefaultPrintPOType to NULL if it is set in the Company Preferences.
*/

	if exists(select 1 from tPurchaseOrder p (nolock) where p.PurchaseOrderTypeKey = @PurchaseOrderTypeKey)
		return -1

	if exists(select 1 from tQuote q (nolock) where q.PurchaseOrderTypeKey = @PurchaseOrderTypeKey)
		return -2

	UPDATE	tPreference
	SET		DefaultPrintPOType = NULL
	WHERE	DefaultPrintPOType = @PurchaseOrderTypeKey

	DELETE
	FROM tPurchaseOrderType
	WHERE
		PurchaseOrderTypeKey = @PurchaseOrderTypeKey 

	RETURN 1
GO
