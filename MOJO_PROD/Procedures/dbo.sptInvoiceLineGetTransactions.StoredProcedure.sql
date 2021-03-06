USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetTransactions]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceLineGetTransactions]
(
   @CompanyKey int
   ,@Type int					-- 0 All, 1 Labor, 2 Expenses
   ,@GLCompanyKey int			-- Set on the invoice, can be null
   ,@ClientKey int				-- Set on the invoice, always > 0 
   ,@ProjectNumber varchar(50)	-- Can be null 
   ,@TaskID varchar(50)			-- Can be null	
   ,@EstimateID varchar(50)		-- Can be null
   ,@ItemID varchar(50)			-- Can be null
   ,@StartDate datetime			-- Can be null
   ,@ThruDate datetime			-- Can be null
   ,@UserKey int = null         -- added for ICT will be null for ASPX
   ,@ServiceCode varchar(50) = null	-- Can be null
   ,@CurrencyID varchar(10) = null	-- Can be null
)

as --Encrypt

/*
|| When         Who    Rel    What
|| 08/03/07     GHL    8.5    Creation for the new invoice transactions screen
||                            Show all transactions for billable projects or media estimates
||                            Error out if the number of transactions is too large
||                            Meant to replace sptInvoiceLineGetCosts + sptInvoiceLineGetLabor
||                            + closer to mass billing
|| 10/31/07    BSH    8.5     Fixed search criteria, Vouchers not showing when no dates specified.
|| 11/02/07    GHL    8.5     Fixed bad join on last voucher detail query
|| 11/21/07    GHL    8.5     Fixed bad entity key on PO detail
|| 12/3/07	   GWG	  8.5	  Added a check for labor billing worksheets to be less than status 5
|| 02/06/08    GHL    8.5     (20844) Allowing case when client is parent company and project is from child client
|| 02/18/08    GHL    8.5     (21552) Added comments for tTime entries
|| 02/19/08    GHL    8.5     (21165) Added Expense receipt info for VI in Comments section now
|| 08/25/08    GHL    8.518   (33313) Increased the size of TaskName to 500 size of tTask.TaskName. Users have huge task names! 
|| 06/29/10    GHL    10.532  Added UnitCost for Flex screen so that it can be shown on different grids without having to make db calls
||                            + RateLevel + ReasonID
|| 01/05/11    GHL    10.539  (92575) Revisited query for tTime better using indexes (query time from 30sec to 1sec)
|| 01/14/11    GHL    10.539  (100133) Added filter on TaskKey when querying tTime
|| 01/14/11    GHL    10.540  (100453) Added ExpenseKey (int) to temp table and joining now thru ExpenseKey vs EntityKey (varchar)
||                            This was causing table scan in tPurchaseOrderDetail (last query)
||                            Also added index on tPurchaseOrder.MediaEstimateKey to remove table tPurchaseOrder scans
|| 03/28/12    GHL    10.554  Made changes for ICT
|| 04/20/12    GHL    10.555  (140727) Added ItemKey, ItemID for editable lookups on flex screen
|| 04/30/13    GHL    10.567  (176289) Added search by service 
|| 05/13/13    RLB    10.568  (177558) Added VendorName
|| 10/01/13    GHL    10.573   Added currency ID to support multi currency
|| 02/05/14    GHL    10.576   (204536) Added rounding of BillableCost
|| 02/27/15    WDF    10.589   (247949/247861) Fixed possible data truncation error of Description in #tMassBilling
|| 04/03/15    RLB    10.590  (252148) only pull data that TransferToKey is null
*/

declare @IOClientLink tinyint
declare @BCClientLink tinyint
declare @Time int
declare @Expense int
declare @ProjectKey int	      
declare @MediaEstimateKey int
declare @TaskKey int
declare @ItemKey int
declare @ServiceKey int
declare @MultiCurrency int

if @Type = 0
	select @Time = 1
	      ,@Expense = 1
if @Type = 1
	select @Time = 1
	      ,@Expense = 0
if @Type = 2
	select @Time = 0
	      ,@Expense = 1
if @StartDate is null
	select @StartDate = '01/01/1900'
if @ThruDate is null
	select @ThruDate = '01/01/2050'
		
if @EstimateID is not null
begin
	select @MediaEstimateKey = MediaEstimateKey
	from tMediaEstimate (nolock) 
	where CompanyKey = @CompanyKey
	and upper(EstimateID) = upper(@EstimateID)   

	if @MediaEstimateKey is null
		return -1
end	      

if @ItemID is not null
begin
	select @ItemKey = ItemKey
	from tItem (nolock) 
	where CompanyKey = @CompanyKey
	and upper(ItemID) = upper(@ItemID)   

	if @ItemKey is null
		return -2
end	      

if @ServiceCode is not null
begin
	select @ServiceKey = ServiceKey
	from tService (nolock) 
	where CompanyKey = @CompanyKey
	and upper(ServiceCode) = upper(@ServiceCode)   

	if @ServiceKey is null
		return -2
end	      

if @ProjectNumber is not null
begin	 
	select @ProjectKey = ProjectKey
	from tProject (nolock) 
	where CompanyKey = @CompanyKey	
	and upper(ProjectNumber) = upper(@ProjectNumber)   
	and (ClientKey = @ClientKey 
		or 
		ClientKey in (Select CompanyKey 
					  From tCompany (nolock)
					  Where OwnerCompanyKey = @CompanyKey
					  And ParentCompanyKey = @ClientKey))
					  
	if @ProjectKey is null
		return -3		 
end	      

if @TaskID is not null
begin
	select @TaskKey = TaskKey
	from tTask (nolock) 
	where ProjectKey = @ProjectKey
	and upper(TaskID) = upper(@TaskID)   

	if @TaskKey is null
		return -4
