USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptAccruedOrderDetail]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptAccruedOrderDetail]
	(
	@CompanyKey INT = null,
	@AsOfDate SMALLDATETIME = null,
	@ClientKey INT = null,				-- NULL or valid client
	@VendorKey INT = null,				-- NULL or valid vendor
	@GLCompanyKey INT = null,			-- NULL or valid company
	@OfficeKey INT = null,				-- NULL or valid office
	@ShowPurchaseOrders INT = 1,		-- 0 or 1
	@ShowMedia INT = 1					-- 0 or 1
	,@PurchaseOrderKey INT = null		-- Added for drill down on the new Accrued Order Detail report
	,@UserKey INT = null
	)

AS --Encrypt

	SET NOCOUNT ON 

  /*
  || When     Who Rel      What
  || 08/24/06 GHL 8.35     Added search criteria by client 
  ||                       Also added group by Station/Client. (i.e cols) (Paid request for The Mudd Group)
  || 08/30/06 GHL 8.35     Added field AccruedBalance after customer complained that wanted a summary (not report group)
  ||                       Needed field to show in the header of report group instead of footer
  || 02/09/07 BSH 8.4      Added condition to show prebilled items only, corrected net amount.
  || 03/09/07 GHL 8.407    Added search criteria by vendor 
  || 03/12/07 GHL 8.407    Added field tVoucherDetail.LastVoucher since we should not show POs where
  ||                       a voucher has been specified as LastVoucher
  || 03/14/07 GHL 8.407    Added Line Number
  || 04/05/07 GWG 8.411    Changed to Net Amount to look at the invoice posting date compared to the as of date. if less than today, no accrual
  || 10/29/07 RLB 8.439    Added po.BillAt in (0,1) to report to filter out Media orders billed at commission only
  || 11/05/07 GHL 8.440    (15332) Added Adjustment Number
  || 01/18/08 GWG 8.5      Fixed the calc using invoice date instead of posting date
  || 01/30/08 GHL 8.5      (20361) Take in consideration the 2 cases:
  ||                       1) Invoice PostingDate <= @AsOfDate
  ||                       2) Invoice PostingDate > @AsOfDate then check if exists Voucher PostingDate < @AsOfDate 
  || 04/01/09 RTC 10.0.2.2 (49681) TotalCost was not always stored as two decimal places.  The accrued balance is now rounded to two decimal places
  ||                       to prevent order lines with more than two decimal places from apeeraing on this report.
  || 04/29/09 GHL/GWG 10.024   Using now tTransactionOrderAccrual (tweaked for date, now <=  
  || 04/09/10 RLB 10.5.2.1 Adding Media Estimate so it can be grouped by it
  || 07/13/11 RLB 10.5.4.6 (113900) Added Filter for GLCompany and Office
  || 01/23/12 GHL 10.5.5.2 Added TotalCost,VendorName,PurchaseOrderKey,CampaignName for dynamic report
  || 01/27/12 GHL 10.5.5.2 Added PurchaseOrderKey for drill downs
  || 01/30/12 GHL 10.5.5.2 Added POClosed and Closed fields
  || 04/13/12 GHL 10.555   Added UserKey for UserGLCompanyAccess
  || 03/06/13 GHL 10.565   (170681) Increased ShortDescription to 300
  || 03/14/13 GHL 10.565   (171646) To fix problems at Nerland where we have fixed some accruals because they had 3 digits
  ||                        decided to pick up all accruals with 4 digits, delete if accrual diff = 0
  ||                        then round at 2 and delete if accrual diff = 0 again 
  ||                       (initially we only had 1 pass...round at 2 and delete)
  || 05/03/13 GHL 10.567   (176850) Pulling now the detail order date to use when printing details (rather than PODate)
  || 04/28/14 RLB 10.579   (214240) Increasing po line description
  || 06/06/14 GHL 10.580   (218853) Pulling the po line description in the initial query was timeout at Nerland
  ||                       I am pulling it now after the initial query
  || 09/16/14 GHL 10.584   (229748) Removing now zero lines from the report
  */

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

