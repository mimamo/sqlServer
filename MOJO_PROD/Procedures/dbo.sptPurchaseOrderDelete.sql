USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDelete]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDelete]
	@PurchaseOrderKey int

AS --Encrypt

 /*
  || When     Who Rel   What
  || 02/20/07 GHL 8.4   Added project rollup section
  || 07/06/11 GHL 8.546 (111482) Added deletion of tax records tPurchaseOrderDetailTax
  || 05/08/14 GHL 10.579 Do not delete if billed
  */
  
	IF EXISTS (SELECT 1
	           FROM   tVoucherDetail vd (NOLOCK)
	                 ,tPurchaseOrderDetail pod (NOLOCK)
	                 ,tPurchaseOrder po (NOLOCK)
	           WHERE  po.PurchaseOrderKey = @PurchaseOrderKey
	           AND    po.PurchaseOrderKey = pod.PurchaseOrderKey
						 AND    pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey)
		RETURN -1

	IF EXISTS (SELECT 1
				FROM  tPurchaseOrderDetail (nolock)
				WHERE PurchaseOrderKey = @PurchaseOrderKey
				AND   InvoiceLineKey > 0
				)
		RETURN -2

 CREATE TABLE #ProjectRollup (ProjectKey INT NULL)
 
 INSERT #ProjectRollup (ProjectKey)
 SELECT DISTINCT ProjectKey
 FROM   tPurchaseOrderDetail (NOLOCK)
 WHERE  PurchaseOrderKey = @PurchaseOrderKey
 AND    ProjectKey IS NOT NULL
 
	DELETE
	FROM tPurchaseOrderTraffic
	WHERE
		PurchaseOrderKey = @PurchaseOrderKey 

	UPDATE tEstimateTaskExpense
	SET    tEstimateTaskExpense.PurchaseOrderDetailKey = NULL
	FROM   tPurchaseOrderDetail pod (NOLOCK)
	WHERE  tEstimateTaskExpense.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	AND    pod.PurchaseOrderKey = @PurchaseOrderKey
			
			
	DELETE tPurchaseOrderDetailTax
	FROM   tPurchaseOrderDetail (nolock)
	WHERE  tPurchaseOrderDetail.PurchaseOrderKey = @PurchaseOrderKey 
    AND    tPurchaseOrderDetail.PurchaseOrderDetailKey = tPurchaseOrderDetailTax.PurchaseOrderDetailKey

	DELETE
	FROM tPurchaseOrderDetail
	WHERE
		PurchaseOrderKey = @PurchaseOrderKey 

	delete tSpecSheetLink
	 where Entity = 'PO'
	   and EntityKey = @PurchaseOrderKey
	
	delete tPurchaseOrderUser
	 where PurchaseOrderKey = @PurchaseOrderKey

	DELETE
	FROM tPurchaseOrder
	WHERE
		PurchaseOrderKey = @PurchaseOrderKey 

	DECLARE @ProjectKey INT
	SELECT @ProjectKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ProjectKey = MIN(ProjectKey)
		FROM   #ProjectRollup
		WHERE  ProjectKey > @ProjectKey
		
		IF @ProjectKey IS NULL
			BREAK
			
		-- Rollup project, TranType = Purchase Order or 5	
		EXEC sptProjectRollupUpdate @ProjectKey, 5, 1, 1, 1, 1
	END
 
	RETURN 1
GO