end	      
	     
	create table #tMassBilling (
		GLCompanyKey		int null,
		Entity              varchar(10) null,	
		EntityKey           varchar(200) null,
        EntityDate          datetime null,		-- Displayed on grid
        EntityNumber        varchar(50) null,
		VendorName         varchar(255) null,   -- Displayed on grid
		ProjectName			varchar(200) null,  -- Displayed on grid
		MediaEstimateName	varchar(200) null,  -- Displayed on grid
		Description         varchar(250) null,  -- Displayed on grid
		TaskName            varchar(500) null,  -- Displayed on grid
		ItemName            varchar(200) null,  -- Displayed on grid
		ItemID              varchar(200) null,  -- Displayed on grid
		ItemKey             int null,           -- Displayed on grid
        Quantity            decimal(24,4) null, -- Displayed on grid
		UnitCost            money null,         -- for flex screen
		TotalCost           money null,         -- Displayed on grid
		BillableCost		money null,			-- Displayed on grid
		TranType			varchar(25)  null,	-- Displayed on grid
		Comments            varchar(2000) null,
		RateLevel           int null,
		ReasonID            varchar(6) null,
		
		TimeKey             uniqueidentifier null, -- added to improve queries in tTime
		ExpenseKey          int null,			   -- added to improve queries in other tables	
		
		TaskKey             int null,
		CurrencyID          varchar(10) null,
		UpdateFlag          int null              -- general purpose flag  
		) 	
		

