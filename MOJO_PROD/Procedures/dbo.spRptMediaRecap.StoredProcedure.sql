USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptMediaRecap]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptMediaRecap]
	(
		@CompanyKey int,
		@ClientKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@UserKey int = null
	)

AS --Encrypt

	/*
	|| When			Who		Rel		What
	|| 02/28/08     GHL     8.5     (21864) Getting now clients depending on IOClientLink, BCClientLink
	|| 01/09/09     RTC     8.5     (41555) Changed to use the Flight End Date for broadcast orders
	|| 04/19/11     GHL     10.543  (109232) Since the where clause was using DetailOrderDate but 
	||                               the report was displaying DetailOrderEndDate, this was creating confusion
	||                               Decided to show both dates just like in Mass Billing 
    || 04/17/12     GHL     10.555  Added UserKey for UserGLCompanyAccess
	*/
	
	DECLARE @IOClientLink INT
			,@BCClientLink INT
	
	-- get client link settings, default to 'through project'
	select @IOClientLink = isnull(IOClientLink,1),
           @BCClientLink = isnull(BCClientLink,1)
      from tPreference (nolock)
     where CompanyKey = @CompanyKey
     
	Declare @RestrictToGLCompany int

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
		from tUser u (nolock)
		inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		Where u.UserKey = @UserKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

