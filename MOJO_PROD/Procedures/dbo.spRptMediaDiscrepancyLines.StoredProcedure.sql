USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptMediaDiscrepancyLines]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptMediaDiscrepancyLines]

	(
		@CompanyKey int,
		@ClientKey int,
		@ParentClientKey int,
		@MediaEstimateKey int,
		@ProjectKey int,
		@IO tinyint,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@BC tinyint,
		@StartDateBO smalldatetime,
		@EndDateBO smalldatetime,
		@IncludePurchaseOrders tinyint,
		@StartDatePO smalldatetime,
		@EndDatePO smalldatetime,
		@ShowClosedOrders int,  -- 1 Closed and Open Orders, 0 Open Orders
		@OverUnderNet int,    -- 1 Net difference <> 0 only, 0 all 
		@OverUnderGross int,  -- 1 Gross difference <> 0 only, 0 all
		@ExcludeCommissionOnly tinyint,
		@HideDetails tinyint,
		@InvoiceKey int,
		@VendorKey int,
		@PublicationMediaKey int,
		@StationMediaKey int,
		@UserKey int = null
		
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 03/27/07 GHL 8.4   Creation for modifications requested by Mudd. 
  ||                    i.e. Search criteria should be applied to PO lines only, not the PO header
  ||                    + they want to see the same invoices when hiding details (1 line per IO/BC)
  ||                    we need to build a list of PurchaseOrderDetailKeys with same criteria    
  || 04/04/07 GHL 8.4   Corrected delete statement when a client is selected  
  || 04/05/07 GWG 8.411  Changed logic to calc gross ordered based on how it would bill, not just on line gross
  || 10/06/11 RLB 10.549 (118535) added filtering by client invoice 
  || 11/30/11 RLB 10.550 (111545) Adding option to inculde purchase orders in report    
  || 12/09/11 RLB 10.551 (123024) Added Filters for Vendor, Publications and Stations 
  || 04/17/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
  || 08/22/13 RLB 10.571  (185720) Added date ranges for IO, BO and PO's          
  || 10/22/14 WDF 10.584  (218181) Added ParentClientKey
  || 10/30/14 GHL 10.585  (234458) Checking pod.InvoiceLineKey > 0 to calc GrossInvoiced
  */
 
 DECLARE @IOClientLink INT -- 1 via Project, 2 via Media Estimate
        ,@BCClientLink INT
        
 select @IOClientLink = isnull(IOClientLink,1)
	    ,@BCClientLink = isnull(BCClientLink,1)
	  from tPreference (nolock)
	 where CompanyKey = @CompanyKey

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

 CREATE TABLE #tDiscrepancyLines (
	PurchaseOrderKey INT NULL
	,PurchaseOrderDetailKey INT NULL
	,GLCompanyKey INT NULL
	,ProjectClientKey INT NULL
	,MediaEstimateClientKey INT NULL						
	,TransactionType VARCHAR(25) NULL
	,NetOrdered MONEY NULL
	,NetInvoiced MONEY NULL
	,NetDifference MONEY NULL
	,GrossOrdered MONEY NULL
	,GrossInvoiced MONEY NULL
	,GrossDifference MONEY NULL
	,FlightStartDate DATETIME NULL
	)