/*		 
 * Clone of spMassBillingGetMedia
 */
		 
	-- get client link settings, default to 'through project'
	select @IOClientLink = isnull(IOClientLink,1),
           @BCClientLink = isnull(BCClientLink,1),
		   @MultiCurrency = isnull(MultiCurrency, 0)
      from tPreference (nolock)
     where CompanyKey = @CompanyKey

	-- get all IOs for this company
	if @Expense = 1 
	    if @IOClientLink = 1  -- through project
		    insert #tMassBilling
				   (GLCompanyKey,
				   Entity,
		           EntityKey,
				   ExpenseKey,
				   EntityDate,
				   EntityNumber,
				   VendorName,
				   ProjectName,
		           MediaEstimateName,
		           Description,
				   TaskName,
	               ItemName,
				   ItemID,
				   ItemKey,
	               Quantity,
	               UnitCost,
		           TotalCost,
				   BillableCost)
		    select ISNULL(p.GLCompanyKey, 0),
				   'PO',
		           pod.PurchaseOrderDetailKey,
	               pod.PurchaseOrderDetailKey,
	               pod.DetailOrderDate,
		           po.PurchaseOrderNumber,
				   c.CompanyName,
		           isnull(p.ProjectNumber+' \ ','') + isnull(left(p.ProjectName, 25),''),
		           isnull(e.EstimateID+' \ ','') + isnull(left(e.EstimateName, 25),''),
				   left(pod.ShortDescription,30),
				   t.TaskName,
				   i.ItemName,
	               i.ItemID,
				   i.ItemKey,
				   pod.Quantity,
	               pod.UnitCost,
		           pod.PTotalCost,
				   isnull(case isnull(po.BillAt, 0) 
			           when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,0)
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,0) end ,0)
              from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	               left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
				   left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
				   left outer join tCompany c (nolock) on po.VendorKey = c.CompanyKey	
		     where pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0  -- vendor has not invoiced
			   and pod.TransferToKey IS NULL
		       and po.Status = 4 -- PO approved
		       and po.POKind = 1
	           and p.CompanyKey = @CompanyKey -- limit to the user's company
	           and (@ProjectKey IS NOT NULL OR p.ClientKey = @ClientKey) -- if valid project, do not check client
	           and (isnull(pod.PCurrencyID, '') = isnull(@CurrencyID, '')) 
			   and (@MediaEstimateKey IS NULL OR po.MediaEstimateKey = @MediaEstimateKey)
	           and (@ProjectKey IS NULL OR pod.ProjectKey = @ProjectKey)
	           and (@TaskKey IS NULL OR pod.TaskKey = @TaskKey)
	           and (@ItemKey IS NULL OR pod.ItemKey = @ItemKey)
			   and p.Closed = 0
	           and p.NonBillable = 0
	           and isnull(pod.OnHold,0) = 0
	           and isnull(pod.Closed,0) = 0
	           AND NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
							AND   bd.Entity = 'tPurchaseOrderDetail')

		else  -- through media estimate
		    insert #tMassBilling
				   (GLCompanyKey,
				   Entity,
		           EntityKey,
				   ExpenseKey,
				   EntityDate,
				   EntityNumber,
				   VendorName,
				   ProjectName,
		           MediaEstimateName,
		           Description,
				   TaskName,
	               ItemName,
				   ItemID,
				   ItemKey,
	               Quantity,
	               UnitCost,
		           TotalCost,
		           BillableCost)
		    select ISNULL(e.GLCompanyKey, 0),
		           'PO',
		           pod.PurchaseOrderDetailKey,
	               pod.PurchaseOrderDetailKey,
	               pod.DetailOrderDate,
		           po.PurchaseOrderNumber,
				   c.CompanyName,
		           isnull(p.ProjectNumber+' \ ','') + isnull(left(p.ProjectName, 25),''),
		           isnull(e.EstimateID+' \ ','') + isnull(left(e.EstimateName, 25),''),
				   left(pod.ShortDescription,30),
	               t.TaskName,
	               i.ItemName,
	               i.ItemID,
				   i.ItemKey,
				   pod.Quantity,
	               pod.UnitCost,
	               pod.PTotalCost,
		           isnull(case isnull(po.BillAt, 0) 
			           when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,0)
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,0) end ,0)
		 from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
				   inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
				   left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
	 	       left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
	       	       left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
				   left outer join tCompany c (nolock) on po.VendorKey = c.CompanyKey
		     where pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0  -- vendor has not invoiced
			   and pod.TransferToKey IS NULL
		       and po.Status = 4 -- PO approved
		  and po.POKind = 1
	           and e.CompanyKey = @CompanyKey -- limit to the user's company
	        and e.ClientKey = @ClientKey
	           and (@MediaEstimateKey IS NULL OR po.MediaEstimateKey = @MediaEstimateKey)
	           and (@ProjectKey IS NULL OR pod.ProjectKey = @ProjectKey)
	           and (isnull(pod.PCurrencyID, '') = isnull(@CurrencyID, '')) 
			   and (@TaskKey IS NULL OR pod.TaskKey = @TaskKey)
	           and (@ItemKey IS NULL OR pod.ItemKey = @ItemKey)	
	           and isnull(pod.OnHold,0) = 0
			   and isnull(pod.Closed,0) = 0
	           AND NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
							AND   bd.Entity = 'tPurchaseOrderDetail')


	-- get all BCs for this company
    if @Expense = 1	
	    if @BCClientLink = 1  -- through project
		    insert #tMassBilling
				   (GLCompanyKey,
				   Entity,
		           EntityKey,
				   ExpenseKey,
				   EntityDate,
				   EntityNumber,
				   VendorName,
				   ProjectName,
		           MediaEstimateName,
		           Description,
				   TaskName,
	               ItemName,
	               ItemID,
				   ItemKey,
				   Quantity,
				   UnitCost,
		           TotalCost,
		           BillableCost)
		    select ISNULL(p.GLCompanyKey, 0),
				   'PO',
		           pod.PurchaseOrderDetailKey,
	               pod.PurchaseOrderDetailKey,
	               pod.DetailOrderDate,
		           po.PurchaseOrderNumber,
				   c.CompanyName,
		           isnull(p.ProjectNumber+' \ ','') + isnull(left(p.ProjectName, 25),''),
		           isnull(e.EstimateID+' \ ','') + isnull(left(e.EstimateName, 25),''),
				   left(pod.ShortDescription,30),
	               t.TaskName,
	               i.ItemName,
	               i.ItemID,
				   i.ItemKey,
				   pod.Quantity,
	               pod.UnitCost,
		           pod.PTotalCost,
		           isnull(case isnull(po.BillAt, 0) 
			           when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,0)
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,0) end ,0)
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
				   left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
				   left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
				   left outer join tCompany c (nolock) on po.VendorKey = c.CompanyKey
		     where pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0 -- vendor has not invoiced
			   and pod.TransferToKey IS NULL
		       and po.Status = 4 -- PO approved
			   and po.POKind = 2
	           and p.CompanyKey = @CompanyKey -- limit to the user's company
	           and (@ProjectKey IS NOT NULL OR p.ClientKey = @ClientKey) -- if valid project, do not check client
	           and (isnull(pod.PCurrencyID, '') = isnull(@CurrencyID, '')) 
			   and (@MediaEstimateKey IS NULL OR po.MediaEstimateKey = @MediaEstimateKey)
	           and (@ProjectKey IS NULL OR pod.ProjectKey = @ProjectKey)
	           and (@TaskKey IS NULL OR pod.TaskKey = @TaskKey)
	           and (@ItemKey IS NULL OR pod.ItemKey = @ItemKey)	
	           and p.Closed = 0
	           and p.NonBillable = 0
	           and isnull(pod.OnHold,0) = 0
	           and isnull(pod.Closed,0) = 0
	          AND NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
							AND   bd.Entity = 'tPurchaseOrderDetail')

		else  -- through media estimate
		    insert #tMassBilling
				   (GLCompanyKey,
				   Entity,
		           EntityKey,
				   ExpenseKey,
				   EntityDate,
				   EntityNumber,
				   VendorName,
				   ProjectName,
		           MediaEstimateName,
		           Description,
				   TaskName,
	               ItemName,
	               ItemID,
				   ItemKey,
				   Quantity,
				   UnitCost,
	               TotalCost,
		           BillableCost)
		    select ISNULL(e.GLCompanyKey, 0),
				   'PO',
		           pod.PurchaseOrderDetailKey,
				   pod.PurchaseOrderDetailKey,
				   pod.DetailOrderDate,
		           po.PurchaseOrderNumber,
				   c.CompanyName,
				   isnull(p.ProjectNumber+' \ ','') + isnull(left(p.ProjectName, 25),''),
		           isnull(e.EstimateID+' \ ','') + isnull(left(e.EstimateName, 25),''),
				   left(pod.ShortDescription,30),
	               t.TaskName,
	               i.ItemName,
	               i.ItemID,
				   i.ItemKey,
				   pod.Quantity,
	               pod.UnitCost,
		           pod.PTotalCost,
		           isnull(case isnull(po.BillAt, 0) 
                       when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,0)
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,0) end ,0)
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
				   inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
		           left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
	               left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
	               left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
				   left outer join tCompany c (nolock) on po.VendorKey = c.CompanyKey
		     where pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0   -- vendor has not invoiced
			   and pod.TransferToKey IS NULL
		       and po.Status = 4 -- PO approved
		       and po.POKind = 2
	           and e.CompanyKey = @CompanyKey -- limit to the user's company	
	           and e.ClientKey = @ClientKey
	           and (@MediaEstimateKey IS NULL OR po.MediaEstimateKey = @MediaEstimateKey)
	           and (@ProjectKey IS NULL OR pod.ProjectKey = @ProjectKey)
	           and (isnull(pod.PCurrencyID, '') = isnull(@CurrencyID, '')) 
			   and (@TaskKey IS NULL OR pod.TaskKey = @TaskKey)
	           and (@ItemKey IS NULL OR pod.ItemKey = @ItemKey)	
	           and isnull(pod.OnHold,0) = 0
	           and isnull(pod.Closed,0) = 0
	           AND NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
							AND   bd.Entity = 'tPurchaseOrderDetail')


	-- get all IOs with vendor invoices for this company
    if @Expense = 1	
	    if @IOClientLink = 1  -- through project
		    insert #tMassBilling
				   (GLCompanyKey,
				   Entity,
		           EntityKey,
				   ExpenseKey,
				   EntityDate,
				   EntityNumber,
				   VendorName,
				   ProjectName,
		           MediaEstimateName,
		           Description,
				   TaskName,
	               ItemName,
	               ItemID,
				   ItemKey,
				   Quantity,
	               UnitCost,
		           TotalCost,
		           BillableCost)
		    select ISNULL(p.GLCompanyKey, 0),
				   'VO',
				   vd.VoucherDetailKey,
	               vd.VoucherDetailKey,
	               v.InvoiceDate,
		           v.InvoiceNumber,
				   c.CompanyName,
		           isnull(p.ProjectNumber+' \ ','') + isnull(left(p.ProjectName, 25),''),
		           isnull(e.EstimateID+' \ ','') + isnull(left(e.EstimateName, 25),''),
				   left(pod.ShortDescription,30),
	               t.TaskName,
	               i.ItemName,
	               i.ItemID,
				   i.ItemKey,
				   vd.Quantity,
	               vd.UnitCost,
		           vd.PTotalCost,
				   vd.BillableCost
		  from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		           inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		         inner join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
		           left outer join tTask t (nolock) on vd.TaskKey = t.TaskKey
		           left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
				   left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		     where vd.InvoiceLineKey is null -- customer not yet billed
				  and vd.TransferToKey IS NULL
		          and v.Status = 4 -- Voucher approved
		   and po.POKind = 1
			 and p.CompanyKey = @CompanyKey -- limit to the user's company
		           and (@ProjectKey IS NOT NULL OR p.ClientKey = @ClientKey) -- if valid project, do not check client
				   and (isnull(vd.PCurrencyID, '') = isnull(@CurrencyID, '')) 
			       and (@MediaEstimateKey IS NULL OR po.MediaEstimateKey = @MediaEstimateKey)
	               and (@ProjectKey IS NULL OR vd.ProjectKey = @ProjectKey)
	               and (@TaskKey IS NULL OR vd.TaskKey = @TaskKey)
	               and (@ItemKey IS NULL OR pod.ItemKey = @ItemKey)	
	               and p.Closed = 0
				   and p.NonBillable = 0
				   and isnull(pod.OnHold,0) = 0
                   and isnull(pod.Closed,0) = 0
				   AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)
                   
		else  -- through media estimate
		    insert #tMassBilling
				   (GLCompanyKey,
				   Entity,
		           EntityKey,
				   ExpenseKey,
				   EntityDate,
				   EntityNumber,
				   VendorName,
				   ProjectName,
		           MediaEstimateName,
		           Description,
				   TaskName,
	               ItemName,
	               ItemID,
				   ItemKey,
				   Quantity,
				   UnitCost,
		           TotalCost,
		           BillableCost)
		    select ISNULL(e.GLCompanyKey, 0),
				   'VO',
		           vd.VoucherDetailKey,
	               vd.VoucherDetailKey,
	               v.InvoiceDate,
		           v.InvoiceNumber,
				   c.CompanyName,
		           isnull(p.ProjectNumber+' \ ','') + isnull(left(p.ProjectName, 25),''),
		           isnull(e.EstimateID+' \ ','') + isnull(left(e.EstimateName, 25),''),
				   left(pod.ShortDescription,30),
	               t.TaskName,
	               i.ItemName,
	               i.ItemID,
				   i.ItemKey,
				   vd.Quantity,
	               vd.UnitCost,
		           vd.PTotalCost,
		           vd.BillableCost
		      from tPurchaseOrderDetail pod (nolock) 
		          inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		           inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
				   inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
		           left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
	               left outer join tTask t (nolock) on vd.TaskKey = t.TaskKey
	               left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
				   left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		     where vd.InvoiceLineKey is null -- customer not yet billed
			   and vd.TransferToKey IS NULL
		       and v.Status = 4 -- PO approved
		       and po.POKind = 1
	           and e.CompanyKey = @CompanyKey -- limit to the user's company
	           and e.ClientKey = @ClientKey
	  and (@MediaEstimateKey IS NULL OR po.MediaEstimateKey = @MediaEstimateKey)
	           and (@ProjectKey IS NULL OR vd.ProjectKey = @ProjectKey)
			   and (isnull(vd.PCurrencyID, '') = isnull(@CurrencyID, '')) 
	           and (@TaskKey IS NULL OR vd.TaskKey = @TaskKey)
	           and (@ItemKey IS NULL OR pod.ItemKey = @ItemKey)	
	           and isnull(pod.OnHold,0) = 0
	           and isnull(pod.Closed,0) = 0
			   AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)


	-- get all BCs with vendor invoices for this company
    if @Expense = 1		           
	 if @BCClientLink = 1  -- through project
		    insert #tMassBilling
				   (GLCompanyKey,
				   Entity,
		           EntityKey,
				   ExpenseKey,
				   EntityDate,
				   EntityNumber,
				   VendorName,
				   ProjectName,
		           MediaEstimateName,
		           Description,
				   TaskName,
	               ItemName,
	               ItemID,
				   ItemKey,
				   Quantity,
	               UnitCost,
		           TotalCost,
		           BillableCost)
		    select ISNULL(p.GLCompanyKey, 0),
				   'VO',
		           vd.VoucherDetailKey,
	               vd.VoucherDetailKey,
	               v.InvoiceDate,
		           v.InvoiceNumber,
				   c.CompanyName,
		           isnull(p.ProjectNumber+' \ ','') + isnull(left(p.ProjectName, 25),''),
		           isnull(e.EstimateID+' \ ','') + isnull(left(e.EstimateName, 25),''),
				   left(pod.ShortDescription,30),
				   t.TaskName,
	               i.ItemName,
	               i.ItemID,
				   i.ItemKey,
				   vd.Quantity,
	               vd.UnitCost,
		           vd.PTotalCost,
				   vd.BillableCost
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		           inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		           inner join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	               left outer join tTask t (nolock) on vd.TaskKey = t.TaskKey
	               left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
				   left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		     where vd.InvoiceLineKey is null -- customer not yet billed
			   and vd.TransferToKey IS NULL
		       and v.Status = 4 -- PO approved
		       and po.POKind = 2
	           and p.CompanyKey = @CompanyKey -- limit to the user's company
	           and (@ProjectKey IS NOT NULL OR p.ClientKey = @ClientKey) -- if valid project, do not check client
	           and (@MediaEstimateKey IS NULL OR po.MediaEstimateKey = @MediaEstimateKey)
	           and (@ProjectKey IS NULL OR vd.ProjectKey = @ProjectKey)
			   and (isnull(vd.PCurrencyID, '') = isnull(@CurrencyID, '')) 
	           and (@TaskKey IS NULL OR vd.TaskKey = @TaskKey)
	           and (@ItemKey IS NULL OR pod.ItemKey = @ItemKey)	
	           and p.Closed = 0
	           and p.NonBillable = 0
	           and isnull(pod.OnHold,0) = 0
	           and isnull(pod.Closed,0) = 0
			   AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)

		else  -- through media estimate
		    insert #tMassBilling
				   (GLCompanyKey,
				   Entity,
		           EntityKey,
				   ExpenseKey,
				   EntityDate,
				   EntityNumber,
				   VendorName,
				   ProjectName,
		           MediaEstimateName,
		           Description,
				   TaskName,
	               ItemName,
	               ItemID,
				   ItemKey,
				   Quantity,
	               UnitCost,
		           TotalCost,
		           BillableCost)
		    select ISNULL(e.GLCompanyKey, 0),
				   'VO',
		           vd.VoucherDetailKey,
	               vd.VoucherDetailKey,
	               v.InvoiceDate,
		           v.InvoiceNumber,
				   c.CompanyName,
		           isnull(p.ProjectNumber+' \ ','') + isnull(left(p.ProjectName, 25),''),
		           isnull(e.EstimateID+' \ ','') + isnull(left(e.EstimateName, 25),''),
				   left(pod.ShortDescription,30),
				   t.TaskName,
	               i.ItemName,
	               i.ItemID,
				   i.ItemKey,
				   vd.Quantity,
	               vd.UnitCost,
		           vd.PTotalCost,
				   vd.BillableCost
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		         inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
				   inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	 	   left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
			       left outer join tTask t (nolock) on vd.TaskKey = t.TaskKey
		           left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
				   left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		     where vd.InvoiceLineKey is null -- customer not yet billed
			   and vd.TransferToKey IS NULL
		       and v.Status = 4 -- PO approved
		       and po.POKind = 2
	           and e.CompanyKey = @CompanyKey -- limit to the user's company	
			   and e.ClientKey = @ClientKey
			   and (@MediaEstimateKey IS NULL OR po.MediaEstimateKey = @MediaEstimateKey)
	           and (@ProjectKey IS NULL OR vd.ProjectKey = @ProjectKey)
			   and (isnull(vd.PCurrencyID, '') = isnull(@CurrencyID, ''))  
	           and (@TaskKey IS NULL OR vd.TaskKey = @TaskKey)
	           and (@ItemKey IS NULL OR pod.ItemKey = @ItemKey)		           
	           and isnull(pod.OnHold,0) = 0
	           and isnull(pod.Closed,0) = 0
			   AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)
	     	     

