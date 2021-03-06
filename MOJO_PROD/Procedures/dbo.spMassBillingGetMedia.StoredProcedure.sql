USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spMassBillingGetMedia]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMassBillingGetMedia]
	@UserKey int,
	@IO tinyint,
	@IOBeginDate datetime,
	@IOEndDate datetime,
	@BC tinyint,
	@BCBeginDate datetime,
	@BCEndDate datetime,
	@Invoice tinyint,
	@InvoiceBeginDate datetime,
	@InvoiceEndDate datetime,
	@ClientKey int,
	@ClientDivisionKey int,
	@ClientProductKey int,
	@CampaignKey int,
	@MediaMarketKey int,
	@PurchaseOrderNumber varchar(30),
	@TaskID varchar(30),
	@GLCompanyKey int = -1,		-- -1: All, 0: None, or valid record 
	@OfficeKey int = -1,			-- -1: All, 0: None, or valid record
	@OpenOrdersOnlyOnInvoices int = 0,
	@ProjectKey int = null,
	@MediaEstimateKey int = null,
	@AccountManager int = null,
	@UseInvoicePostingDate tinyint = 0, -- 0 Invoice Date, 1 Posting Date, 2 Order Date
	-- added for new media screens
	@Interactive tinyint = 0,
	@InteractiveBeginDate datetime = null,
	@InteractiveEndDate datetime = null,
	@MediaWorksheetKey int = null,
	@CompanyMediaKey int = null,
	@OpenOrdersOnly int = 1,
	@ParentClientKey int = null

AS --Encrypt

/*
|| When     Who Rel     What
|| 07/16/07 RTC 8.4.3.2 (#9930) Use Flight Start Date instead of Flight End Date to determine what is included in the search results.
|| 10/18/07 GHL 8.438   (14701) Removed restrictions on vouchers with po closed
|| 12/20/07 GHL 8.5     (17723) Added restrictions on vouchers with po closed because another customer complained
||                       Using now a parameter to determine this
|| 01/24/08 GHL 8.502   (19677) Nerland. Changed Project on invoices from pod.ProjectKey to v.ProjectKey     
|| 07/03/08 GHL 8.515   (29754) Push. Having problems because a broadcast order has 2 spots, one qty = 1, one qty =-1
||                       causing invoice amount on the line = 0. In that case, delete records where group unbilled amount = 0   
|| 09/16/08 GHL 10.009  (33073) a-b-c. Allowing now 0 summary unbilled amount because cost must be applied to client 
|| 10/06/08 GHL 10.010  (35266) Timeout errors. Removed join with tTask. Added po.CompanyKey to where clause
||                      Added client key to where clause.
|| 03/10/11 GHL 10.452  (84790) Added filters by Project and Media Estimate
|| 06/23/11 GHL 10.545  (60333) Added extra fields so that the sp can be used for the media billing report
|| 09/01/11 GHL 10.547  (120201) Do not include vendor invoice lines which have been written off 
|| 12/27/11 GHL 10.551  (129332) Do not remove recs if UnbilledAmount = 0 
|| 04/10/12 GHL 10.555  Added logic for UserGLCompanyAccess
|| 10/30/12 KMC 10.561  (152562) Added the TaskID logic back in and added the grouping option by TaskID in the client
|| 10/31/12 KMC 10.561  (152563) Added the Hide Details option, which included adding columns to the #tMediaMassBilling
||                      table to be shown in the summary report
|| 11/2/12  KMC 10.561  (152562 & 152563) Updated SP after review with Chris and Gil.  Moved the JOIN to tTask out of the
||                      primary INSERT/SELECT and updated the temp table afterwards.  Also appended the TaskName to the 
||                      TaskID.
|| 01/04/13 WDF 10.563  (159100) Added AccountManager
|| 01/07/13 GHL 10.563  (159100) Added Nolock hint
|| 05/01/13 GHL 10.567  (176580) Added Adjustment #, Invoice Number, Invoice Line Number to help with media report
|| 08/26/13 RLB 10.571  (185716) add filter for account manager for report
|| 10/04/13 GHL 10.573  Added support for multi currency
|| 10/24/13 MFT 10.573  Added @UseInvoicePostingDate and CASE logic
|| 03/17/14 RLB 10.587  (198748) Added logic on case for Related Order Date
|| 04/23/14 GHL 10.579  Added support for media worksheets
|| 05/14/14 GHL 10.579  Fixed query used for invoices and IO
|| 06/05/14 GHL 10.581  Added Media Worksheet Name
|| 09/04/14 GHL 10.584  (228260) Added param @OpenOrdersOnly for new media screen
||                      Must be able to bill closed orders
|| 09/17/14 GHL 10.584 (217847) Added param @ParentClientKey for enhancement
|| 10/31/14 GHL 10.585  Added SalesTaxAmount to support Pass Through Taxes PTT (from Publication to client invoice)
||                      Requested by SM to identity publications with PTT and bill one line per publication
|| 02/12/15 PLC 10.589  Added logic to limit the zero billable invoices because mk good are added to the purchaseorder
*/

