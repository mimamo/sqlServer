USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskExpenseOrderGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskExpenseOrderGetList]
	(
	@EstimateTaskExpenseKey int
	)
AS --Encrypt

	SET NOCOUNT ON 

  /*
  || When     Who Rel     What
  || 07/11/14 GHL 10.582 (220671) Creation to support new enhancement for Kohl
  ||                     Each estimate expense can now be linked to several POs
  ||                     This SP is used to display a list of orders for the estimate expense 
  */

	select eteo.*
	      ,po.PurchaseOrderKey
		  ,po.PurchaseOrderNumber
		  ,po.PODate
		  ,pod.BillableCost
		  ,i.ItemType
	from   tEstimateTaskExpenseOrder eteo (nolock)
		inner join tPurchaseOrderDetail pod (nolock) on eteo.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey 
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey 
	where  eteo.EstimateTaskExpenseKey = @EstimateTaskExpenseKey
	order by po.PODate desc, po.PurchaseOrderNumber desc

	RETURN 1
GO