/*		 
 * Clone of spMassBillingBill/Get
 */
 	    
if @Time = 1
begin
		-- we know that we have a project key, because on the UI
		-- we require a project or a media estimate, so use tTime.ProjectKey = @ProjectKey

		-- 1: use IX_tTime_3  InvoiceLineKey, TimeSheetKey, ProjectKey, WriteOff, OnHold, WorkDate, ActualRate, ActualHours
		if isnull(@ProjectKey, 0) > 0 AND @MediaEstimateKey is null
		insert #tMassBilling
				 (GLCompanyKey,
				   Entity,
		           EntityKey,
				   TimeKey,
				   EntityDate,
				   EntityNumber,
				   VendorName,
				   ProjectName,
		           MediaEstimateName,
		           Description,
				   TaskName,
	               ItemName,
	               ItemID,
				   ItemKey,
				   Quantity,
				   UnitCost,
	               TotalCost,
		           BillableCost,
		           Comments,
				   RateLevel)
		SELECT     ISNULL(p.GLCompanyKey, 0)
		           ,'TI'
		           , cast(TimeKey as VARCHAR(200))
				   ,t.TimeKey
		           ,t.WorkDate
		           ,NULL
				   ,u.FirstName + ' ' + u.LastName
		           ,isnull(p.ProjectNumber+' \ ','') + isnull(left(p.ProjectName, 25),'')
		           ,NULL
		           ,u.FirstName + ' ' + u.LastName
		           ,null -- ta.TaskName -- get later
		           ,null -- s.Description -- get later
		           ,null -- s.ServiceCode -- get later
		           ,null -- s.ServiceKey -- get later
		           ,t.ActualHours
				   ,t.ActualRate
		           ,ROUND(ActualHours * ActualRate, 2) -- always expressed in project curr
		           ,ROUND(ActualHours * ActualRate, 2) -- always expressed in project curr
		           ,null -- CAST(t.Comments AS VARCHAR(2000)) -- get later
				   ,0    -- t.RateLevel -- not used on UI
		FROM    tTime t (NOLOCK)
			INNER JOIN tProject p (nolock) on t.ProjectKey = p.ProjectKey
			INNER JOIN tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
			INNER JOIN tUser u (nolock) on ts.UserKey = u.UserKey 
		WHERE   t.ProjectKey = @ProjectKey
		and     t.TransferToKey IS NULL
	    and     p.Closed = 0
	    and     p.NonBillable = 0
	    --and     @MediaEstimateKey IS NULL
	    --and     @ItemKey IS NULL
	    AND		ts.Status = 4
		AND     t.InvoiceLineKey IS NULL
		AND     t.WriteOff = 0
		AND		ISNULL(t.OnHold, 0) = 0
		AND     t.WorkDate >= @StartDate
		AND     t.WorkDate <= @ThruDate
		
		--2: now delete records if on a billing worksheet
		update #tMassBilling
		set    #tMassBilling.UpdateFlag = 1
		from   tBillingDetail bd (NOLOCK) 
		      inner join tBilling b (NOLOCK) on bd.BillingKey = b.BillingKey 
		WHERE b.CompanyKey = @CompanyKey
		AND	  b.Status < 5
		AND   bd.Entity = 'tTime'
		AND   bd.BillingKey = b.BillingKey
		AND   bd.EntityGuid = #tMassBilling.TimeKey
		AND   #tMassBilling.Entity = 'TI'
		 
		-- also delete if the wrong currency
		if @MultiCurrency = 1
		begin
			-- I had to do a separate call here because there is no index on CurrencyID
			update #tMassBilling
			set    #tMassBilling.CurrencyID = t.CurrencyID
			from   tTime t (NOLOCK) 
			WHERE  #tMassBilling.TimeKey = t.TimeKey
			AND    #tMassBilling.Entity = 'TI'
		
			update #tMassBilling
			set    #tMassBilling.UpdateFlag = 1
			where  isnull(#tMassBilling.CurrencyID, '') <> isnull(@CurrencyID, '')  
		end

        delete #tMassBilling where Entity = 'TI' and UpdateFlag = 1

		-- 3:pull data missing on the records left
		update #tMassBilling 
		set    #tMassBilling.TaskName = ta.TaskName
		      ,#tMassBilling.TaskKey = t.TaskKey
		      ,#tMassBilling.ItemName = s.Description
			  ,#tMassBilling.ItemID = s.ServiceCode
			  ,#tMassBilling.ItemKey = s.ServiceKey
			  ,#tMassBilling.Comments = CAST(t.Comments AS VARCHAR(2000))
		from tTime t (nolock)
		   left join tTask ta (nolock) on t.TaskKey = ta.TaskKey
		   left join tService s (nolock) on t.ServiceKey = s.ServiceKey
		where #tMassBilling.Entity = 'TI'
		and   #tMassBilling.TimeKey = t.TimeKey

		if isnull(@TaskKey,0) > 0
			delete #tMassBilling where Entity = 'TI' and TaskKey <> @TaskKey 

		if isnull(@ServiceKey,0) > 0
			delete #tMassBilling where Entity = 'TI' and ItemKey <> @ServiceKey 

end

		
if @Expense = 1
		insert #tMassBilling
				   (GLCompanyKey,
				   Entity,
		           EntityKey,
				   ExpenseKey,
				   EntityDate,
				   EntityNumber,
				   VendorName,
				   ProjectName,
		           MediaEstimateName,
		           Description,
				   TaskName,
	               ItemName,
				   ItemID,
				   ItemKey,
	               Quantity,
				   UnitCost,
	               TotalCost,
		           BillableCost)
		SELECT     ISNULL(p.GLCompanyKey, 0)
		           ,'MC'
		           ,mc.MiscCostKey
		           ,mc.MiscCostKey
		           ,mc.ExpenseDate
		           ,NULL
				   ,''
		           ,isnull(p.ProjectNumber+' \ ','') + isnull(left(p.ProjectName, 25),'')
		           ,NULL
		           ,left(mc.ShortDescription, 30)
		           ,t.TaskName
		           ,i.ItemName
		           ,i.ItemID
				   ,i.ItemKey
	               ,mc.Quantity
				   ,mc.UnitCost
		           ,mc.TotalCost	-- always expressed in project curr
		           ,mc.BillableCost -- always expressed in project curr
			FROM	tMiscCost mc (NOLOCK)
				INNER JOIN tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
				LEFT OUTER JOIN tTask t (NOLOCK) ON mc.TaskKey = t.TaskKey
				LEFT OUTER JOIN tItem i (NOLOCK) ON mc.ItemKey = i.ItemKey
			WHERE	p.CompanyKey = @CompanyKey
	        and (@ProjectKey IS NOT NULL OR p.ClientKey = @ClientKey) -- if valid project, do not check client
			and p.Closed = 0
			and p.NonBillable = 0
		    and  @MediaEstimateKey IS NULL
			and (@ProjectKey IS NULL OR mc.ProjectKey = @ProjectKey)
			and (isnull(p.CurrencyID, '') = isnull(@CurrencyID, '')) -- misc costs are in the project currency
	        and (@TaskKey IS NULL OR mc.TaskKey = @TaskKey)
	        and (@ItemKey IS NULL OR mc.ItemKey = @ItemKey)		           
			AND     mc.InvoiceLineKey IS NULL
			AND     mc.TransferToKey IS NULL
			AND     ISNULL(mc.WriteOff, 0) = 0
			AND     mc.ExpenseDate >= @StartDate
			AND     mc.ExpenseDate <= @ThruDate
			AND		ISNULL(mc.OnHold, 0) = 0
			AND		NOT EXISTS (SELECT 1 
					FROM tBillingDetail bd (NOLOCK)
						INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
					WHERE b.CompanyKey = @CompanyKey
					AND   b.Status < 5
					AND   bd.EntityKey = mc.MiscCostKey  
					AND   bd.Entity = 'tMiscCost'
					)


if @Expense = 1
		insert #tMassBilling
				   (GLCompanyKey,
				   Entity,
		           EntityKey,
				   ExpenseKey,
				   EntityDate,
				   EntityNumber,
				   VendorName,
				   ProjectName,
		           MediaEstimateName,
		           Description,
				   TaskName,
	               ItemName,
	               ItemID,
				   ItemKey,
	               Quantity,
				   UnitCost,
	               TotalCost,
		           BillableCost)
		SELECT     ISNULL(p.GLCompanyKey, 0)
		           ,'ER'
		           ,er.ExpenseReceiptKey
		           ,er.ExpenseReceiptKey
		           ,er.ExpenseDate
		           ,NULL
				   ,u.FirstName + ' ' + u.LastName
		           ,isnull(p.ProjectNumber+' \ ','') + isnull(left(p.ProjectName, 25),'')
		           ,NULL
		           ,left(er.Description, 30)
		           ,t.TaskName
		           ,i.ItemName
		           ,i.ItemID
				   ,i.ItemKey
	               ,er.ActualQty
				   ,er.ActualUnitCost
		           ,er.PTotalCost--er.ActualCost is in other currency
		           ,er.BillableCost
		FROM	tExpenseReceipt er (NOLOCK)
			INNER JOIN tExpenseEnvelope en (nolock) ON er.ExpenseEnvelopeKey = en.ExpenseEnvelopeKey
				INNER JOIN tProject p (NOLOCK) ON er.ProjectKey = p.ProjectKey
				LEFT OUTER JOIN tTask t (NOLOCK) ON er.TaskKey = t.TaskKey
				LEFT OUTER JOIN tItem i (NOLOCK) ON er.ItemKey = i.ItemKey
				LEFT OUTER JOIN tUser u (NOLOCK) ON en.UserKey = u.UserKey
		WHERE	p.CompanyKey = @CompanyKey
	        and (@ProjectKey IS NOT NULL OR p.ClientKey = @ClientKey) -- if valid project, do not check client
			and p.Closed = 0
			and p.NonBillable = 0
		    and  @MediaEstimateKey IS NULL
			and (@ProjectKey IS NULL OR er.ProjectKey = @ProjectKey)
	        and (isnull(er.PCurrencyID, '') = isnull(@CurrencyID, '')) 
	        and (@TaskKey IS NULL OR er.TaskKey = @TaskKey)
	        and (@ItemKey IS NULL OR er.ItemKey = @ItemKey)
		AND		en.Status = 4
		AND     er.InvoiceLineKey IS NULL
		AND     er.TransferToKey IS NULL
		AND		ISNULL(er.WriteOff, 0) = 0
		AND     er.ExpenseDate >= @StartDate
		AND     er.ExpenseDate <= @ThruDate
		AND		ISNULL(er.OnHold, 0) = 0
		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = er.ExpenseReceiptKey  
				AND   bd.Entity = 'tExpenseReceipt'
				)
		AND		er.VoucherDetailKey IS NULL		