/*
	create table #tMediaMassBilling (
        ClientKey           int,
        CustomerID          varchar(50),
		ProjectKey			int null,
		ProjectName			varchar(200) null,
		MediaEstimateKey	int NULL,
		EstimateName		varchar(200) null,
		UnbilledAmount      MONEY NULL,
		SalesTaxAmount      MONEY NULL,
		DetailOrderDate		datetime null,
        DetailOrderEndDate	datetime null,
        OrderProgram		varchar(30) null,
        Quantity			decimal(24,4) null,
        TotalCost			money null,
		AccountManager      varchar(255) null)
	

	create table #tMediaMassBillingDetail (
		GLCompanyKey		int null,
		OfficeKey			int null,
	    ClientKey           int null,
        CustomerID          varchar(50) null,
        Entity              varchar(10) null,
		EntityKey           int null,
        EntityDate          datetime null,
        EntityNumber        varchar(50) null,
		ProjectKey			int null,
		ProjectName			varchar(200) null,
		MediaEstimateKey	int null,
		EstimateName		varchar(200) null,
		ClientDivisionKey   int  null,
		ClientProductKey    int null,
		CampaignKey         int null,
        MediaMarketKey      int null,
        PurchaseOrderNumber varchar(30) null,
        TaskID              varchar(60) null,
        DetailOrderDate     datetime null,
        DetailOrderEndDate  datetime null,
		MediaID             varchar(50) null,
		OrderProgram        varchar(30) null,
		OrderTime           varchar(50) null,
		Quantity            decimal(24,4) null,
		UnitCost            money null,
		TotalCost           money null,
		UnbilledAmount      money null,
		SalesTaxAmount      money null,

		-- added so that the stored proc can be used in new report Media Billing
		LineNumber          int null,
		CompanyMediaKey		int null,
		VendorKey			int null,
		StationName			varchar(255) null,
		TransactionMonth	VARCHAR(20) NULL,
		TransactionMonthNumeric INT NULL,
		TransactionType     varchar(50) null,
		CompanyName         varchar(255) null, -- will hold the Client Name
		AccountManager      varchar(255) null,

		-- Added to help out with media 
		AdjustmentNumber    int null,
		LineAdjustment      varchar(50) null, -- will hold PO LineNumber + PO AdjustmentNumber
		InvoiceLineNumber   int null,
		InvoiceNumber       varchar(50) null,
		InvoiceDetails      varchar(100) null, -- will hold InvoiceNumber + InvoiceLineNumber

		-- Added for new media screens
		MediaWorksheetKey int null,
		WorksheetID varchar(50) null,
		WorksheetName varchar(1000) null
		)
*/

