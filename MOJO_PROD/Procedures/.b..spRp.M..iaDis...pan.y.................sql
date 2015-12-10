USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptMediaDiscrepancy]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptMediaDiscrepancy]

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
  || 08/24/06 GHL 8.4   Added @ExcludeCommissionOnly (Paid Request) 
  || 03/14/07 GHL 8.4   Complete rewrite for new design   
  || 03/27/07 GHL 8.4   Made modifications requested by Mudd. 
  ||                    i.e. Search criteria should be applied to PO lines only, not the PO header       
  || 04/05/07 GWG 8.411  Changed logic to calc gross ordered based on how it would bill, not just on line gross            
  || 09/02/09 GHL 10.509 (61747) The Gross Invoiced should not take what is Marked As Billed on the voucher lines 
  ||                    associated to the PO
  || 07/26/11 GHL 10.546 (117158) Added a patch to fix the situation when users link through project then 
  ||                     change to media estimate or vice versa
  || 10/06/11 RLB 10.549 (118535) added filtering by client invoice
  || 11/30/11 RLB 10.550 (111545) Adding option to inculde purchase orders in report
  || 12/09/11 RLB 10.551 (123024) Added Filters for Vendor, Publications and Stations
  || 04/17/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
  || 01/03/13 WDF 10.563  (159100) Added AccountManager
  || 01/07/13 GHL 10.563  (159100) Added nolock
  || 05/02/13 GHL 10.567  (176580) Added AdjustmentNumber to help out with media issues
  || 08/22/13 RLB 10.571  (185720) Added date ranges for IO, BO and PO's
  || 12/17/13 WDF 10.575  (199715) Set Temp Table 'ShortDescription' to Varchar(300) to match 'pod' size
  || 12/18/13 WDF 10.575  (200155) Commented out '@HideDetails = 1' select and replaced with 'select *'
  || 04/28/14 RLB 10.579   (214240) Increasing po line description
  || 05/20/14 GHL 10.580  (216947) Added prevention against apostrophes in some names because they are crashing
  ||                      the report in vb 
  || 09/18/14 WDF 10.584  (218181) Added ParentClientKey
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

 CREATE TABLE #tDiscrepancy (
	PurchaseOrderKey INT NULL
	,PurchaseOrderDetailKey INT NULL
	,ClientKey INT NULL
	,ProjectClientKey INT NULL
	,MediaEstimateClientKey INT NULL						
	,GLCompanyKey INT NULL				
	,PurchaseOrderNumber VARCHAR(30) NULL
    ,LineNumber INT NULL
	,AdjustmentNumber INT NULL
	,LineAdjustment varchar(50) NULL
    ,ShortDescription VARCHAR(max) NULL
	,StationName VARCHAR(255) NULL
	,CompanyName VARCHAR(255) NULL
	,ProjectName VARCHAR(255) NULL
	,EstimateName VARCHAR(255) NULL
	,TransactionType VARCHAR(25) NULL
	,TransactionMonth VARCHAR(20) NULL
	,TransactionMonthNumeric INT NULL
	,NetOrdered MONEY NULL
	,NetInvoiced MONEY NULL
	,NetDifference MONEY NULL
	,GrossOrdered MONEY NULL
	,GrossInvoiced MONEY NULL
	,GrossDifference MONEY NULL
	,FlightStartDate DATETIME NULL
	,FlightEndDate DATETIME NULL
	,AccountManager  VARCHAR(201) NULL
	)