if @Expense = 1
		insert #tMassBilling
				   (GLCompanyKey,
				   Entity,
		           EntityKey,
				   ExpenseKey,
				   EntityDate,
				   EntityNumber,
				   VendorName,
				   ProjectName,
		           MediaEstimateName,
		           Description,
				   TaskName,
	               ItemName,
				   ItemID,
				   ItemKey,
	               Quantity,
				   UnitCost,
	               TotalCost,
		           BillableCost)
		SELECT     ISNULL(p.GLCompanyKey, 0)
		           ,'PO'
		           ,pod.PurchaseOrderDetailKey
		           ,pod.PurchaseOrderDetailKey
		           ,pod.DetailOrderDate
		           ,po.PurchaseOrderNumber
				   ,c.CompanyName
		           ,isnull(p.ProjectNumber+' \ ','') + isnull(left(p.ProjectName, 25),'')
		           ,NULL
		           ,left(pod.ShortDescription, 30)
		           ,t.TaskName
		           ,i.ItemName
				   ,i.ItemID
				   ,i.ItemKey
	               ,pod.Quantity
		           ,pod.UnitCost
		           ,pod.PTotalCost
		           ,pod.BillableCost
			FROM	tPurchaseOrderDetail pod (NOLOCK)
			INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
			INNER JOIN tProject p (NOLOCK) ON pod.ProjectKey = p.ProjectKey
				LEFT OUTER JOIN tTask t (NOLOCK) ON pod.TaskKey = t.TaskKey
				LEFT OUTER JOIN tItem i (NOLOCK) ON pod.ItemKey = i.ItemKey
				LEFT OUTER JOIN tCompany c (NOLOCK) ON po.VendorKey = c.CompanyKey
			WHERE	p.CompanyKey = @CompanyKey
	        and (@ProjectKey IS NOT NULL OR p.ClientKey = @ClientKey) -- if valid project, do not check client
			and p.Closed = 0
			and p.NonBillable = 0
		    and  @MediaEstimateKey IS NULL
			and (@ProjectKey IS NULL OR pod.ProjectKey = @ProjectKey)
			and (isnull(pod.PCurrencyID, '') = isnull(@CurrencyID, '')) 
	        and (@TaskKey IS NULL OR pod.TaskKey = @TaskKey)
	        and (@ItemKey IS NULL OR pod.ItemKey = @ItemKey)
	        AND		pod.InvoiceLineKey IS NULL
			AND     pod.TransferToKey IS NULL
			AND		ISNULL(pod.AppliedCost, 0) = 0
			AND		pod.Closed = 0
			AND		ISNULL(pod.AmountBilled, 0) = 0
			AND		po.PODate >= @StartDate
			AND		po.PODate <= @ThruDate
			AND		po.Status = 4
			--AND		po.POKind = 0     -- Take them all?		
			AND		ISNULL(pod.OnHold, 0) = 0
			AND		NOT EXISTS (SELECT 1 
					FROM tBillingDetail bd (NOLOCK)
						INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
					WHERE b.CompanyKey = @CompanyKey
					AND   b.Status < 5
					AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
					AND   bd.Entity = 'tPurchaseOrderDetail'
					)
			AND    NOT EXISTS (SELECT 1 FROM #tMassBilling b 
					WHERE b.Entity = 'PO' 
					AND b.EntityKey = pod.PurchaseOrderDetailKey) 
			
			
