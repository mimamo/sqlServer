USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailBCGetBilledSpots]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailBCGetBilledSpots]

	 @PurchaseOrderKey int
	,@PurchaseOrderDetailKey int


AS --Encrypt

/*

|| 03/24/11 MAS 10.5.4.2	(106043)Created (copied from sptPurchaseOrderDetailBCGet) This is used to populate
||							the 'Billed Spots' grid on bc_details

*/

declare @LineNumber int
declare @AdjustmentNumber int
declare @CurrentDate smalldatetime
declare @FlightStartDate smalldatetime
declare @FlightEndDate smalldatetime
declare @DetailOrderDate smalldatetime
declare @DetailOrderEndDate smalldatetime


if @PurchaseOrderDetailKey = 0 -- handle new line
		select @LineNumber = 1
			  ,@AdjustmentNumber = 0
			  ,@FlightStartDate = po.FlightStartDate
			  ,@FlightEndDate = po.FlightEndDate
			  ,@DetailOrderDate = getdate()
			  ,@DetailOrderEndDate = getdate()
		  from tPurchaseOrder po (nolock) 
		 where PurchaseOrderKey = @PurchaseOrderKey
	else
		select @LineNumber = pod.LineNumber
			  ,@AdjustmentNumber = isnull(pod.AdjustmentNumber, 0)
			  ,@FlightStartDate = po.FlightStartDate
			  ,@FlightEndDate = po.FlightEndDate
			  ,@DetailOrderDate = isnull(pod.DetailOrderDate,getdate())
			  ,@DetailOrderEndDate = isnull(pod.DetailOrderEndDate,getdate())
		  from tPurchaseOrderDetail pod (nolock) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		 where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
         and   TransferToKey is null

Select 
	PurchaseOrderDetailKey 
	,pod.DetailOrderDate AS DetailOrderDate
	,pod.DetailOrderEndDate AS DetailOrderEndDate
	,pod.Quantity  AS Quantity 
	,pod.UserDate1 AS UserDate1
	,pod.UserDate2 AS UserDate2
	,pod.UserDate3 AS UserDate3
	,pod.UserDate4 AS UserDate4
	,pod.UserDate5 AS UserDate5
	,pod.UserDate6 AS UserDate6
	,pod.BillableCost AS BillableCost
	,pod.TotalCost AS TotalCost
	,isnull(pod.InvoiceLineKey,0) AS InvoiceLineKey
	,inv.InvoiceNumber AS InvoiceNumber
	,inv.InvoiceKey AS InvoiceKey
	,pod.DateBilled AS DateBilled
	,pod.AmountBilled AS AmountBilled
	,pod.Closed AS Closed
from tPurchaseOrderDetail pod (nolock)
		left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		left outer join tInvoice inv (nolock) on il.InvoiceKey = inv.InvoiceKey
where pod.PurchaseOrderKey = @PurchaseOrderKey
and pod.LineNumber = @LineNumber
and isnull(pod.AdjustmentNumber, 0) = @AdjustmentNumber
and   pod.TransferToKey is null
order by pod.AdjustmentNumber
	
return 1
GO