if @IO = 1
BEGIN
	 INSERT INTO #tDiscrepancy
	 (PurchaseOrderKey,PurchaseOrderDetailKey,ClientKey,ProjectClientKey,MediaEstimateClientKey,GLCompanyKey,PurchaseOrderNumber,LineNumber,
	 AdjustmentNumber,LineAdjustment,ShortDescription,StationName,CompanyName,ProjectName,EstimateName,TransactionType,TransactionMonth,
	 TransactionMonthNumeric,NetOrdered,NetInvoiced,NetDifference,GrossOrdered,GrossInvoiced,GrossDifference,FlightStartDate,FlightEndDate,
	 AccountManager)
	 Select
			po.PurchaseOrderKey,
			pod.PurchaseOrderDetailKey, 
			0, -- ClientKey
			ISNULL(p.ClientKey,0), -- ProjectClientKey
			ISNULL(me.ClientKey,0), -- MediaEstimateClientKey
			ISNULL(po.GLCompanyKey,0), -- GLCompanyKey
			po.PurchaseOrderNumber,
			pod.LineNumber,
			pod.AdjustmentNumber,
			case when isnull(pod.AdjustmentNumber, 0) = 0 then cast(pod.LineNumber as varchar(50))
				 else cast(pod.LineNumber as varchar(50)) + '.' + cast(pod.AdjustmentNumber as varchar(50))
			end,
			pod.ShortDescription,												-- ShortDescription,
			ISNULL(cm.StationID, vend.VendorID) + ' - ' + ISNULL(cm.Name, vend.CompanyName),	-- StationName
			'[No Client]',						-- CompanyName (Client)
			ISNULL(p.ProjectNumber + ' - ' + p.ProjectName, '[No Project]'),					-- ProjectName
			ISNULL(me.EstimateID + ' - ' + me.EstimateName, '[No Estimate]'),                   -- EstimateName 
			Case 
				When po.POKind = 1 Then 'Insertion Order'
				Else 'Broadcast Order'
			End,																				-- TransationType
			datename(mm, pod.DetailOrderDate),													-- TransactionMonth,		
			datepart(mm, pod.DetailOrderDate),													-- TransactionMonthNumeric,		
			ISNULL(pod.TotalCost, 0),				-- NetOrdered
			ISNULL(pod.AppliedCost, 0),				-- NetInvoiced			
			ISNULL(pod.TotalCost, 0) - ISNULL(pod.AppliedCost, 0), -- NetDifference														
			Case ISNULL(po.BillAt, 0) When 0 then ISNULL(pod.BillableCost, 0) When 1 then ISNULL(pod.TotalCost, 0) When 2 then ISNULL(pod.BillableCost, 0) - ISNULL(pod.TotalCost, 0) end,			-- GrossOrdered													
			-- GrossInvoiced (Add voucher detail contribution later) 
			case when ISNULL(pod.InvoiceLineKey, 0) > 0 then ISNULL(pod.AmountBilled, 0) else 0 end,			
			0,										-- GrossDifference
			pod.DetailOrderDate,
			CASE WHEN po.POKind = 1 THEN NULL ELSE DetailOrderEndDate END,
			u.FirstName + ' ' + u.LastName
		From 
			tPurchaseOrder po (nolock) 
			inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
			left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
			left outer join tUser u (nolock) ON p.AccountManager = u.UserKey
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
			(@ExcludeCommissionOnly = 0 Or po.BillAt <> 2) and-- BillAt 0 Gross, 1 Net, 2 Commission Only
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
	 INSERT INTO #tDiscrepancy
	 (PurchaseOrderKey,PurchaseOrderDetailKey,ClientKey,ProjectClientKey,MediaEstimateClientKey,GLCompanyKey,PurchaseOrderNumber,LineNumber,
	 AdjustmentNumber,LineAdjustment,ShortDescription,StationName,CompanyName,ProjectName,EstimateName,TransactionType,TransactionMonth,
	 TransactionMonthNumeric,NetOrdered,NetInvoiced,NetDifference,GrossOrdered,GrossInvoiced,GrossDifference,FlightStartDate,FlightEndDate,
	 AccountManager)
	 Select
			po.PurchaseOrderKey,
			pod.PurchaseOrderDetailKey, 
			0, -- ClientKey
			ISNULL(p.ClientKey,0), -- ProjectClientKey
			ISNULL(me.ClientKey,0), -- MediaEstimateClientKey
			ISNULL(po.GLCompanyKey,0), -- GLCompanyKey
			po.PurchaseOrderNumber,
			pod.LineNumber,
			pod.AdjustmentNumber,
			case when isnull(pod.AdjustmentNumber, 0) = 0 then cast(pod.LineNumber as varchar(50))
				 else cast(pod.LineNumber as varchar(50)) + '.' + cast(pod.AdjustmentNumber as varchar(50))
			end,
			pod.ShortDescription,												-- ShortDescription,
			ISNULL(cm.StationID, vend.VendorID) + ' - ' + ISNULL(cm.Name, vend.CompanyName),	-- StationName
			'[No Client]',						-- CompanyName (Client)
			ISNULL(p.ProjectNumber + ' - ' + p.ProjectName, '[No Project]'),					-- ProjectName
			ISNULL(me.EstimateID + ' - ' + me.EstimateName, '[No Estimate]'),                   -- EstimateName 
			Case 
				When po.POKind = 1 Then 'Insertion Order'
				Else 'Broadcast Order'
			End,																				-- TransationType
			datename(mm, pod.DetailOrderDate),													-- TransactionMonth,		
			datepart(mm, pod.DetailOrderDate),													-- TransactionMonthNumeric,		
			ISNULL(pod.TotalCost, 0),				-- NetOrdered
			ISNULL(pod.AppliedCost, 0),				-- NetInvoiced			
			ISNULL(pod.TotalCost, 0) - ISNULL(pod.AppliedCost, 0), -- NetDifference														
			Case ISNULL(po.BillAt, 0) When 0 then ISNULL(pod.BillableCost, 0) When 1 then ISNULL(pod.TotalCost, 0) When 2 then ISNULL(pod.BillableCost, 0) - ISNULL(pod.TotalCost, 0) end,			-- GrossOrdered													
			-- GrossInvoiced (Add voucher detail contribution later) 
			case when ISNULL(pod.InvoiceLineKey, 0) > 0 then ISNULL(pod.AmountBilled, 0) else 0 end,			
			0,										-- GrossDifference
			pod.DetailOrderDate,
			CASE WHEN po.POKind = 1 THEN NULL ELSE DetailOrderEndDate END,
			u.FirstName + ' ' + u.LastName
		From 
			tPurchaseOrder po (nolock) 
			inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
			left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
			left outer join tUser u (nolock) ON p.AccountManager = u.UserKey
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
			(@ExcludeCommissionOnly = 0 Or po.BillAt <> 2) and-- BillAt 0 Gross, 1 Net, 2 Commission Only
			(@InvoiceKey is null or iv.InvoiceKey = @InvoiceKey) and
			(@VendorKey is null or po.VendorKey = @VendorKey) and
			(@StationMediaKey is null or po.CompanyMediaKey = @StationMediaKey) and
			(ISNULL(@ParentClientKey,0)      = 0                           or 
			 ISNULL(p.ClientKey, 0)          = ISNULL(@ParentClientKey, 0) or
			 ISNULL(me.ClientKey, 0)         = ISNULL(@ParentClientKey, 0) or
			 ISNULL(cp.ParentCompanyKey, 0)  = ISNULL(@ParentClientKey, 0) or
			 ISNULL(cme.ParentCompanyKey, 0) = ISNULL(@ParentClientKey, 0))