IF @IO = 1
BEGIN

	 INSERT INTO #tDiscrepancyLines
	 (PurchaseOrderKey,PurchaseOrderDetailKey,GLCompanyKey,ProjectClientKey,MediaEstimateClientKey,TransactionType,NetOrdered,NetInvoiced,NetDifference,
	 GrossOrdered,GrossInvoiced,GrossDifference,FlightStartDate)
	 Select
			po.PurchaseOrderKey,
			pod.PurchaseOrderDetailKey,
			po.GLCompanyKey, 
			p.ClientKey, -- ProjectClientKey
			me.ClientKey, -- MediaEstimateClientKey
			Case 
				When po.POKind = 1 Then 'Insertion Order'
				Else 'Broadcast Order'
			End,																				-- TransationType
			ISNULL(pod.TotalCost, 0),				-- NetOrdered
			ISNULL(pod.AppliedCost, 0),				-- NetInvoiced			
			ISNULL(pod.TotalCost, 0) - ISNULL(pod.AppliedCost, 0), -- NetDifference														
			Case ISNULL(po.BillAt, 0) When 0 then ISNULL(pod.BillableCost, 0) When 1 then ISNULL(pod.TotalCost, 0) When 2 then ISNULL(pod.BillableCost, 0) - ISNULL(pod.TotalCost, 0) end,			-- GrossOrdered													
			-- GrossInvoiced (Add voucher detail contribution later) 
			case when ISNULL(pod.InvoiceLineKey, 0) > 0 then ISNULL(pod.AmountBilled, 0) else 0 end,			
			0,										-- GrossDifference
			pod.DetailOrderDate

		From 
			tPurchaseOrder po (nolock) 
			inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
			left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
			inner join tCompany vend (nolock) on po.VendorKey = vend.CompanyKey
			left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
			left outer join tMediaEstimate me(nolock) on po.MediaEstimateKey = me.MediaEstimateKey 
			left outer join tInvoiceLine  ivl (nolock) on pod.InvoiceLineKey = ivl.InvoiceLineKey
			left outer join tInvoice iv (nolock) on ivl.InvoiceKey = iv.InvoiceKey				
			left outer join tCompany cp (nolock) on p.ClientKey = cp.CompanyKey 
			left outer join tCompany cme (nolock) on me.ClientKey = cme.CompanyKey 
			Where 
			po.POKind = 1 and
			po.CompanyKey = @CompanyKey and
			pod.DetailOrderDate >= @StartDate and
			pod.DetailOrderDate <= @EndDate and
			(@ProjectKey IS NULL Or pod.ProjectKey = @ProjectKey) and
			(@MediaEstimateKey IS NULL Or po.MediaEstimateKey = @MediaEstimateKey) and
			(@ShowClosedOrders = 1 Or pod.Closed = 0) and 
			(@OverUnderNet = 0 Or (ISNULL(pod.TotalCost, 0) <> ISNULL(pod.AppliedCost, 0))) and 
			(@ExcludeCommissionOnly = 0 Or po.BillAt <> 2) and -- BillAt 0 Gross, 1 Net, 2 Commission Only
			(@InvoiceKey is null or iv.InvoiceKey = @InvoiceKey) and
			(@VendorKey is null or po.VendorKey = @VendorKey) and
			(@PublicationMediaKey is null or po.CompanyMediaKey = @PublicationMediaKey) and
			(ISNULL(@ParentClientKey,0)      = 0                           or 
			 ISNULL(p.ClientKey, 0)          = ISNULL(@ParentClientKey, 0) or
			 ISNULL(me.ClientKey, 0)         = ISNULL(@ParentClientKey, 0) or
			 ISNULL(cp.ParentCompanyKey, 0)  = ISNULL(@ParentClientKey, 0) or
			 ISNULL(cme.ParentCompanyKey, 0) = ISNULL(@ParentClientKey, 0))
			
END

