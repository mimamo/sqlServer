USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderGetInvoiceList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderGetInvoiceList]

	(
		 @PurchaseOrderKey int
		,@POKind smallint
	)

AS

Select i.InvoiceNumber
	  ,i.InvoiceKey
	  ,i.InvoiceDate
	  ,isnull(sum(isnull(pod.AmountBilled,0)),0) as BilledAmount
	  ,isnull(sum(isnull(pod.Quantity,0)),0) as Quantity
	  ,min(pod.DetailOrderDate) as FromDate
	  ,case 
	       when @POKind = 1 then max(pod.DetailOrderDate)
	       when @POKind = 2 then max(pod.DetailOrderEndDate)
	   end as ToDate
  from tInvoice i (nolock) inner join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey
	   inner join tPurchaseOrderDetail pod (nolock) on il.InvoiceLineKey = pod.InvoiceLineKey
	   inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
 where pod.PurchaseOrderKey = @PurchaseOrderKey
   and po.POKind = @POKind
group by i.InvoiceNumber
        ,i.InvoiceKey
        ,i.InvoiceDate
order by InvoiceDate
GO