declare @CompanyKey int
declare @IOClientLink tinyint
declare @BCClientLink tinyint
		
	truncate table #tMediaMassBilling
	truncate table #tMediaMassBillingDetail
	
	if @IOEndDate is null
		select @IOEndDate = '01/01/2050'
	if @BCEndDate is null
		select @BCEndDate = '01/01/2050'
	if @InteractiveEndDate is null
		select @InteractiveEndDate = '01/01/2050'
	if @InvoiceEndDate is null
		select @InvoiceEndDate = '01/01/2050'
		
	-- get company key
	select @CompanyKey = isnull(OwnerCompanyKey,CompanyKey)
	  from tUser (nolock)
	 where UserKey = @UserKey   
 
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


	-- get all IOs for this company
	if @IO = 1 
	BEGIN
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
				   CustomerID,
				   CompanyName, -- client
		           TransactionType,
				   Entity,
		           EntityKey,
				   EntityDate,
				   EntityNumber,
				   ProjectKey,
		           ProjectName,
		           MediaEstimateKey,
		           EstimateName,
				   ClientDivisionKey,
				   ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
	               DetailOrderDate,
	               DetailOrderEndDate,
	               MediaID,
	               OrderProgram,
	               OrderTime,
				   Quantity,
	               UnitCost,
	               TotalCost,
                   UnbilledAmount,
                   LineNumber,
				   AdjustmentNumber,
				   CompanyMediaKey,
		           VendorKey,
		           StationName,
                   TransactionMonth,
	               TransactionMonthNumeric,
	               AccountManager,
				   MediaWorksheetKey
			   )
		    select case when @IOClientLink = 1 then ISNULL(p.GLCompanyKey, 0) else ISNULL(e.GLCompanyKey, 0) end,
				   case when @IOClientLink = 1 then ISNULL(p.OfficeKey, 0) else ISNULL(e.OfficeKey, 0) end,	
				   case when @IOClientLink = 1 then p.ClientKey else e.ClientKey end,
		           case when @IOClientLink = 1 then c.CustomerID else clm.CustomerID end,
		           case when @IOClientLink = 1 then c.CompanyName else clm.CompanyName end,
		           'Insertion Order',
				   'IO',
				   pod.PurchaseOrderDetailKey,
				   pod.DetailOrderDate,
		           po.PurchaseOrderNumber,
		           p.ProjectKey,
				   isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),''),
		           e.MediaEstimateKey,
				   isnull(e.EstimateID+' - ','') + isnull(left(e.EstimateName, 25),''),
				   p.ClientDivisionKey,
				   p.ClientProductKey,
	               case when @IOClientLink = 1 then p.CampaignKey else e.CampaignKey end,
	               m.MediaMarketKey,
				   po.PurchaseOrderNumber,
	               '',
	               pod.DetailOrderDate,
	               pod.DetailOrderEndDate,
	               m.StationID,
	               left(pod.ShortDescription,30),
	               pod.OrderTime,
	               pod.Quantity,
	               pod.UnitCost,
	               isnull(pod.PTotalCost,isnull(pod.TotalCost,0)),
		           isnull(case isnull(po.BillAt, 0) 
			           when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,isnull(TotalCost,0))
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0),
				   pod.LineNumber,
				   pod.AdjustmentNumber,
				   m.CompanyMediaKey,
		           po.VendorKey,
		           m.StationID + ' - ' + m.Name,
                   datename(mm, pod.DetailOrderDate),
	               datepart(mm, pod.DetailOrderDate),
	               u.FirstName + ' ' + u.LastName,
				   po.MediaWorksheetKey
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           left outer join tUser u (nolock) on p.AccountManager = u.UserKey
		           left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
				   left outer join tCompany clm (nolock) on e.ClientKey = clm.CompanyKey
		     where po.CompanyKey = @CompanyKey
		       and pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0  -- vendor has not invoiced
		       and po.Status = 4 -- PO approved
		       and po.POKind = 1
	           and (
					(@IOClientLink = 1 and (@ClientKey is null or p.ClientKey = @ClientKey))
					or
					(@IOClientLink <> 1 and (@ClientKey is null or e.ClientKey = @ClientKey))
					)
				 and (
					(@IOClientLink = 1 and (@ParentClientKey is null or p.ClientKey = @ParentClientKey 
						or c.ParentCompanyKey =  @ParentClientKey ))
					or
					(@IOClientLink <> 1 and (@ParentClientKey is null or e.ClientKey = @ParentClientKey
						or clm.ParentCompanyKey =  @ParentClientKey ))
					)
			   and (@AccountManager is null or p.AccountManager = @AccountManager)
			   and (
					(@IOClientLink = 1  and p.Closed = 0 and p.NonBillable = 0)
					or
					@IOClientLink <> 1
					)
	           and isnull(pod.OnHold,0) = 0
	           and (@OpenOrdersOnly = 0 or isnull(pod.Closed,0) = 0)
			   and (@MediaWorksheetKey is null or po.MediaWorksheetKey = @MediaWorksheetKey)
 	           AND NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
							AND   bd.Entity = 'tPurchaseOrderDetail')

	END

	-- get all BCs for this company
    if @BC = 1
    BEGIN
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
				   CustomerID,
		           CompanyName, -- client
		           TransactionType,
				   Entity,
		           EntityKey,
				   EntityDate,
				   EntityNumber,
				   ProjectKey,
		           ProjectName,
		           MediaEstimateKey,
		           EstimateName,
				   ClientDivisionKey,
				   ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
	               DetailOrderDate,
	               DetailOrderEndDate,
	               MediaID,
	               OrderProgram,
	               OrderTime,
	               Quantity,
	               UnitCost,
	               TotalCost,
		           UnbilledAmount,
                   LineNumber,
				   AdjustmentNumber,
				   CompanyMediaKey,
		           VendorKey,
		           StationName,
                   TransactionMonth,
	               TransactionMonthNumeric,
	               AccountManager,
				   MediaWorksheetKey
				   )
		    select case when @BCClientLink = 1 then ISNULL(p.GLCompanyKey, 0) else ISNULL(e.GLCompanyKey, 0) end,
				   case when @BCClientLink = 1 then ISNULL(p.OfficeKey, 0) else ISNULL(e.OfficeKey, 0) end,	
				   case when @BCClientLink = 1 then p.ClientKey else e.ClientKey end,
		           case when @BCClientLink = 1 then c.CustomerID else clm.CustomerID end,
		           case when @BCClientLink = 1 then c.CompanyName else clm.CompanyName end,
				   'Broadcast Order',
		           'BC',
		           pod.PurchaseOrderDetailKey,
	               pod.DetailOrderDate,
		           po.PurchaseOrderNumber,
		           p.ProjectKey,
				   isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),''),
		           e.MediaEstimateKey,
				   isnull(e.EstimateID+' - ','') + isnull(left(e.EstimateName, 25),''),
				   p.ClientDivisionKey,
				   p.ClientProductKey,
	               case when @BCClientLink = 1 then p.CampaignKey else e.CampaignKey end,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               '',
	               pod.DetailOrderDate,
	               pod.DetailOrderEndDate,
	               m.StationID,
	               left(pod.ShortDescription,30),
	               pod.OrderTime,
	               pod.Quantity,
	               pod.UnitCost,
	               isnull(pod.PTotalCost,isnull(pod.TotalCost,0)),
		           isnull(case isnull(po.BillAt, 0) 
			           when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,isnull(TotalCost,0))
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0),
		           pod.LineNumber,
				   pod.AdjustmentNumber,
				   m.CompanyMediaKey,
		           po.VendorKey,
		           m.StationID + ' - ' + m.Name,
                   datename(mm, pod.DetailOrderDate),
	               datepart(mm, pod.DetailOrderDate),
	               u.FirstName + ' ' + u.LastName,
				   po.MediaWorksheetKey
			  from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           left outer join tUser u (nolock) on p.AccountManager = u.UserKey
				   left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
				   left outer join tCompany clm (nolock) on e.ClientKey = clm.CompanyKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
		     where po.CompanyKey = @CompanyKey 
			   and pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0 -- vendor has not invoiced
		       and po.Status = 4 -- PO approved
		       and po.POKind = 2
			   and (
					(@BCClientLink = 1 and (@ClientKey is null or p.ClientKey = @ClientKey))
					or
					(@BCClientLink <> 1 and (@ClientKey is null or e.ClientKey = @ClientKey))
					)
			   and (
					(@BCClientLink = 1 and (@ParentClientKey is null or p.ClientKey = @ParentClientKey 
						or c.ParentCompanyKey =  @ParentClientKey ))
					or
					(@BCClientLink <> 1 and (@ParentClientKey is null or e.ClientKey = @ParentClientKey
						or clm.ParentCompanyKey =  @ParentClientKey ))
					)
			   and (@AccountManager is null or p.AccountManager = @AccountManager)
			   and (
					(@BCClientLink = 1  and p.Closed = 0 and p.NonBillable = 0)
					or
					@BCClientLink <> 1
					)
	           and isnull(pod.OnHold,0) = 0
	           and (@OpenOrdersOnly = 0 or isnull(pod.Closed,0) = 0)
			   and (@MediaWorksheetKey is null or po.MediaWorksheetKey = @MediaWorksheetKey)
	           AND NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
							AND   bd.Entity = 'tPurchaseOrderDetail')
	
	END

	create table #pokind (POKind int null)
	if @Interactive = 1 
		insert #pokind (POKind) values (4)

	-- get all Interactive orders for this company (or other orders, just add to POKind)
	if @Interactive = 1 
	BEGIN
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
				   CustomerID,
				   CompanyName, -- client
		           TransactionType,
				   Entity,
		           EntityKey,
				   EntityDate,
				   EntityNumber,
				   ProjectKey,
		           ProjectName,
		           MediaEstimateKey,
		           EstimateName,
				   ClientDivisionKey,
				   ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
				   TaskID,
	               DetailOrderDate,
	               DetailOrderEndDate,
	               MediaID,
	               OrderProgram,
	               OrderTime,
				   Quantity,
	               UnitCost,
	               TotalCost,
                   UnbilledAmount,
                   LineNumber,
				   AdjustmentNumber,
				   CompanyMediaKey,
		           VendorKey,
		           StationName,
                   TransactionMonth,
	               TransactionMonthNumeric,
	               AccountManager,
				   MediaWorksheetKey
			   )
		    select ISNULL(p.GLCompanyKey, 0),
				   ISNULL(p.OfficeKey, 0),	
				   p.ClientKey,
		           c.CustomerID,
		           c.CompanyName,
				   case po.POKind 
						when 4 then 'Interactive Order'
						when 5 then 'OOH'
						else 'Radio Order'
				   end,
				   case po.POKind 
						when 4 then 'Interactive' 
						when 5 then 'OOH'
						else 'Radio'
				   end,
				   pod.PurchaseOrderDetailKey,
				   pod.DetailOrderDate,
		           po.PurchaseOrderNumber,
		           p.ProjectKey,
				   isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),''),
		           e.MediaEstimateKey,
				   isnull(e.EstimateID+' - ','') + isnull(left(e.EstimateName, 25),''),
				   p.ClientDivisionKey,
				   p.ClientProductKey,
	               p.CampaignKey,
	               m.MediaMarketKey,
				   po.PurchaseOrderNumber,
	               '',
	               pod.DetailOrderDate,
	               pod.DetailOrderEndDate,
	               m.StationID,
	               left(pod.ShortDescription,30),
	               pod.OrderTime,
	               pod.Quantity,
	               pod.UnitCost,
	               isnull(pod.PTotalCost,isnull(pod.TotalCost,0)),
		           isnull(case isnull(po.BillAt, 0) 
			           when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,isnull(TotalCost,0))
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0),
				   pod.LineNumber,
				   pod.AdjustmentNumber,
				   m.CompanyMediaKey,
		           po.VendorKey,
		           m.StationID + ' - ' + m.Name,
                   datename(mm, pod.DetailOrderDate),
	               datepart(mm, pod.DetailOrderDate),
	               u.FirstName + ' ' + u.LastName,
				   po.MediaWorksheetKey
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           left outer join tUser u (nolock) on p.AccountManager = u.UserKey
		           left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
		     where po.CompanyKey = @CompanyKey
		       and pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0  -- vendor has not invoiced
		       and po.Status = 4 -- PO approved
		       and po.POKind in (select POKind from #pokind) -- Interactive + we can add to it here
	           and (@ClientKey is null or p.ClientKey = @ClientKey)
			   and (@ParentClientKey is null or p.ClientKey = @ParentClientKey or c.ParentCompanyKey = @ParentClientKey)
			   and (@AccountManager is null or p.AccountManager = @AccountManager)
			   and p.Closed = 0
			   and p.NonBillable = 0
	           and isnull(pod.OnHold,0) = 0
	           and (@OpenOrdersOnly = 0 or isnull(pod.Closed,0) = 0)
			   and (@MediaWorksheetKey is null or po.MediaWorksheetKey = @MediaWorksheetKey)
 	           AND NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
							AND   bd.Entity = 'tPurchaseOrderDetail')

	END
	
	-- get all IOs with vendor invoices for this company
    if @Invoice = 1
    BEGIN
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
				   CustomerID,
		           CompanyName, -- client
		           TransactionType,
				   Entity,
		           EntityKey,
				   EntityDate,
				   EntityNumber,
				   ProjectKey,
		           ProjectName,
		           MediaEstimateKey,
		           EstimateName,
				   ClientDivisionKey,
				   ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
	               DetailOrderDate,
	               DetailOrderEndDate,
	               MediaID,
	               OrderProgram,
	               OrderTime,
	               Quantity,
	               UnitCost,
	               TotalCost,
		           UnbilledAmount,
                   LineNumber,
				   AdjustmentNumber,
				   InvoiceLineNumber,
				   InvoiceNumber,
				   CompanyMediaKey,
		           VendorKey,
		           StationName,
                   TransactionMonth,
	               TransactionMonthNumeric,
	               AccountManager,
				   MediaWorksheetKey
				   )
		    select case when @IOClientLink = 1 then ISNULL(p.GLCompanyKey, 0) else ISNULL(e.GLCompanyKey, 0) end,
				   case when @IOClientLink = 1 then ISNULL(p.OfficeKey, 0) else ISNULL(e.OfficeKey, 0) end,	
                   case when @IOClientLink = 1 then p.ClientKey else e.ClientKey end,
		           case when @IOClientLink = 1 then c.CustomerID else clm.CustomerID end,
		           case when @IOClientLink = 1 then c.CompanyName else clm.CompanyName end,
		           'Insertion Order',
		           'Invoice',
				   vd.VoucherDetailKey,
	               CASE @UseInvoicePostingDate WHEN 1 THEN v.PostingDate WHEN 2 THEN pod.DetailOrderDate ELSE v.InvoiceDate END,
		           v.InvoiceNumber,
		           p.ProjectKey,
				   isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),''),
		           e.MediaEstimateKey,
				   isnull(e.EstimateID+' - ','') + isnull(left(e.EstimateName, 25),''),
				   p.ClientDivisionKey,
				   p.ClientProductKey,
	               case when @IOClientLink = 1 then p.CampaignKey else e.CampaignKey end,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               '',
	               pod.DetailOrderDate,
	               pod.DetailOrderEndDate,
	               m.StationID,
	               left(pod.ShortDescription,30),
	               pod.OrderTime,
	               vd.Quantity,
	               vd.UnitCost,
	               isnull(vd.PTotalCost,isnull(vd.TotalCost,0)),
		           isnull(vd.BillableCost,0),
				   pod.LineNumber,
				   pod.AdjustmentNumber,
				   vd.LineNumber,
				   v.InvoiceNumber,
				   m.CompanyMediaKey,
		           po.VendorKey,
		           m.StationID + ' - ' + m.Name,
                   datename(mm, v.InvoiceDate),
	               datepart(mm, v.InvoiceDate),
	               u.FirstName + ' ' + u.LastName,
				   po.MediaWorksheetKey
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		           inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		           --inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
				   left outer join tUser u (nolock) on p.AccountManager = u.UserKey
		           left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
				   left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
		           left outer join tCompany clm (nolock) on e.ClientKey = clm.CompanyKey
				   left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
		           --left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
		           --left outer join tTask t (nolock) on vd.TaskKey = t.TaskKey
		     where po.CompanyKey = @CompanyKey
		           and vd.InvoiceLineKey is null and isnull(vd.BillableCost,0) <> 0 -- customer not yet billed PC 2/12/15 added Billable cost to remove zeros from data set
				   and vd.WriteOff = 0
		           and v.Status = 4 -- Voucher approved
		           and po.POKind = 1
			       --and p.CompanyKey = @CompanyKey -- limit to the user's company
	               and (
					(@IOClientLink = 1 and (@ClientKey is null or p.ClientKey = @ClientKey))
					or
					(@IOClientLink <> 1 and (@ClientKey is null or e.ClientKey = @ClientKey))
					)
					and (
					(@IOClientLink = 1 and (@ParentClientKey is null or p.ClientKey = @ParentClientKey 
						or c.ParentCompanyKey =  @ParentClientKey ))
					or
					(@IOClientLink <> 1 and (@ParentClientKey is null or e.ClientKey = @ParentClientKey
						or clm.ParentCompanyKey =  @ParentClientKey ))
					)
				   and (@AccountManager is null or p.AccountManager = @AccountManager)
				   and (
					(@IOClientLink = 1  and p.Closed = 0 and p.NonBillable = 0)
					or
					@IOClientLink <> 1
					)
				   and isnull(vd.OnHold,0) = 0
                   and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0)) 
				   and (@MediaWorksheetKey is null or po.MediaWorksheetKey = @MediaWorksheetKey)
				   AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)

	END

	-- get all BCs with vendor invoices for this company
    if @Invoice = 1
    BEGIN


		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
				   CustomerID,
		           CompanyName, -- client
		           TransactionType,
				   Entity,
		           EntityKey,
				   EntityDate,
				   EntityNumber,
				   ProjectKey,
		           ProjectName,
		           MediaEstimateKey,
		           EstimateName,
				   ClientDivisionKey,
				   ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
	               DetailOrderDate,
				   DetailOrderEndDate,
	               MediaID,
	               OrderProgram,
	               OrderTime,
	               Quantity,
                   UnitCost,
                   TotalCost,
		           UnbilledAmount,
                   LineNumber,
				   AdjustmentNumber,
				   InvoiceLineNumber,
				   InvoiceNumber,
				   CompanyMediaKey,
		           VendorKey,
		           StationName,
                   TransactionMonth,
	               TransactionMonthNumeric,
	               AccountManager,
				   MediaWorksheetKey
				   )
		    select case when @BCClientLink = 1 then ISNULL(p.GLCompanyKey, 0) else ISNULL(e.GLCompanyKey, 0) end,
				   case when @BCClientLink = 1 then ISNULL(p.OfficeKey, 0) else ISNULL(e.OfficeKey, 0) end,
				   case when @BCClientLink = 1 then p.ClientKey else e.ClientKey end,
		           case when @BCClientLink = 1 then c.CustomerID else clm.CustomerID end,
		           case when @BCClientLink = 1 then c.CompanyName else clm.CompanyName end,
				   'Broadcast Order',
		           'Invoice',
		           vd.VoucherDetailKey,
	               CASE @UseInvoicePostingDate WHEN 1 THEN v.PostingDate WHEN 2 THEN pod.DetailOrderDate ELSE v.InvoiceDate END,
		           v.InvoiceNumber,
		           p.ProjectKey,
				   isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),''),
		           e.MediaEstimateKey,
				   isnull(e.EstimateID+' - ','') + isnull(left(e.EstimateName, 25),''),
				   p.ClientDivisionKey,
				   p.ClientProductKey,
	               case when @BCClientLink = 1 then p.CampaignKey else e.CampaignKey end,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               '',
	               pod.DetailOrderDate,
	               pod.DetailOrderEndDate,
	               m.StationID,
	               left(pod.ShortDescription,30),
	               pod.OrderTime,
	               vd.Quantity,
	               vd.UnitCost,
	               isnull(vd.PTotalCost,isnull(vd.TotalCost,0)),
				   isnull(vd.BillableCost,0),
				   pod.LineNumber,
				   pod.AdjustmentNumber,
				   vd.LineNumber,
				   v.InvoiceNumber,
				   m.CompanyMediaKey,
		           po.VendorKey,
		           m.StationID + ' - ' + m.Name,
                   datename(mm, v.InvoiceDate),
	               datepart(mm, v.InvoiceDate),
	               u.FirstName + ' ' + u.LastName,
				   po.MediaWorksheetKey
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		           inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		           --inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
		   		   left outer join tUser u (nolock) on p.AccountManager = u.UserKey
		           left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
	               left outer join tCompany clm (nolock) on e.ClientKey = clm.CompanyKey
		           
		     where po.CompanyKey = @CompanyKey
			   and vd.InvoiceLineKey is null and isnull(vd.BillableCost,0) <> 0  -- customer not yet billed
		       and vd.WriteOff = 0
		       and v.Status = 4 -- PO approved
		       and po.POKind = 2
	           and (
					(@BCClientLink = 1 and (@ClientKey is null or p.ClientKey = @ClientKey))
					or
					(@BCClientLink <> 1 and (@ClientKey is null or e.ClientKey = @ClientKey))
					)
				and (
					(@BCClientLink = 1 and (@ParentClientKey is null or p.ClientKey = @ParentClientKey 
						or c.ParentCompanyKey =  @ParentClientKey ))
					or
					(@BCClientLink <> 1 and (@ParentClientKey is null or e.ClientKey = @ParentClientKey
						or clm.ParentCompanyKey =  @ParentClientKey ))
					)
			   and (@AccountManager is null or p.AccountManager = @AccountManager)
			   and (
					(@BCClientLink = 1  and p.Closed = 0 and p.NonBillable = 0)
					or
					@BCClientLink <> 1
					)
	           and isnull(vd.OnHold,0) = 0
	           and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0))
			   and (@MediaWorksheetKey is null or po.MediaWorksheetKey = @MediaWorksheetKey) 
			   AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)
		
	END

	-- get all other orders with vendor invoices for this company
    if @Invoice = 1
    BEGIN
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
				   CustomerID,
		           CompanyName, -- client
		           TransactionType,
				   Entity,
		           EntityKey,
				   EntityDate,
				   EntityNumber,
				   ProjectKey,
		           ProjectName,
		           MediaEstimateKey,
		           EstimateName,
				   ClientDivisionKey,
				   ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
	               DetailOrderDate,
				   DetailOrderEndDate,
	               MediaID,
	               OrderProgram,
	               OrderTime,
	               Quantity,
                   UnitCost,
                   TotalCost,
		           UnbilledAmount,
                   LineNumber,
				   AdjustmentNumber,
				   InvoiceLineNumber,
				   InvoiceNumber,
				   CompanyMediaKey,
		           VendorKey,
		           StationName,
                   TransactionMonth,
	               TransactionMonthNumeric,
	               AccountManager,
				   MediaWorksheetKey
				   )
		    select ISNULL(p.GLCompanyKey, 0),
				   ISNULL(p.OfficeKey, 0),
				   p.ClientKey,
		           c.CustomerID,
		           c.CompanyName,
				   case po.POKind 
						when 4 then 'Interactive Order'
						when 5 then 'Outdoor Order'
						else 'Radio Order'
				   end,
				   'Invoice',
		           vd.VoucherDetailKey,
	               CASE @UseInvoicePostingDate WHEN 1 THEN v.PostingDate WHEN 2 THEN pod.DetailOrderDate ELSE v.InvoiceDate END,
		           v.InvoiceNumber,
		           p.ProjectKey,
				   isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),''),
		           e.MediaEstimateKey,
				   isnull(e.EstimateID+' - ','') + isnull(left(e.EstimateName, 25),''),
				   p.ClientDivisionKey,
				   p.ClientProductKey,
	               case when @BCClientLink = 1 then p.CampaignKey else e.CampaignKey end,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               '',
	               pod.DetailOrderDate,
	               pod.DetailOrderEndDate,
	               m.StationID,
	               left(pod.ShortDescription,30),
	               pod.OrderTime,
	               vd.Quantity,
	               vd.UnitCost,
	               isnull(vd.PTotalCost,isnull(vd.TotalCost,0)),
				   isnull(vd.BillableCost,0),
				   pod.LineNumber,
				   pod.AdjustmentNumber,
				   vd.LineNumber,
				   v.InvoiceNumber,
				   m.CompanyMediaKey,
		           po.VendorKey,
		           m.StationID + ' - ' + m.Name,
                   datename(mm, v.InvoiceDate),
	               datepart(mm, v.InvoiceDate),
	               u.FirstName + ' ' + u.LastName,
				   po.MediaWorksheetKey
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		           inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		           --inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
		   		   left outer join tUser u (nolock) on p.AccountManager = u.UserKey
		           left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
		           
		     where po.CompanyKey = @CompanyKey
			   and vd.InvoiceLineKey is null  and isnull(vd.BillableCost,0) <> 0 -- customer not yet billed
		       and vd.WriteOff = 0
		       and v.Status = 4 -- PO approved
		       and po.POKind in (4,5,6) -- Interactive, Outdoor, Radio
			   and (@ClientKey is null or p.ClientKey = @ClientKey)
			   and (@ParentClientKey is null or p.ClientKey = @ParentClientKey or c.ParentCompanyKey = @ParentClientKey)
	           and (@AccountManager is null or p.AccountManager = @AccountManager)
			   --and p.Closed = 0
			   --and p.NonBillable = 0
			    and (
					(@IOClientLink = 1  and p.Closed = 0 and p.NonBillable = 0)
					or
					@IOClientLink <> 1
					)
			   and isnull(vd.OnHold,0) = 0
	            and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0))
			   and (@MediaWorksheetKey is null or po.MediaWorksheetKey = @MediaWorksheetKey) 
			   AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)
		
	END


	update #tMediaMassBillingDetail
	set    #tMediaMassBillingDetail.TaskID = isnull(t.TaskID + ' - ', '') + isnull(left(t.TaskName, 30), '')
	from   tVoucherDetail vd (nolock)
	inner join tTask t (nolock) on vd.TaskKey = t.TaskKey and vd.ProjectKey = t.ProjectKey 
	where  #tMediaMassBillingDetail.EntityKey = vd.VoucherDetailKey
	and    #tMediaMassBillingDetail.Entity = 'Invoice'

	update #tMediaMassBillingDetail
	set    #tMediaMassBillingDetail.TaskID = isnull(t.TaskID + ' - ', '') + isnull(left(t.TaskName, 30), '')
	from   tPurchaseOrderDetail pod (nolock)
	inner join tTask t (nolock) on pod.TaskKey = t.TaskKey and pod.ProjectKey = t.ProjectKey
	where  #tMediaMassBillingDetail.EntityKey = pod.PurchaseOrderDetailKey
	and    #tMediaMassBillingDetail.Entity <> 'Invoice'

	-- correct StationName if missing, and set it to vendor info, similar to Media Discrepancy report
	update #tMediaMassBillingDetail
	set    #tMediaMassBillingDetail.StationName = v.VendorID + ' - ' + v.CompanyName 
	from   tCompany v (nolock)
	where  #tMediaMassBillingDetail.VendorKey = v.CompanyKey
	and    #tMediaMassBillingDetail.StationName is null
	
	update #tMediaMassBillingDetail
	set    #tMediaMassBillingDetail.MediaID = v.VendorID  
	from   tCompany v (nolock)
	where  #tMediaMassBillingDetail.VendorKey = v.CompanyKey
	and    #tMediaMassBillingDetail.MediaID is null
	 
	update #tMediaMassBillingDetail
	set    #tMediaMassBillingDetail.WorksheetID = w.WorksheetID  
	      ,#tMediaMassBillingDetail.WorksheetName = w.WorksheetName
	from   tMediaWorksheet w (nolock)
	where  #tMediaMassBillingDetail.MediaWorksheetKey = w.MediaWorksheetKey
	
	-- format the LineAdjustment
	-- Example: 1 or 1.1 or 2.4 
   update #tMediaMassBillingDetail
	set    LineAdjustment = case when isnull(AdjustmentNumber, 0) = 0 then cast(LineNumber as varchar(50))
	                             else cast(LineNumber as varchar(50)) + '.' + cast(AdjustmentNumber as varchar(50))
								 end

   -- format the InvoiceDetails 
   -- Example: Invoice 12345 Line 3 
   update #tMediaMassBillingDetail 
   set     InvoiceDetails = 'Invoice ' + InvoiceNumber + ' Line ' + cast(InvoiceLineNumber as varchar(100))
   where   Entity = 'Invoice'

	-- delete rows not matching criteria
	if @IOBeginDate is not null
		delete #tMediaMassBillingDetail
         where Entity = 'IO'
           and EntityDate < @IOBeginDate

	if @IOEndDate is not null
		delete #tMediaMassBillingDetail
		 where Entity = 'IO'
           and EntityDate > @IOEndDate

	if @BCBeginDate is not null
		delete #tMediaMassBillingDetail
         where Entity = 'BC'
           and EntityDate < @BCBeginDate

	if @BCEndDate is not null
		delete #tMediaMassBillingDetail
         where Entity = 'BC'
           and EntityDate > @BCEndDate

	if @InteractiveBeginDate is not null
		delete #tMediaMassBillingDetail
         where Entity = 'Interactive'
           and EntityDate < @InteractiveBeginDate

	if @InteractiveEndDate is not null
		delete #tMediaMassBillingDetail
         where Entity = 'Interactive'
           and EntityDate > @InteractiveEndDate

	if @InvoiceBeginDate is not null
		delete #tMediaMassBillingDetail
         where Entity = 'Invoice'
           and EntityDate < @InvoiceBeginDate

	if @InvoiceEndDate is not null
		delete #tMediaMassBillingDetail
         where Entity = 'Invoice'
           and EntityDate > @InvoiceEndDate

	if @ClientKey is not null
		delete #tMediaMassBillingDetail
         where isnull(ClientKey,0) <> @ClientKey

	if @ClientDivisionKey is not null
		delete #tMediaMassBillingDetail
         where isnull(ClientDivisionKey,0) <> @ClientDivisionKey
         
	if @ClientProductKey is not null
		delete #tMediaMassBillingDetail
         where isnull(ClientProductKey,0) <> @ClientProductKey
                  
	if @CampaignKey is not null
		delete #tMediaMassBillingDetail
         where isnull(CampaignKey,0) <> @CampaignKey		

	if @ProjectKey is not null
		delete #tMediaMassBillingDetail
         where isnull(ProjectKey,0) <> @ProjectKey		

	if @MediaMarketKey is not null
		delete #tMediaMassBillingDetail
         where isnull(MediaMarketKey,0) <> @MediaMarketKey		

	if @MediaEstimateKey is not null
		delete #tMediaMassBillingDetail
         where isnull(MediaEstimateKey,0) <> @MediaEstimateKey		

	if @PurchaseOrderNumber is not null
		delete #tMediaMassBillingDetail
         where isnull(PurchaseOrderNumber,'') <> @PurchaseOrderNumber		

	if @TaskID is not null
		delete #tMediaMassBillingDetail
         where isnull(TaskID,'') <> @TaskID		

	IF @GLCompanyKey >= 0
		DELETE #tMediaMassBillingDetail WHERE GLCompanyKey <> @GLCompanyKey 
	
	IF @RestrictToGLCompany = 1
		-- GLCompanyKey is never null, no need to take isnull

		DELETE #tMediaMassBillingDetail 
		WHERE GLCompanyKey NOT IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (nolock) WHERE UserKey = @UserKey )
	 
	IF @OfficeKey >= 0
		DELETE #tMediaMassBillingDetail WHERE OfficeKey <> @OfficeKey 

	-- publication
	if @CompanyMediaKey is not null
		delete #tMediaMassBillingDetail
         where isnull(CompanyMediaKey,0) <> @CompanyMediaKey

	-- removed for 129332
    --delete #tMediaMassBillingDetail Where UnbilledAmount = 0

	update #tMediaMassBillingDetail
	set    #tMediaMassBillingDetail.SalesTaxAmount = isnull(vd.SalesTaxAmount, 0)
	from   tVoucherDetail vd (nolock)
	where  #tMediaMassBillingDetail.EntityKey = vd.VoucherDetailKey
	and    #tMediaMassBillingDetail.Entity = 'Invoice'

	update #tMediaMassBillingDetail
	set    #tMediaMassBillingDetail.SalesTaxAmount = isnull(pod.SalesTaxAmount, 0)
	from   tPurchaseOrderDetail pod (nolock)
	where  #tMediaMassBillingDetail.EntityKey = pod.PurchaseOrderDetailKey
	and    #tMediaMassBillingDetail.Entity <> 'Invoice'

	--select summary level data
    insert #tMediaMassBilling
		   (ClientKey,
		   CustomerID,
		   ProjectKey,
		   AccountManager,
           ProjectName,
           MediaEstimateKey,
           EstimateName,
		   MediaWorksheetKey,
		   WorksheetID,
		   WorksheetName,

           UnbilledAmount,
           DetailOrderDate,
           DetailOrderEndDate,
           Quantity,
           TotalCost,
		   SalesTaxAmount)
    select ClientKey,
		   CustomerID,
           ProjectKey,
           Null,
		   ProjectName,
           MediaEstimateKey,
		   EstimateName,
		   isnull(MediaWorksheetKey,0),
		   WorksheetID,
		   WorksheetName,

		   SUM(UnbilledAmount),
		   MIN(DetailOrderDate),
           MAX(DetailOrderEndDate),
           SUM(Quantity),
           SUM(TotalCost),
		   SUM(SalesTaxAmount)
      from #tMediaMassBillingDetail
  group by ClientKey,
		   CustomerID,
	       ProjectKey,
	       ProjectName,
		   MediaEstimateKey,
           EstimateName,
		   isnull(MediaWorksheetKey,0),
           WorksheetID,
		   WorksheetName


	update #tMediaMassBillingDetail set ProjectName = 'No Project' where isnull(ProjectName, '') = ''
	update #tMediaMassBillingDetail set EstimateName = 'No Estimate' where isnull(EstimateName, '') = ''


	update #tMediaMassBilling
	set    #tMediaMassBilling.AccountManager = u.FirstName + ' ' + u.LastName
	from   tProject p (nolock)
	left   outer join tUser u (nolock) ON p.AccountManager = u.UserKey
	where  #tMediaMassBilling.ProjectKey = p.ProjectKey
	--and (@AccountManager is null or p.AccountManager = @AccountManager)

/*

select * from #tMediaMassBilling

*/
	RETURN 1
GO
