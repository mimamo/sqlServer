USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBuyUpdateLogDetailUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sptBuyUpdateLogDetailUpdate]
	@BuyUpdateLogDetailKey uniqueidentifier,
	@PurchaseOrderDetailKey int
AS

/*
|| When      Who Rel      What
|| 3/27/14   CRG 10.5.7.8 Created to update the PurchaseOrderKey and/or PurchaseOrderDetailKey after the PO Detail Insert
*/

	UPDATE	tBuyUpdateLogDetail
	SET		PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	WHERE	BuyUpdateLogDetailKey = @BuyUpdateLogDetailKey
GO
