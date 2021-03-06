USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailDeleteSpot]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailDeleteSpot]

	@PurchaseOrderDetailKey int

AS --Encrypt

DECLARE @CurrentStatus int
DECLARE @Revision int
DECLARE @PurchaseOrderKey int
declare @LineNumber int 
declare @FlightStartDate smalldatetime
declare @DetailOrderDate smalldatetime
declare @InvoiceLineKey int


	SELECT @PurchaseOrderKey = pod.PurchaseOrderKey 
	      ,@LineNumber = pod.LineNumber
	      ,@FlightStartDate = po.FlightStartDate
	      ,@DetailOrderDate = pod.DetailOrderDate
	      ,@InvoiceLineKey = pod.InvoiceLineKey
	FROM tPurchaseOrderDetail pod (NOLOCK) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	WHERE pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	
		
	IF EXISTS (SELECT 1
			FROM   tVoucherDetail vd (NOLOCK)
					,tPurchaseOrderDetail pod (NOLOCK)
					,tPurchaseOrder po (NOLOCK)
			WHERE  po.PurchaseOrderKey = @PurchaseOrderKey
			AND    po.PurchaseOrderKey = pod.PurchaseOrderKey
			AND    pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey)
		RETURN -1		

	
	IF EXISTS (SELECT 1
	           FROM		tPurchaseOrder po (NOLOCK)
	           WHERE  po.PurchaseOrderKey = @PurchaseOrderKey
	           AND    (po.Closed = 1))
		RETURN -2

	
	UPDATE tEstimateTaskExpense
	SET    PurchaseOrderDetailKey = NULL
	WHERE  PurchaseOrderDetailKey = @PurchaseOrderDetailKey 
	
	-- do not delete detail line if it's got an InvoiceLineKey.  It will have an Accrued Cost and cannot be deleted
	if isnull(@InvoiceLineKey,0) > 0
	    update tPurchaseOrderDetail
		   set Quantity = 0
			  ,UserDate1 = null
			  ,UserDate2 = null
			  ,UserDate3 = null
			  ,UserDate4 = null
			  ,UserDate5 = null
			  ,UserDate6 = null
			  ,BillableCost = 0
			  ,TotalCost = 0
		where PurchaseOrderDetailKey = @PurchaseOrderDetailKey 
	else
		delete from tPurchaseOrderDetail
	     where PurchaseOrderDetailKey = @PurchaseOrderDetailKey 
	
	if not exists(select 1 from tPurchaseOrderDetail (nolock) where PurchaseOrderKey = @PurchaseOrderKey and LineNumber = @LineNumber)
		UPDATE tPurchaseOrderDetail
		SET    LineNumber = LineNumber - 1
		WHERE
			PurchaseOrderKey = @PurchaseOrderKey 
		AND 
			LineNumber > @LineNumber
		
	exec sptPurchaseOrderDetailUpdateApprover @PurchaseOrderKey
	
	RETURN 1
GO
