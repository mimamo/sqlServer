USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBuyUpdateLogUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sptBuyUpdateLogUpdate]
	@BuyUpdateLogKey bigint,
	@PurchaseOrderKey int
AS

/*
|| When      Who Rel      What
|| 3/27/14   CRG 10.5.7.8 Created to update the PurchaseOrderKey after the PO Insert
*/

	UPDATE	tBuyUpdateLog
	SET		PurchaseOrderKey = @PurchaseOrderKey
	WHERE	BuyUpdateLogKey = @BuyUpdateLogKey

	UPDATE	tBuyUpdateLogDetail
	SET		PurchaseOrderKey = @PurchaseOrderKey
	WHERE	BuyUpdateLogKey = @BuyUpdateLogKey
GO
