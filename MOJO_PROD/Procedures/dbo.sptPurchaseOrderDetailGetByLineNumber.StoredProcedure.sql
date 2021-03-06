USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailGetByLineNumber]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailGetByLineNumber]
	@PurchaseOrderKey int,
	@LineNumber int
AS

/*
|| When      Who Rel      What
|| 5/18/11   CRG 10.5.4.4 Created for voucher import
|| 5/01/14   GHL 10.5.7.9 (214848) Do not pull records transferred out
*/

	SELECT	pod.*, po.VendorKey, i.ExpenseAccountKey
	FROM	tPurchaseOrderDetail pod (nolock)
	INNER JOIN tPurchaseOrder po (nolock) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
	LEFT JOIN tItem i (nolock) ON pod.ItemKey = i.ItemKey
	WHERE	pod.PurchaseOrderKey = @PurchaseOrderKey
	AND		pod.LineNumber = @LineNumber
	AND     pod.TransferToKey is null
GO