IF @BC = 1
BEGIN

	  INSERT INTO #tDiscrepancyLines
	 (PurchaseOrderKey,PurchaseOrderDetailKey,GLCompanyKey,ProjectClientKey,MediaEstimateClientKey,TransactionType,NetOrdered,NetInvoiced,NetDifference,
	 GrossOrdered,GrossInvoiced,GrossDifference,FlightStartDate)
		Select
			po.PurchaseOrderKey,
			pod.PurchaseOrderDetailKey,
			po.GLCompanyKey, 
			p.ClientKey, -- ProjectClientKey
			me.ClientKey, -- MediaEstimateClientKey
			Case 
				When po.POKind = 1 Then 'Insertion Order'
				Else 'Broadcast Order'
			End,																				-- TransationType
			ISNULL(pod.TotalCost, 0),				-- NetOrdered
			ISNULL(pod.AppliedCost, 0),				-- NetInvoiced			
			ISNULL(pod.TotalCost, 0) - ISNULL(pod.AppliedCost, 0), -- NetDifference														
			Case ISNULL(po.BillAt, 0) When 0 then ISNULL(pod.BillableCost, 0) When 1 then ISNULL(pod.TotalCost, 0) When 2 then ISNULL(pod.BillableCost, 0) - ISNULL(pod.TotalCost, 0) end,			-- GrossOrdered													
			-- GrossInvoiced (Add voucher detail contribution later) 
			case when ISNULL(pod.InvoiceLineKey, 0) > 0 then ISNULL(pod.AmountBilled, 0) else 0 end,			
			0,										-- GrossDifference
			pod.DetailOrderDate

		From 
			tPurchaseOrder po (nolock) 
			inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
			left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
			inner join tCompany vend (nolock) on po.VendorKey = vend.CompanyKey
			left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
			left outer join tMediaEstimate me(nolock) on po.MediaEstimateKey = me.MediaEstimateKey 
			left outer join tInvoiceLine  ivl (nolock) on pod.InvoiceLineKey = ivl.InvoiceLineKey
			left outer join tInvoice iv (nolock) on ivl.InvoiceKey = iv.InvoiceKey				
			left outer join tCompany cp (nolock) on p.ClientKey = cp.CompanyKey 
			left outer join tCompany cme (nolock) on me.ClientKey = cme.CompanyKey 
			Where 
			po.POKind = 2 and
			po.CompanyKey = @CompanyKey and
			pod.DetailOrderDate >= @StartDateBO and
			pod.DetailOrderDate <= @EndDateBO and
			(@ProjectKey IS NULL Or pod.ProjectKey = @ProjectKey) and
			(@MediaEstimateKey IS NULL Or po.MediaEstimateKey = @MediaEstimateKey) and
			(@ShowClosedOrders = 1 Or pod.Closed = 0) and 
			(@OverUnderNet = 0 Or (ISNULL(pod.TotalCost, 0) <> ISNULL(pod.AppliedCost, 0))) and 
			(@ExcludeCommissionOnly = 0 Or po.BillAt <> 2) and -- BillAt 0 Gross, 1 Net, 2 Commission Only
			(@InvoiceKey is null or iv.InvoiceKey = @InvoiceKey) and
			(@VendorKey is null or po.VendorKey = @VendorKey) and
			(@StationMediaKey is null or po.CompanyMediaKey = @StationMediaKey) and
			(ISNULL(@ParentClientKey,0)      = 0                           or 
			 ISNULL(p.ClientKey, 0)          = ISNULL(@ParentClientKey, 0) or
			 ISNULL(me.ClientKey, 0)         = ISNULL(@ParentClientKey, 0) or
			 ISNULL(cp.ParentCompanyKey, 0)  = ISNULL(@ParentClientKey, 0) or
			 ISNULL(cme.ParentCompanyKey, 0) = ISNULL(@ParentClientKey, 0))
