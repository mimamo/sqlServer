USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptMediaDiscrepancyInvoices]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptMediaDiscrepancyInvoices]
	(
	@HideDetails int = 0, @CompanyKey int
	)
AS -- Encrypt

  /*
  || When     Who Rel    What
  || 03/14/07 GHL 8.4    Creation for new design                    
  || 03/28/07 GHL 8.4    Added PurchaseOrderKey since we when hide details, we have to show invoices
  ||                     We will apply filter on PurchaseOrderKey when hiding details
  || 04/17/07 GHL 8.42   Only show distinct invoice numbers
  || 04/15/14 RLB 10.579 (204221) Added fields for enhancement
  || 05/20/14 GHL 10.580 (216947) Added prevention against apostrophes in these fields because they are crashing
  ||                     the report in vb 
  || 07/02/14 WDF 10.581 (217042) Added Paid flag   
  || 07/18.14 RLB 10.581 (223305) Fix    
  */

	SET NOCOUNT ON 

	/*
	Assume done in VB
	
	CREATE TABLE #tDiscrepancyInvoice(PurchaseOrderKey INT NULL
									, PurchaseOrderDetailKey INT NULL
									, InvoiceNumber VARCHAR(50) NULL
									, InvoiceType INT NULL  
									)
	
	InvoiceType: 0 when initially loaded , 1 Vendor, 2 Client
	return only > 0 
	
	*/
	
	 DECLARE @IOClientLink INT -- 1 via Project, 2 via Media Estimate
            ,@BCClientLink INT
        
 select @IOClientLink = isnull(IOClientLink,1)
	    ,@BCClientLink = isnull(BCClientLink,1)
	  from tPreference (nolock)
	 where CompanyKey = @CompanyKey
	
	-- Load all vendor invoices associated to pod
	INSERT #tDiscrepancyInvoice (PurchaseOrderKey, PurchaseOrderDetailKey, InvoiceNumber, InvoiceType, TransactionType, Paid)
	SELECT pod.PurchaseOrderKey, di.PurchaseOrderDetailKey, v.InvoiceNumber, 1, di.TransactionType,     
	       CASE 
	     	  WHEN ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) <> 0 THEN 0
	          ELSE 1
	       END AS [Paid]    
	FROM   #tDiscrepancyInvoice di
		INNER JOIN tPurchaseOrderDetail pod (nolock) on di.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		INNER JOIN tVoucherDetail vd (nolock) ON di.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
	WHERE di.InvoiceType = 0

	-- Load all client invoices associated to pod	
	INSERT #tDiscrepancyInvoice (PurchaseOrderKey, PurchaseOrderDetailKey, InvoiceNumber, InvoiceType, TransactionType, Paid)
	SELECT pod.PurchaseOrderKey, di.PurchaseOrderDetailKey, i.InvoiceNumber, 2, di.TransactionType,     
	       CASE 
	           WHEN ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.AmountReceived, 0) - ISNULL(i.WriteoffAmount, 0) - ISNULL(i.RetainerAmount, 0) <> 0 THEN 0
	           ELSE 1  
	       END AS [Paid]    
	FROM   #tDiscrepancyInvoice di 
		INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON di.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		INNER JOIN tInvoiceLine il (nolock) ON pod.InvoiceLineKey = il.InvoiceLineKey
		INNER JOIN tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey
	WHERE di.InvoiceType = 0
	
	-- Load all client invoices associated to vd associated to pod	
	INSERT #tDiscrepancyInvoice (PurchaseOrderKey, PurchaseOrderDetailKey, InvoiceNumber, InvoiceType, TransactionType, Paid)
	SELECT pod.PurchaseOrderKey, pod.PurchaseOrderDetailKey, i.InvoiceNumber, 2, di.TransactionType,     
	       CASE 
	           WHEN ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.AmountReceived, 0) - ISNULL(i.WriteoffAmount, 0) - ISNULL(i.RetainerAmount, 0) <> 0 THEN 0
	           ELSE 1  
	       END AS [Paid]     
	FROM   #tDiscrepancyInvoice di
		INNER JOIN tPurchaseOrderDetail pod (nolock) on di.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		INNER JOIN tVoucherDetail vd (nolock) ON di.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		INNER JOIN tInvoiceLine il (nolock) ON vd.InvoiceLineKey = il.InvoiceLineKey
		INNER JOIN tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey
	WHERE di.InvoiceType = 0
	
	IF @IOClientLink = 1
	BEGIN
		UPDATE #tDiscrepancyInvoice set  #tDiscrepancyInvoice.ProjectName = ISNULL(p.ProjectNumber + ' - ' + p.ProjectName, '[No Project]'),
										 #tDiscrepancyInvoice.ProjectKey = ISNULL(p.ProjectKey, 0),
										 #tDiscrepancyInvoice.StationName = ISNULL(cm.StationID, vend.VendorID) + ' - ' + ISNULL(cm.Name, vend.CompanyName),
										 #tDiscrepancyInvoice.CompanyMediaKey = ISNULL(po.CompanyMediaKey, isnull(po.VendorKey, 0)),
										 #tDiscrepancyInvoice.CompanyName = ISNULL(ck.CustomerID + ' - ' + ck.CompanyName, '[No Client]'),
										 #tDiscrepancyInvoice.ClientKey = ISNULL(p.ClientKey, 0),
										 #tDiscrepancyInvoice.EstimateName = ISNULL(me.EstimateID + ' - ' + me.EstimateName, '[No Estimate]'),
										 #tDiscrepancyInvoice.MediaEstimateKey = ISNULL(po.MediaEstimateKey,0),
										 #tDiscrepancyInvoice.TransactionMonth = datename(mm, pod.DetailOrderDate)

		FROM #tDiscrepancyInvoice
			INNER JOIN tPurchaseOrderDetail pod (nolock) on #tDiscrepancyInvoice.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			INNER JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
			INNER JOIN tCompany vend (nolock) on po.VendorKey = vend.CompanyKey
			LEFT OUTER JOIN tProject p (nolock) on pod.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
			LEFT OUTER JOIN tMediaEstimate me(nolock) on po.MediaEstimateKey = me.MediaEstimateKey
			LEFT OUTER JOIN tCompany ck (nolock) on p.ClientKey = ck.CompanyKey
		WHERE #tDiscrepancyInvoice.TransactionType = 'Insertion Order' 
			AND #tDiscrepancyInvoice.InvoiceType > 0
	END
	ELSE
	BEGIN
		UPDATE #tDiscrepancyInvoice set  #tDiscrepancyInvoice.ProjectName = ISNULL(p.ProjectNumber + ' - ' + p.ProjectName, '[No Project]'),
											 #tDiscrepancyInvoice.ProjectKey = ISNULL(p.ProjectKey, 0),
											 #tDiscrepancyInvoice.StationName = ISNULL(cm.StationID, vend.VendorID) + ' - ' + ISNULL(cm.Name, vend.CompanyName),
											 #tDiscrepancyInvoice.CompanyMediaKey = ISNULL(po.CompanyMediaKey, isnull(po.VendorKey, 0)),
											 #tDiscrepancyInvoice.CompanyName = ISNULL(ck.CustomerID + ' - ' + ck.CompanyName, '[No Client]'),
											 #tDiscrepancyInvoice.ClientKey = ISNULL( me.ClientKey, 0),
											 #tDiscrepancyInvoice.EstimateName = ISNULL(me.EstimateID + ' - ' + me.EstimateName, '[No Estimate]'),
											 #tDiscrepancyInvoice.MediaEstimateKey = ISNULL(po.MediaEstimateKey,0),
											 #tDiscrepancyInvoice.TransactionMonth = datename(mm, pod.DetailOrderDate)
			FROM #tDiscrepancyInvoice
				INNER JOIN tPurchaseOrderDetail pod (nolock) on #tDiscrepancyInvoice.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
				INNER JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
				INNER JOIN tCompany vend (nolock) on po.VendorKey = vend.CompanyKey
				LEFT OUTER JOIN tProject p (nolock) on pod.ProjectKey = p.ProjectKey
				LEFT OUTER JOIN tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
				LEFT OUTER JOIN tMediaEstimate me(nolock) on po.MediaEstimateKey = me.MediaEstimateKey
				LEFT OUTER JOIN tCompany ck (nolock) on me.ClientKey = ck.CompanyKey
			WHERE #tDiscrepancyInvoice.TransactionType = 'Insertion Order' 
				AND #tDiscrepancyInvoice.InvoiceType > 0
	END
	
	IF @BCClientLink = 1
	BEGIN
		UPDATE #tDiscrepancyInvoice set  #tDiscrepancyInvoice.ProjectName = ISNULL(p.ProjectNumber + ' - ' + p.ProjectName, '[No Project]'),
		                                 #tDiscrepancyInvoice.ProjectKey = ISNULL(p.ProjectKey, 0),
										 #tDiscrepancyInvoice.StationName = ISNULL(cm.StationID, vend.VendorID) + ' - ' + ISNULL(cm.Name, vend.CompanyName),
										 #tDiscrepancyInvoice.CompanyMediaKey = ISNULL(po.CompanyMediaKey, isnull(po.VendorKey, 0)),
										 #tDiscrepancyInvoice.CompanyName = ISNULL(ck.CustomerID + ' - ' + ck.CompanyName, '[No Client]'),
										 #tDiscrepancyInvoice.ClientKey = ISNULL(p.ClientKey, 0),
										 #tDiscrepancyInvoice.EstimateName = ISNULL(me.EstimateID + ' - ' + me.EstimateName, '[No Estimate]'),
										 #tDiscrepancyInvoice.MediaEstimateKey = ISNULL(po.MediaEstimateKey,0),
										 #tDiscrepancyInvoice.TransactionMonth = datename(mm, pod.DetailOrderDate)
		FROM #tDiscrepancyInvoice
			INNER JOIN tPurchaseOrderDetail pod (nolock) on #tDiscrepancyInvoice.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			INNER JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
			INNER JOIN tCompany vend (nolock) on po.VendorKey = vend.CompanyKey
			LEFT OUTER JOIN tProject p (nolock) on pod.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
			LEFT OUTER JOIN tMediaEstimate me(nolock) on po.MediaEstimateKey = me.MediaEstimateKey
			LEFT OUTER JOIN tCompany ck (nolock) on p.ClientKey = ck.CompanyKey
		WHERE #tDiscrepancyInvoice.TransactionType = 'Broadcast Order' 
			AND #tDiscrepancyInvoice.InvoiceType > 0
	END
	ELSE
	BEGIN
		UPDATE #tDiscrepancyInvoice set  #tDiscrepancyInvoice.ProjectName = ISNULL(p.ProjectNumber + ' - ' + p.ProjectName, '[No Project]'),
		                                     #tDiscrepancyInvoice.ProjectKey = ISNULL(p.ProjectKey, 0),
											 #tDiscrepancyInvoice.StationName = ISNULL(cm.StationID, vend.VendorID) + ' - ' + ISNULL(cm.Name, vend.CompanyName),
											 #tDiscrepancyInvoice.CompanyMediaKey = ISNULL(po.CompanyMediaKey, isnull(po.VendorKey, 0)),
											 #tDiscrepancyInvoice.CompanyName = ISNULL(ck.CustomerID + ' - ' + ck.CompanyName, '[No Client]'),
											 #tDiscrepancyInvoice.ClientKey = ISNULL( me.ClientKey, 0),
											 #tDiscrepancyInvoice.EstimateName = ISNULL(me.EstimateID + ' - ' + me.EstimateName, '[No Estimate]'),
											 #tDiscrepancyInvoice.MediaEstimateKey = ISNULL(po.MediaEstimateKey,0),
											 #tDiscrepancyInvoice.TransactionMonth = datename(mm, pod.DetailOrderDate)
			FROM #tDiscrepancyInvoice
				INNER JOIN tPurchaseOrderDetail pod (nolock) on #tDiscrepancyInvoice.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
				INNER JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
				INNER JOIN tCompany vend (nolock) on po.VendorKey = vend.CompanyKey
				LEFT OUTER JOIN tProject p (nolock) on pod.ProjectKey = p.ProjectKey
				LEFT OUTER JOIN tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
				LEFT OUTER JOIN tMediaEstimate me(nolock) on po.MediaEstimateKey = me.MediaEstimateKey
				LEFT OUTER JOIN tCompany ck (nolock) on me.ClientKey = ck.CompanyKey
			WHERE #tDiscrepancyInvoice.TransactionType = 'Broadcast Order' 
				AND #tDiscrepancyInvoice.InvoiceType > 0
	
	END
	
	UPDATE #tDiscrepancyInvoice set  #tDiscrepancyInvoice.ProjectName = ISNULL(p.ProjectNumber + ' - ' + p.ProjectName, '[No Project]'),
	                                     #tDiscrepancyInvoice.ProjectKey = ISNULL(p.ProjectKey, 0),
										 #tDiscrepancyInvoice.StationName = ISNULL(cm.StationID, vend.VendorID) + ' - ' + ISNULL(cm.Name, vend.CompanyName),
										 #tDiscrepancyInvoice.CompanyMediaKey = ISNULL(po.CompanyMediaKey, isnull(po.VendorKey, 0)),
										 #tDiscrepancyInvoice.CompanyName = ISNULL(ck.CustomerID + ' - ' + ck.CompanyName, '[No Client]'),
										 #tDiscrepancyInvoice.ClientKey = ISNULL(p.ClientKey, 0),
										 #tDiscrepancyInvoice.EstimateName = ISNULL(me.EstimateID + ' - ' + me.EstimateName, '[No Estimate]'),
										 #tDiscrepancyInvoice.MediaEstimateKey = ISNULL(po.MediaEstimateKey,0),
										 #tDiscrepancyInvoice.TransactionMonth = datename(mm, po.PODate)
		FROM #tDiscrepancyInvoice 
			INNER JOIN tPurchaseOrderDetail pod (nolock) on #tDiscrepancyInvoice.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			INNER JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
			INNER JOIN tCompany vend (nolock) on po.VendorKey = vend.CompanyKey
			LEFT OUTER JOIN tProject p (nolock) on pod.ProjectKey = p.ProjectKey
			LEFT OUTER JOIN tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
			LEFT OUTER JOIN tMediaEstimate me(nolock) on po.MediaEstimateKey = me.MediaEstimateKey
			LEFT OUTER JOIN tCompany ck (nolock) on p.ClientKey = ck.CompanyKey
		WHERE #tDiscrepancyInvoice.TransactionType = 'Purchase Order' 
			AND #tDiscrepancyInvoice.InvoiceType > 0
	
	
update #tDiscrepancyInvoice
set    StationName = REPLACE(StationName, '''', ' ')
      ,CompanyName = REPLACE(CompanyName, '''', ' ')  
	  ,ProjectName = REPLACE(ProjectName, '''', ' ')  
	  ,EstimateName = REPLACE(EstimateName, '''', ' ')  	

	-- Only show distinct invoice numbers
	IF @HideDetails = 1
		SELECT DISTINCT PurchaseOrderKey, InvoiceNumber, InvoiceType, TransactionType, CompanyName, ClientKey, ProjectName, ProjectKey, EstimateName, MediaEstimateKey, StationName, CompanyMediaKey, TransactionMonth, 0 as Paid FROM #tDiscrepancyInvoice WHERE InvoiceType > 0
		ORDER BY InvoiceNumber
	ELSE
		SELECT DISTINCT PurchaseOrderDetailKey, InvoiceNumber, InvoiceType, TransactionType, CompanyName, ClientKey, ProjectName, ProjectKey, EstimateName, MediaEstimateKey, StationName, CompanyMediaKey, TransactionMonth, Paid  FROM #tDiscrepancyInvoice WHERE InvoiceType > 0
		ORDER BY InvoiceNumber
		
	RETURN 1
GO