if @Expense = 1
		insert #tMassBilling
				   (GLCompanyKey,
				   Entity,
		           EntityKey,
				   ExpenseKey,
				   EntityDate,
				   EntityNumber,
				   VendorName,
				   ProjectName,
		           MediaEstimateName,
		           Description,
				   TaskName,
	               ItemName,
				   ItemID,
				   ItemKey,
	               Quantity,
				   UnitCost,
	               TotalCost,
		           BillableCost)
		SELECT     ISNULL(p.GLCompanyKey, 0)
		           ,'VO'
		           ,vd.VoucherDetailKey
		           ,vd.VoucherDetailKey
		           ,v.InvoiceDate
		           ,v.InvoiceNumber
				   ,c.CompanyName
		           ,isnull(p.ProjectNumber+' \ ','') + isnull(left(p.ProjectName, 25),'')
		           ,NULL
		           ,left(vd.ShortDescription, 30)
		           ,t.TaskName
		           ,i.ItemName
		           ,i.ItemID
				   ,i.ItemKey
	               ,vd.Quantity
				   ,vd.UnitCost
		           ,vd.PTotalCost
		           ,vd.BillableCost
			FROM	tVoucherDetail vd (NOLOCK) 
			INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
			INNER JOIN tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
				LEFT OUTER JOIN tTask t (NOLOCK) ON vd.TaskKey = t.TaskKey
				LEFT OUTER JOIN tItem i (NOLOCK) ON vd.ItemKey = i.ItemKey
				LEFT OUTER JOIN tCompany c (NOLOCK) ON v.VendorKey = c.CompanyKey
			WHERE	p.CompanyKey = @CompanyKey
	        and (@ProjectKey IS NOT NULL OR p.ClientKey = @ClientKey) -- if valid project, do not check client
			and (isnull(vd.PCurrencyID, '') = isnull(@CurrencyID, '')) 
			and p.Closed = 0
			and p.NonBillable = 0
		    and  @MediaEstimateKey IS NULL
			and (@ProjectKey IS NULL OR vd.ProjectKey = @ProjectKey)
	        and (@TaskKey IS NULL OR vd.TaskKey = @TaskKey)
	        and (@ItemKey IS NULL OR vd.ItemKey = @ItemKey)
			AND     vd.InvoiceLineKey IS NULL
			AND     vd.TransferToKey IS NULL
			AND		ISNULL(vd.WriteOff, 0) = 0
			AND		v.Status = 4
			AND     v.InvoiceDate >= @StartDate
			AND     v.InvoiceDate <= @ThruDate
			AND		ISNULL(vd.OnHold, 0) = 0
			AND		NOT EXISTS (SELECT 1 
					FROM tBillingDetail bd (NOLOCK)
						INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
					WHERE b.CompanyKey = @CompanyKey
					AND   b.Status < 5
					AND   bd.EntityKey = vd.VoucherDetailKey  
					AND   bd.Entity = 'tVoucherDetail'
					)
			AND    NOT EXISTS (SELECT 1 FROM #tMassBilling b 
					WHERE b.Entity = 'VO' 
					AND b.EntityKey = vd.VoucherDetailKey) 
			