END


	IF @MediaEstimateKey IS NULL and  @IncludePurchaseOrders = 1 
	BEGIN
		 INSERT #tDiscrepancyLines
		 Select
				po.PurchaseOrderKey,
				pod.PurchaseOrderDetailKey, 
				po.GLCompanyKey, 
				p.ClientKey, -- ProjectClientKey
				me.ClientKey, -- MediaEstimateClientKey
				Case 
					When po.POKind = 1 Then 'Insertion Order'
					When po.POKind = 2 Then 'Broadcast Order'
					Else 'Purchase Order'
				End,																				-- TransationType
				ISNULL(pod.TotalCost, 0),				-- NetOrdered
				ISNULL(pod.AppliedCost, 0),				-- NetInvoiced			
				ISNULL(pod.TotalCost, 0) - ISNULL(pod.AppliedCost, 0), -- NetDifference														
				Case ISNULL(po.BillAt, 0) When 0 then ISNULL(pod.BillableCost, 0) When 1 then ISNULL(pod.TotalCost, 0) When 2 then ISNULL(pod.BillableCost, 0) - ISNULL(pod.TotalCost, 0) end,			-- GrossOrdered													
				-- GrossInvoiced (Add voucher detail contribution later) 
				case when ISNULL(pod.InvoiceLineKey, 0) > 0 then ISNULL(pod.AmountBilled, 0) else 0 end,			
				0,										-- GrossDifference
				po.PODate as DetailOrderDate

			From 
				tPurchaseOrder po (nolock) 
				inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
				left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
				inner join tCompany vend (nolock) on po.VendorKey = vend.CompanyKey
				left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
				left outer join tMediaEstimate me(nolock) on po.MediaEstimateKey = me.MediaEstimateKey 
				left outer join tInvoiceLine  ivl (nolock) on pod.InvoiceLineKey = ivl.InvoiceLineKey
				left outer join tInvoice iv (nolock) on ivl.InvoiceKey = iv.InvoiceKey				
				left outer join tCompany cp (nolock) on p.ClientKey = cp.CompanyKey 
				left outer join tCompany cme (nolock) on me.ClientKey = cme.CompanyKey 
			Where 
				po.POKind = 0 and
				po.CompanyKey = @CompanyKey and
				po.PODate >= @StartDatePO and
				po.PODate <= @EndDatePO and
				(@ProjectKey IS NULL Or pod.ProjectKey = @ProjectKey) and
				(@ShowClosedOrders = 1 Or pod.Closed = 0) and 
				(@OverUnderNet = 0 Or (ISNULL(pod.TotalCost, 0) <> ISNULL(pod.AppliedCost, 0))) and 
				(@InvoiceKey is null or iv.InvoiceKey = @InvoiceKey) and
				(@VendorKey is null or po.VendorKey = @VendorKey) and
				(ISNULL(@ParentClientKey,0)      = 0                           or 
				 ISNULL(p.ClientKey, 0)          = ISNULL(@ParentClientKey, 0) or
				 ISNULL(me.ClientKey, 0)         = ISNULL(@ParentClientKey, 0) or
				 ISNULL(cp.ParentCompanyKey, 0)  = ISNULL(@ParentClientKey, 0) or
				 ISNULL(cme.ParentCompanyKey, 0) = ISNULL(@ParentClientKey, 0))
	END


	IF @ClientKey IS NOT NULL
	BEGIN
		IF @IOClientLink = 1
		BEGIN
			-- client via project
			DELETE #tDiscrepancyLines
			WHERE  (ProjectClientKey IS NULL
			OR     ProjectClientKey <> @ClientKey)
			AND    TransactionType = 'Insertion Order'    
		END
		ELSE
		BEGIN
		    -- client via media estimate
			DELETE #tDiscrepancyLines
			WHERE  (MediaEstimateClientKey IS NULL
			OR     MediaEstimateClientKey <> @ClientKey)
			AND    TransactionType = 'Insertion Order'    
		END
		
		IF @BCClientLink = 1
		BEGIN
			-- client via project
			DELETE #tDiscrepancyLines
			WHERE  (ProjectClientKey IS NULL
			OR     ProjectClientKey <> @ClientKey)
			AND    TransactionType = 'Broadcast Order'    
		END
		ELSE
		BEGIN
		    -- client via media estimate
			DELETE #tDiscrepancyLines
			WHERE  (MediaEstimateClientKey IS NULL
			OR     MediaEstimateClientKey <> @ClientKey)
			AND    TransactionType = 'Broadcast Order'    
		END
				
	END
	
	IF @RestrictToGLCompany = 1
	DELETE #tDiscrepancy WHERE ISNULL(GLCompanyKey, 0) 
		NOT IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)


	UPDATE #tDiscrepancyLines
	SET   #tDiscrepancyLines.GrossInvoiced = #tDiscrepancyLines.GrossInvoiced -- Already have the pod part, add the voucher part
		
		+ ISNULL((
		SELECT SUM(vd.AmountBilled) FROM tVoucherDetail vd (NOLOCK) 
		WHERE #tDiscrepancyLines.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		),0)
		

	UPDATE #tDiscrepancyLines
	SET    #tDiscrepancyLines.GrossDifference = #tDiscrepancyLines.GrossOrdered 
		- #tDiscrepancyLines.GrossInvoiced
				
	-- If gross difference only, delete when =	
	IF @OverUnderGross = 1
		DELETE #tDiscrepancyLines WHERE GrossDifference = 0

	SELECT PurchaseOrderDetailKey, TransactionType FROM #tDiscrepancyLines
	
RETURN 1
GO