END

	if @MediaEstimateKey IS NULL and  @IncludePurchaseOrders = 1 
		BEGIN
			INSERT INTO #tDiscrepancy
			 (PurchaseOrderKey,PurchaseOrderDetailKey,ClientKey,ProjectClientKey,MediaEstimateClientKey,GLCompanyKey,PurchaseOrderNumber,LineNumber,
			 AdjustmentNumber,LineAdjustment,ShortDescription,StationName,CompanyName,ProjectName,EstimateName,TransactionType,TransactionMonth,
			 TransactionMonthNumeric,NetOrdered,NetInvoiced,NetDifference,GrossOrdered,GrossInvoiced,GrossDifference,FlightStartDate,FlightEndDate,
			 AccountManager)
			Select
				po.PurchaseOrderKey,
				pod.PurchaseOrderDetailKey, 
				0, -- ClientKey
				ISNULL(p.ClientKey,0), -- ProjectClientKey
				ISNULL(me.ClientKey,0), -- MediaEstimateClientKey
				ISNULL(po.GLCompanyKey,0), -- GLCompanyKey
				po.PurchaseOrderNumber,
				pod.LineNumber,
				pod.AdjustmentNumber,
				case when isnull(pod.AdjustmentNumber, 0) = 0 then cast(pod.LineNumber as varchar(50))
					else cast(pod.LineNumber as varchar(50)) + '.' + cast(pod.AdjustmentNumber as varchar(50))
				end,
				pod.ShortDescription,												-- ShortDescription,
				ISNULL(cm.StationID, vend.VendorID) + ' - ' + ISNULL(cm.Name, vend.CompanyName),	-- StationName
				'[No Client]',						-- CompanyName (Client)
				ISNULL(p.ProjectNumber + ' - ' + p.ProjectName, '[No Project]'),					-- ProjectName
				ISNULL(me.EstimateID + ' - ' + me.EstimateName, '[No Estimate]'),                   -- EstimateName 
				Case 
					When po.POKind = 1 Then 'Insertion Order'
					When po.POKind = 2 Then 'Broadcast Order'
					Else 'Purchase Order'
				End,																				-- TransationType
				datename(mm, po.PODate),													-- TransactionMonth,		
				datepart(mm, po.PODate),													-- TransactionMonthNumeric,		
				ISNULL(pod.TotalCost, 0),				-- NetOrdered
				ISNULL(pod.AppliedCost, 0),				-- NetInvoiced			
				ISNULL(pod.TotalCost, 0) - ISNULL(pod.AppliedCost, 0), -- NetDifference														
				Case ISNULL(po.BillAt, 0) When 0 then ISNULL(pod.BillableCost, 0) When 1 then ISNULL(pod.TotalCost, 0) When 2 then ISNULL(pod.BillableCost, 0) - ISNULL(pod.TotalCost, 0) end,			-- GrossOrdered													
				-- GrossInvoiced (Add voucher detail contribution later) 
				case when ISNULL(pod.InvoiceLineKey, 0) > 0 then ISNULL(pod.AmountBilled, 0) else 0 end,			
				0,										-- GrossDifference
				po.PODate as DetailOrderDate,
				CASE WHEN po.POKind = 1 THEN NULL ELSE DetailOrderEndDate END,
				u.FirstName + ' ' + u.LastName
			From 
				tPurchaseOrder po (nolock) 
				inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
				left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
				left outer join tUser u (nolock) on p.AccountManager = u.UserKey
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


	IF @IOClientLink = 1
		-- client via project
		UPDATE #tDiscrepancy
		SET    ClientKey = ProjectClientKey 
		WHERE  TransactionType = 'Insertion Order'    
	ELSE
		-- client via media estimate
		UPDATE #tDiscrepancy
		SET    ClientKey = MediaEstimateClientKey 
		WHERE  TransactionType = 'Insertion Order'    
	
	IF @BCClientLink = 1
		-- client via project
		UPDATE #tDiscrepancy
		SET    ClientKey = ProjectClientKey 
		WHERE  TransactionType = 'Broadcast Order'    
	ELSE
		-- client via media estimate
		UPDATE #tDiscrepancy
		SET    ClientKey = MediaEstimateClientKey 
		WHERE  TransactionType = 'Broadcast Order'    

	-- now patch the client when the users changed the IOClientLink/BCClientLink
	UPDATE #tDiscrepancy
	SET    ClientKey = ProjectClientKey 
	WHERE  ISNULL(ClientKey, 0) = 0	

	UPDATE #tDiscrepancy
	SET    ClientKey = MediaEstimateClientKey 
	WHERE  ISNULL(ClientKey, 0) = 0	

	IF @ClientKey IS NOT NULL
		DELETE #tDiscrepancy WHERE ISNULL(ClientKey, 0) <> @ClientKey
	
	IF @RestrictToGLCompany = 1
		DELETE #tDiscrepancy WHERE ISNULL(GLCompanyKey, 0) 
			NOT IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)

	UPDATE #tDiscrepancy
	SET    #tDiscrepancy.CompanyName = ISNULL(c.CustomerID + ' - ' + c.CompanyName, '[No Client]')
	FROM   tCompany c (NOLOCK)
	WHERE  #tDiscrepancy.ClientKey = c.CompanyKey	


	UPDATE #tDiscrepancy
	SET   #tDiscrepancy.GrossInvoiced = #tDiscrepancy.GrossInvoiced -- Already have the pod part, add the voucher part
		
		+ ISNULL((
		SELECT SUM(vd.AmountBilled) FROM tVoucherDetail vd (NOLOCK) 
		WHERE #tDiscrepancy.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		AND   vd.InvoiceLineKey > 0 -- really Invoiced, not marked as Billed
		),0)
		

	UPDATE #tDiscrepancy
	SET    #tDiscrepancy.GrossDifference = #tDiscrepancy.GrossOrdered - #tDiscrepancy.GrossInvoiced
				
	-- If gross difference only, delete when = 0	
	IF @OverUnderGross = 1
		DELETE #tDiscrepancy WHERE GrossDifference = 0