DELETE #tMassBilling
WHERE  EntityDate < @StartDate

DELETE #tMassBilling
WHERE  EntityDate > @ThruDate


declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
from  tPreference (nolock) 
Where CompanyKey = @CompanyKey

if @UserKey is null
begin 
	-- we come from the ASPX page, business as usual
	DELETE #tMassBilling
	WHERE  ISNULL(GLCompanyKey, 0) <> ISNULL(@GLCompanyKey, 0)  
end
else
begin
	-- delete if not for this company or mapped to this company 
	delete #tMassBilling
	where  isnull(GLCompanyKey, 0) not in (
		select  isnull(@GLCompanyKey, 0) 
		union
		Select TargetGLCompanyKey from tGLCompanyMap (nolock) Where SourceGLCompanyKey = @GLCompanyKey
	)

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from  tPreference (nolock) 
	Where CompanyKey = @CompanyKey

	if @RestrictToGLCompany = 1
	begin
		-- delete if no access
		delete #tMassBilling
		where  isnull(GLCompanyKey, 0) not in (
			Select GLCompanyKey from tUserGLCompanyAccess (nolock) Where UserKey = @UserKey
		)
	end

end


IF @Expense = 1
UPDATE #tMassBilling
SET    Description = EntityNumber + ' ' + Description
WHERE  Entity IN ('PO', 'VO')