if ISNULL(@ClientKey, 0) = 0
	-- IO linked thru projects to client
	Select
		c.CompanyName as Client,
		ISNULL(cm.Name, v.CompanyName) as Station,
		MONTH(pod.DetailOrderDate) as OrderMonth,
		DateName(mm, pod.DetailOrderDate) as OrderMonthName,
		pod.DetailOrderDate,
		pod.DetailOrderEndDate,
		pod.ShortDescription,
		pod.TotalCost,
		pod.BillableCost,
		po.PurchaseOrderNumber,
		i.InvoiceNumber,
		mm.MarketName
	From
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		inner join tCompany v (nolock) on po.VendorKey = v.CompanyKey
		left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		left outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
	Where
		po.CompanyKey = @CompanyKey and
		pod.DetailOrderDate >= @StartDate and
		pod.DetailOrderDate <= @EndDate and 
		po.POKind = 1 and
		@IOClientLink = 1 -- Project
		AND (@RestrictToGLCompany = 0 
			OR po.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )


	UNION ALL
	
	-- IO linked thru media estimate to client
	Select
		c.CompanyName as Client,
		ISNULL(cm.Name, v.CompanyName) as Station,
		MONTH(pod.DetailOrderDate) as OrderMonth,
		DateName(mm, pod.DetailOrderDate) as OrderMonthName,
		pod.DetailOrderDate,
		pod.DetailOrderEndDate,
		pod.ShortDescription,
		pod.TotalCost,
		pod.BillableCost,
		po.PurchaseOrderNumber,
		i.InvoiceNumber,
		mm.MarketName
	From
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
		inner join tCompany v (nolock) on po.VendorKey = v.CompanyKey
		left outer join tCompany c (nolock) on e.ClientKey = c.CompanyKey
		left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		left outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
	Where
		po.CompanyKey = @CompanyKey and
		pod.DetailOrderDate >= @StartDate and
		pod.DetailOrderDate <= @EndDate and 
		po.POKind = 1 and
		@IOClientLink = 2 -- Media Estimate
		AND (@RestrictToGLCompany = 0 
			OR po.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )

	UNION ALL

	-- BC linked thru projects to client
	Select
		c.CompanyName as Client,
		ISNULL(cm.Name, v.CompanyName) as Station,
		MONTH(pod.DetailOrderEndDate) as OrderMonth,
		DateName(mm, pod.DetailOrderEndDate) as OrderMonthName,
		pod.DetailOrderDate,
		pod.DetailOrderEndDate,
		pod.ShortDescription,
		pod.TotalCost,
		pod.BillableCost,
		po.PurchaseOrderNumber,
		i.InvoiceNumber,
		mm.MarketName
	From
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		inner join tCompany v (nolock) on po.VendorKey = v.CompanyKey
		left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		left outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
	Where
		po.CompanyKey = @CompanyKey and
		pod.DetailOrderDate >= @StartDate and
		pod.DetailOrderDate <= @EndDate and 
		po.POKind = 2 and
		@BCClientLink = 1 -- Project
		AND (@RestrictToGLCompany = 0 
			OR po.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )

	UNION ALL
	
	-- BC linked thru media estimate to client
	Select
		c.CompanyName as Client,
		ISNULL(cm.Name, v.CompanyName) as Station,
		MONTH(pod.DetailOrderEndDate) as OrderMonth,
		DateName(mm, pod.DetailOrderEndDate) as OrderMonthName,
		pod.DetailOrderDate,
		pod.DetailOrderEndDate,
		pod.ShortDescription,
		pod.TotalCost,
		pod.BillableCost,
		po.PurchaseOrderNumber,
		i.InvoiceNumber,
		mm.MarketName
	From
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
		inner join tCompany v (nolock) on po.VendorKey = v.CompanyKey
		left outer join tCompany c (nolock) on e.ClientKey = c.CompanyKey
		left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		left outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
	Where
		po.CompanyKey = @CompanyKey and
		pod.DetailOrderDate >= @StartDate and
		pod.DetailOrderDate <= @EndDate and 
		po.POKind = 2 and
		@BCClientLink = 2 -- Media Estimate
		AND (@RestrictToGLCompany = 0 
			OR po.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
	
else
	-- IO linked thru project to client
	Select
		c.CompanyName as Client,
		ISNULL(cm.Name, v.CompanyName) as Station,
		MONTH(pod.DetailOrderDate) as OrderMonth,
		DateName(mm, pod.DetailOrderDate) as OrderMonthName,
		pod.DetailOrderDate,
		pod.DetailOrderEndDate,
		pod.ShortDescription,
		pod.TotalCost,
		pod.BillableCost,
		po.PurchaseOrderNumber,
		i.InvoiceNumber,
		mm.MarketName
	From
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		inner join tCompany v (nolock) on po.VendorKey = v.CompanyKey
		left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		left outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
	Where
		po.CompanyKey = @CompanyKey and
		pod.DetailOrderDate >= @StartDate and
		pod.DetailOrderDate <= @EndDate and
		p.ClientKey = @ClientKey and
		po.POKind = 1 and
		@IOClientLink = 1 -- link thru project
		AND (@RestrictToGLCompany = 0 
			OR po.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
		
	UNION ALL
	
	-- IO linked thru media estimate to client
	Select
		c.CompanyName as Client,
		ISNULL(cm.Name, v.CompanyName) as Station,
		MONTH(pod.DetailOrderDate) as OrderMonth,
		DateName(mm, pod.DetailOrderDate) as OrderMonthName,
		pod.DetailOrderDate,
		pod.DetailOrderEndDate,
		pod.ShortDescription,
		pod.TotalCost,
		pod.BillableCost,
		po.PurchaseOrderNumber,
		i.InvoiceNumber,
		mm.MarketName
	From
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
		inner join tCompany v (nolock) on po.VendorKey = v.CompanyKey
		left outer join tCompany c (nolock) on e.ClientKey = c.CompanyKey
		left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		left outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
	Where
		po.CompanyKey = @CompanyKey and
		pod.DetailOrderDate >= @StartDate and
		pod.DetailOrderDate <= @EndDate and
		e.ClientKey = @ClientKey and
		po.POKind = 1 and
		@IOClientLink = 2 -- link thru estimate
		AND (@RestrictToGLCompany = 0 
			OR po.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
		
	UNION ALL
		
	-- BC linked thru project to client
	Select
		c.CompanyName as Client,
		ISNULL(cm.Name, v.CompanyName) as Station,
		MONTH(pod.DetailOrderEndDate) as OrderMonth,
		DateName(mm, pod.DetailOrderEndDate) as OrderMonthName,
		pod.DetailOrderDate,
		pod.DetailOrderEndDate,
		pod.ShortDescription,
		pod.TotalCost,
		pod.BillableCost,
		po.PurchaseOrderNumber,
		i.InvoiceNumber,
		mm.MarketName
	From
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		inner join tCompany v (nolock) on po.VendorKey = v.CompanyKey
		left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		left outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
	Where
		po.CompanyKey = @CompanyKey and
		pod.DetailOrderDate >= @StartDate and
		pod.DetailOrderDate <= @EndDate and
		p.ClientKey = @ClientKey and
		po.POKind = 2 and
		@BCClientLink = 1 -- link thru project
		AND (@RestrictToGLCompany = 0 
			OR po.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
		
	UNION ALL
	
	-- BO linked thru media estimate to client
	Select
		c.CompanyName as Client,
		ISNULL(cm.Name, v.CompanyName) as Station,
		MONTH(pod.DetailOrderEndDate) as OrderMonth,
		DateName(mm, pod.DetailOrderEndDate) as OrderMonthName,
		pod.DetailOrderDate,
		pod.DetailOrderEndDate,
		pod.ShortDescription,
		pod.TotalCost,
		pod.BillableCost,
		po.PurchaseOrderNumber,
		i.InvoiceNumber,
		mm.MarketName
	From
		tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
		inner join tCompany v (nolock) on po.VendorKey = v.CompanyKey
		left outer join tCompany c (nolock) on e.ClientKey = c.CompanyKey
		left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		left outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
	Where
		po.CompanyKey = @CompanyKey and
		pod.DetailOrderDate >= @StartDate and
		pod.DetailOrderDate <= @EndDate and
		e.ClientKey = @ClientKey and
		po.POKind = 2 and
		@BCClientLink = 2 -- link thru estimate
		AND (@RestrictToGLCompany = 0 
			OR po.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
GO