-- If you add fields here or on the final query (or change order)
-- Modify APAccruedOrderDetail.vb (standard report)
-- And APAccruedOrder.vb (dynamic report)
CREATE TABLE #tAccruedBalance (
		PurchaseOrderDetailKey INT NULL
		,TotalCost MONEY NULL
		,AccruedCost MONEY NULL
		,PrebillAmount MONEY NULL
		,AccruedBalance MONEY NULL   -- we will not keep if AccruedBalance = 0 
		,Closed int null

		-- Populate what we can from the initial queries without other joins
		,PODate SMALLDATETIME NULL
		,DetailOrderDate SMALLDATETIME NULL
		,POKind INT NULL
		,POClosed int null
		,PurchaseOrderNumber VARCHAR(30) NULL
		,PurchaseOrderKey INT NULL
		,ProjectKey INT NULL
		,VendorKey INT NULL
		,CompanyMediaKey INT NULL
		,MediaEstimateKey INT NULL
		,ShortDescription VARCHAR(max) NULL
		,LineNumber VARCHAR(200) NULL
		
		,InvoiceLineKey INT NULL
		,InvoiceDate SMALLDATETIME NULL
		,InvoiceNumber VARCHAR(35) NULL
		,ClientKey INT NULL
		)

	DECLARE @StartPOKind INT
	DECLARE @EndPOKind INT

	IF @ShowPurchaseOrders = 0
	BEGIN
		IF @ShowMedia = 0
			-- The user does not want anything
			SELECT @StartPOKind = 99
					,@EndPOKind = 99
		ELSE
			-- The user wants media only
			SELECT @StartPOKind = 1
					,@EndPOKind = 99
	END
	ELSE
	BEGIN
		IF @ShowMedia = 0
			-- The user wants PO only
			SELECT @StartPOKind = 0
					,@EndPOKind = 0
		ELSE
			-- The user wants media and PO
			SELECT @StartPOKind = 0
					,@EndPOKind = 99
	END

	IF @PurchaseOrderKey is not null
	begin
		-- when we have a PO key, no need of the other fields
		select @CompanyKey = CompanyKey
		from   tPurchaseOrder (nolock)
		where  PurchaseOrderKey = @PurchaseOrderKey

		select @AsOfDate = '01/01/2025', @StartPOKind = 0, @EndPOKind = 99
				,@ClientKey = null, @VendorKey = null, @GLCompanyKey = null, @OfficeKey = null

	end

	-- if both keys are null, no need to query the whole database
	IF @PurchaseOrderKey is null and @CompanyKey is null
	begin
		select * from  #tAccruedBalance  
		 
		return 1
	end

	
	INSERT #tAccruedBalance (PurchaseOrderDetailKey, TotalCost, AccruedCost, PrebillAmount
			,PODate, DetailOrderDate, POKind, POClosed, PurchaseOrderNumber, PurchaseOrderKey, ProjectKey, VendorKey, CompanyMediaKey, MediaEstimateKey
			,InvoiceLineKey, InvoiceDate, InvoiceNumber, ClientKey
	)
	SELECT toa.PurchaseOrderDetailKey, Round(pod.TotalCost,2), SUM(Round(toa.AccrualAmount, 4)), SUM(Round(toa.UnaccrualAmount, 4))
			,po.PODate, isnull(pod.DetailOrderDate,po.PODate), po.POKind, po.Closed, po.PurchaseOrderNumber, po.PurchaseOrderKey, po.ProjectKey, po.VendorKey, po.CompanyMediaKey, po.MediaEstimateKey
			,il.InvoiceLineKey, i.InvoiceDate, i.InvoiceNumber, i.ClientKey
	FROM   tTransactionOrderAccrual toa (NOLOCK)
		INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON toa.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
		INNER JOIN tInvoiceLine il (NOLOCK) ON pod.InvoiceLineKey = il.InvoiceLineKey
		INNER JOIN tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey
		LEFT OUTER JOIN tGLCompany glc (nolock) on po.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tOffice o (nolock) on pod.OfficeKey = o.OfficeKey
	WHERE toa.CompanyKey = @CompanyKey
	AND   toa.PostingDate <= @AsOfDate
	AND   (@ClientKey IS NULL OR i.ClientKey = @ClientKey)
	AND   (@VendorKey IS NULL OR po.VendorKey = @VendorKey)
	--AND   (@GLCompanyKey IS NULL or po.GLCompanyKey = @GLCompanyKey)
	
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND po.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(po.GLCompanyKey, 0) = @GLCompanyKey)
			)
	
	AND   (@OfficeKey IS NULL or pod.OfficeKey = @OfficeKey)
	AND   po.POKind >= @StartPOKind
	AND   po.POKind <= @EndPOKind
	AND   (@PurchaseOrderKey IS NULL or po.PurchaseOrderKey = @PurchaseOrderKey)
	
	-- for (229748)
	AND isnull(pod.TotalCost, 0) <> 0

	GROUP BY toa.PurchaseOrderDetailKey, Round(pod.TotalCost, 2), po.PODate, isnull(pod.DetailOrderDate,po.PODate)
			, po.POKind, po.Closed, po.PurchaseOrderNumber, po.PurchaseOrderKey, po.ProjectKey
			, po.VendorKey, po.CompanyMediaKey, po.MediaEstimateKey
			,il.InvoiceLineKey, i.InvoiceDate, i.InvoiceNumber, i.ClientKey
	HAVING (SUM(ROUND(toa.AccrualAmount, 4)) - SUM(ROUND(toa.UnaccrualAmount, 4))) <> 0
		
	-- here we do not have to check if AccruedBalance = 0 because it is part of the having statement
	UPDATE #tAccruedBalance
	SET    #tAccruedBalance.AccruedBalance = AccruedCost - PrebillAmount
	
	-- round again at 2 this time and delete if AccruedBalance = 0, see issue 171646
	UPDATE #tAccruedBalance
	SET    #tAccruedBalance.AccruedCost = ROUND(AccruedCost, 2)
	      ,#tAccruedBalance.PrebillAmount = ROUND(PrebillAmount, 2)
	      ,#tAccruedBalance.AccruedBalance = ROUND(AccruedCost, 2) - ROUND(PrebillAmount, 2)

	delete #tAccruedBalance where AccruedBalance = 0

	UPDATE #tAccruedBalance
	SET    #tAccruedBalance.LineNumber =
			CASE WHEN ISNULL(pod.AdjustmentNumber, 0) = 0 
				THEN CAST(pod.LineNumber AS VARCHAR(100)) 
				ELSE CAST(pod.LineNumber AS VARCHAR(100)) + '.' + CAST(pod.AdjustmentNumber AS VARCHAR(100))
			END
			,#tAccruedBalance.Closed = pod.Closed
			,#tAccruedBalance.ShortDescription = pod.ShortDescription
	FROM   tPurchaseOrderDetail pod (NOLOCK)
	WHERE  #tAccruedBalance.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey	
	
	-- if we have a po key, this is a drill down, no need of other fields
	IF @PurchaseOrderKey is not null
	begin
		select bal.*
		,cli.CustomerID
		,cli.CustomerID + ' - ' + cli.CompanyName as CompanyName
		 from  #tAccruedBalance bal 
		 INNER JOIN tCompany cli (NOLOCK) ON bal.ClientKey = cli.CompanyKey
		 order by bal.LineNumber 

		return 1
	end

	--This select statement is used to insert into the temp table
	-- #tAccruedBalanceDetail in APAccruedOrderDetail.vb
	-- #tAccruedBalanceDetail in APAccruedOrder.vb 
	--so the columns selected here must match the temp table created in VB.
	SELECT  bal.*
		,p.ProjectNumber
		,ISNULL(
		RTRIM(LTRIM(p.ProjectNumber)) + ' - ' + RTRIM(LTRIM(p.ProjectName))
		, '[No Project]') as ProjectName
		,ISNULL(RTRIM(LTRIM(me.EstimateID)) + ' - ' + RTRIM(LTRIM(me.EstimateName)), '[No Media Estimate]') as EstimateName
		,vend.VendorID
		,vend.VendorID + ' - ' + vend.CompanyName as VendorName
		,cli.CustomerID
		,cli.CustomerID + ' - ' + cli.CompanyName as CompanyName
		,ISNULL(cm.StationID, vend.VendorID) as StationID
		,ISNULL(cm.StationID, vend.VendorID) + ' - ' + ISNULL(cm.Name, vend.CompanyName) as StationName
		
		,ISNULL(bal.AccruedCost,0) AS NetAmount

		,bal.PrebillAmount AS NetAmountInvoiced
			
		,0 AS LastVoucher

		,ISNULL(RTRIM(LTRIM(c.CampaignID)) + ' - ' + RTRIM(LTRIM(c.CampaignName)), '[No Campaign]') as CampaignName
	FROM    #tAccruedBalance bal (nolock)
		INNER JOIN tCompany vend (nolock) ON bal.VendorKey = vend.CompanyKey
		LEFT JOIN tProject p (nolock) on bal.ProjectKey = p.ProjectKey
		LEFT JOIN tCampaign c (nolock) on p.CampaignKey = c.CampaignKey
		INNER JOIN tCompany cli (NOLOCK) ON bal.ClientKey = cli.CompanyKey
		LEFT OUTER JOIN tCompanyMedia cm (NOLOCK) ON bal.CompanyMediaKey = cm.CompanyMediaKey
		LEFt OUTER Join tMediaEstimate	me (NOLOCK) ON bal.MediaEstimateKey = me.MediaEstimateKey	
	
	ORDER BY p.ProjectNumber
	
		
	RETURN 1
GO
