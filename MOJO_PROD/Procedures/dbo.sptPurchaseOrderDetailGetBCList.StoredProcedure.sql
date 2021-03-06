USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailGetBCList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailGetBCList]

	@PurchaseOrderKey int


AS --Encrypt

/*
|| When     Who Rel     What
|| 08/27/09 GHL 10.5    Added filter on TransferToKey NULL
*/
	select PurchaseOrderKey
		  ,min(PurchaseOrderDetailKey) as PurchaseOrderDetailKey
		  ,LineNumber
		  ,AdjustmentNumber
	      ,ReasonID
	      ,ShortDescription
	      ,OrderTime
	      ,sum(isnull(Quantity,0)) as Quantity
	      ,sum(isnull(BillableCost,0)) as BillableCost
	      ,sum(isnull(TotalCost,0)) as TotalCost
      from tPurchaseOrderDetail (nolock)
		left outer join tMediaRevisionReason (nolock) 
			on tPurchaseOrderDetail.MediaRevisionReasonKey = tMediaRevisionReason.MediaRevisionReasonKey  
     where PurchaseOrderKey = @PurchaseOrderKey
     and   TransferToKey is null
  group by PurchaseOrderKey
          ,LineNumber
          ,AdjustmentNumber
          ,ReasonID
          ,ShortDescription
          ,OrderTime
  order by LineNumber, AdjustmentNumber

	return 1
GO