UPDATE #tMassBilling
SET    TranType = CASE	WHEN Entity = 'TI' THEN 'Time'
						WHEN Entity = 'PO' THEN 'Orders'
						WHEN Entity = 'VO' THEN 'Vouchers'
						WHEN Entity = 'MC' THEN 'Misc Costs'
						WHEN Entity = 'ER' THEN 'Exp Receipts'
					END

-- Correct info about VI when converted from ER
IF @Expense = 1
UPDATE #tMassBilling
SET    #tMassBilling.Comments = ' -- Converted from expense receipt -- Person: ' + u.FirstName + ' ' + u.LastName  + ' Report: ' + rtrim(ee.EnvelopeNumber) + ' ' + er.Description
	   ,#tMassBilling.EntityDate = er.ExpenseDate	
FROM   tExpenseReceipt er (nolock) 
	   ,tExpenseEnvelope ee (nolock)
	   ,tUser u (nolock)
WHERE  #tMassBilling.Entity = 'VO' 
AND    #tMassBilling.ExpenseKey = er.VoucherDetailKey
AND    er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
AND    ee.UserKey = u.UserKey

IF @Expense = 1
UPDATE #tMassBilling
SET    #tMassBilling.ReasonID = mrr.ReasonID
FROM   tMediaRevisionReason mrr (nolock) 
       ,tPurchaseOrderDetail pod (nolock) 
WHERE  #tMassBilling.Entity = 'PO' 
AND    #tMassBilling.ExpenseKey = pod.PurchaseOrderDetailKey
AND    pod.MediaRevisionReasonKey = mrr.MediaRevisionReasonKey

update #tMassBilling
set    BillableCost = ROUND(BillableCost, 2)

SELECT * FROM #tMassBilling

return 1
GO