update #tDiscrepancy
set    StationName = REPLACE(StationName, '''', ' ')
      ,CompanyName = REPLACE(CompanyName, '''', ' ')  
	  ,ProjectName = REPLACE(ProjectName, '''', ' ')  
	  ,EstimateName = REPLACE(EstimateName, '''', ' ')  
	  
IF @HideDetails = 1
BEGIN
	-- One line per order

	-- The short description is incorrect
	-- Replace by Publication/Station or vendor name if no station
	
	UPDATE #tDiscrepancy
	SET	   #tDiscrepancy.ShortDescription = ISNULL(cm.StationID, vend.VendorID)
	FROM   tPurchaseOrder po (nolock) 
	inner join tCompany vend (nolock) on po.VendorKey = vend.CompanyKey
	left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey	
	where  #tDiscrepancy.PurchaseOrderKey = po.PurchaseOrderKey
	
	SELECT * FROM #tDiscrepancy

	/*
	SELECT PurchaseOrderKey
		,0 AS PurchaseOrderDetailKey
		,0 AS ClientKey 
		,0 AS ProjectClientKey 
		,0 AS MediaEstimateClientKey						
		,PurchaseOrderNumber 
		,0 AS LineNumber 
		,ShortDescription   -- Will be the same
		,StationName 
		,CompanyName      
		,'' AS ProjectName  -- We cannot group by ProjectName since the lines may have different projects
		,EstimateName 
		,TransactionType 
		,'' AS TransactionMonth  -- We cannot group by TransactionMonth since the lines may have different dates
		,0 AS TransactionMonthNumeric -- We cannot group by TransactionMonth since the lines may have different dates
		,SUM(NetOrdered)		AS NetOrdered
		,SUM(NetInvoiced)		AS NetInvoiced
		,SUM(NetDifference)		AS NetDifference
		,SUM(GrossOrdered)		AS GrossOrdered
		,SUM(GrossInvoiced)		AS GrossInvoiced
		,SUM(GrossDifference)	AS GrossDifference
		,MIN(FlightStartDate)	AS FlightStartDate 
		,MAX(FlightEndDate)		AS FlightEndDate
		,AccountManager
	FROM #tDiscrepancy
	GROUP BY PurchaseOrderKey, PurchaseOrderNumber, ShortDescription
			,StationName , CompanyName, EstimateName, TransactionType, AccountManager
	*/
END			
ELSE
	SELECT * FROM #tDiscrepancy

RETURN 1
GO
