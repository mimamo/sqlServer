USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spMassBillingBillMediaSummary]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMassBillingBillMediaSummary]
	@ProjectKey int,
	@MediaEstimateKey int,
	@MediaWorksheetKey int,
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
	@OfficeKey int = -1,		-- -1: All, 0: None, or valid record
	@OpenOrdersOnlyOnInvoices int = 0,
	@UseInvoicePostingDate tinyint = 0,
	-- added for new media screens
	@Interactive tinyint = 0,
	@InteractiveBeginDate datetime = null,
	@InteractiveEndDate datetime = null,
	@CompanyMediaKey int = null,
	@OpenOrdersOnly int = 1,
	@ParentClientKey int = null

AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/03/07 GHL 8.5   Added logic for GLCompanyKey and OfficeKey   
  || 10/18/07 GHL 8.438 (14701) Removed restrictions on vouchers with po closed
  || 12/20/07 GHL 8.5   (17723) Added restrictions on vouchers with po closed because another customer complained
  ||                       Using now a parameter to determine this
  || 01/24/08 GHL 8.502   (19677) Nerland. Changed Project on invoices from pod.ProjectKey to v.ProjectKey 
  || 05/01/09 RLB 10.024 (52221) changed the entity class to Voucher on the filter for voucher dates it was Invoice  
  || 09/01/11 GHL 10.547  (120201) Do not include vendor invoice lines which have been written off 
  || 12/27/11 GHL 10.551  (129332) Do not remove recs if UnbilledAmount = 0     
  || 10/04/13 GHL 10.573  Adde support for multi currency
  || 10/24/13 MFT 10.573  Added @UseInvoicePostingDate and CASE logic
  || 03/17/14 RLB 10.587  (198748) Added logic on case for Related Order Date
  || 04/23/14 GHL 10.579  Added support for media worksheets
  || 05/16/14 GHL 10.579  (216340) Changed p.CompanyKey = @CompanyKey to v.CompanyKey = @CompanyKey
  ||                      for users linking to client thru media estimate 
  || 09/04/14 GHL 10.584  (228260) Added param @OpenOrdersOnly for new media screen
  ||                      Must be able to bill closed orders
  || 09/17/14 GHL 10.584 (217847) Added param @ParentClientKey for enhancement
 */
  
/*
	create table #tProcWIPKeys (ClientKey int null, ProjectKey int null, MediaEstimateKey int null, EntityType varchar(20) null, EntityKey varchar(50) null, Action int null)

	create table #tMediaMassBillingDetail (
	    ClientKey           int null,
		ProjectKey          int null,
		MediaEstimateKey    int null,
		Entity              varchar(10) null,
		EntityClass         varchar(10) null,
        EntityKey           int null,
        EntityDate          datetime null,
		ClientDivisionKey   int  null,
		ClientProductKey    int null,
		CampaignKey         int null,
        MediaMarketKey      int null,
        PurchaseOrderNumber varchar(30) null,
        TaskID              varchar(30) null,
        ParentCompanyKey    int null,
        UnbilledAmount      money null,
		CurrencyID          varchar(10) null,
		CurrencyKey         int null
		)

*/

declare @CompanyKey int
declare @IOClientLink tinyint
declare @BCClientLink tinyint
	
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

	-- get all IOs for this company/project/estimate
	if @IO = 1 
	BEGIN
			   insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		           EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select case when @IOClientLink = 1 then p.GLCompanyKey else e.GLCompanyKey end,
				   case when @IOClientLink = 1 then p.OfficeKey else e.OfficeKey end,	
				   case when @IOClientLink = 1 then p.ClientKey else e.ClientKey end,
				   p.ProjectKey,
		           e.MediaEstimateKey,
		           'Order',
		           'IO',
		           pod.PurchaseOrderDetailKey,
	               pod.DetailOrderDate,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               case when @IOClientLink = 1 then p.CampaignKey else e.CampaignKey end,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(case isnull(po.BillAt, 0) 
			           when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,isnull(TotalCost,0))
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0),
				   pod.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		 inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           --left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
	               left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
		     where pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0  -- vendor has not invoiced
		       and po.Status = 4 -- PO approved
		       and po.POKind = 1
	           --and p.CompanyKey = @CompanyKey -- limit to the user's company
	           and po.CompanyKey = @CompanyKey -- limit to the user's company
	           and isnull(pod.OnHold,0) = 0
	           and (@OpenOrdersOnly = 0 or isnull(pod.Closed,0) = 0)
	     	   and (
					(@IOClientLink = 1  and p.Closed = 0 and p.NonBillable = 0)
					or
					@IOClientLink <> 1
					)
				-- these 3 fields are the grouped keys on the summary grid 	
			   and isnull(p.ProjectKey, 0) = isnull(@ProjectKey, 0)
			   and isnull(e.MediaEstimateKey,0) = isnull(@MediaEstimateKey,0)
			   and isnull(po.MediaWorksheetKey,0) = isnull(@MediaWorksheetKey, 0)
				
               and (@CompanyMediaKey is null or po.CompanyMediaKey = @CompanyMediaKey) 
			     
			   AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)

	/*
	    if @IOClientLink = 1  -- through project
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		           EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select p.GLCompanyKey,
		           p.OfficeKey,
		           p.ClientKey,
		           p.ProjectKey,
		           e.MediaEstimateKey,
		           'Order',
		           'IO',
		           pod.PurchaseOrderDetailKey,
	               pod.DetailOrderDate,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               p.CampaignKey,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(case isnull(po.BillAt, 0) 
			           when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,isnull(TotalCost,0))
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0),
				   pod.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		 inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
	               left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
		     where pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0  -- vendor has not invoiced
		       and po.Status = 4 -- PO approved
		       and po.POKind = 1
	           and p.CompanyKey = @CompanyKey -- limit to the user's company
	           and p.NonBillable = 0
	           and p.Closed = 0
	           and isnull(pod.OnHold,0) = 0
	           and isnull(pod.Closed,0) = 0
	           and p.ProjectKey = @ProjectKey
	           and (p.ProjectKey = @ProjectKey and isnull(e.MediaEstimateKey,0) = isnull(@MediaEstimateKey,0))
				AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)
			
		else  -- through media estimate
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		           EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select e.GLCompanyKey,
		           e.OfficeKey,
		           e.ClientKey,
		           p.ProjectKey,
		           e.MediaEstimateKey,
		           'Order',
		           'IO',
		           pod.PurchaseOrderDetailKey,
	               pod.DetailOrderDate,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               e.CampaignKey,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(case isnull(po.BillAt, 0) 
			           when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,isnull(TotalCost,0))
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0),
				   pod.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
				   inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
		           inner join tCompany c (nolock) on e.ClientKey = c.CompanyKey
	       	       left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
   	               left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
	     left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
		     where pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0  -- vendor has not invoiced
		       and po.Status = 4 -- PO approved
		       and po.POKind = 1
	           and e.CompanyKey = @CompanyKey -- limit to the user's company	
	           and isnull(pod.OnHold,0) = 0
               and isnull(pod.Closed,0) = 0
               and (e.MediaEstimateKey = @MediaEstimateKey and isnull(p.ProjectKey,0) = isnull(@ProjectKey,0))
				AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)
	
	*/

	END

	-- get all BCs for this company/project/estimate
    if @BC = 1	
	begin
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		           EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	           TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select case when @BCClientLink = 1 then p.GLCompanyKey else e.GLCompanyKey end,
				   case when @BCClientLink = 1 then p.OfficeKey else e.OfficeKey end,
				   case when @BCClientLink = 1 then p.ClientKey else e.ClientKey end,
		           p.ProjectKey,
		           e.MediaEstimateKey,
		           'Order',
		           'BC',
		           pod.PurchaseOrderDetailKey,
				   pod.DetailOrderDate,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               case when @BCClientLink = 1 then p.CampaignKey else e.CampaignKey end,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(case isnull(po.BillAt, 0) 
			           when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,isnull(TotalCost,0))
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0),
				   pod.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           --inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
	               left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
		     where pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0   -- vendor has not invoiced
		       and po.Status = 4 -- PO approved
		       and po.POKind = 2
	           and isnull(pod.OnHold,0) = 0
	           and (@OpenOrdersOnly = 0 or isnull(pod.Closed,0) = 0)
	     	   and po.CompanyKey = @CompanyKey -- limit to user company!

			   -- these 3 fields are the grouped keys on the summary grid 	
			   and isnull(p.ProjectKey, 0) = isnull(@ProjectKey, 0)
			   and isnull(e.MediaEstimateKey,0) = isnull(@MediaEstimateKey,0)
			   and isnull(po.MediaWorksheetKey,0) = isnull(@MediaWorksheetKey, 0)
				
			  and (
					(@BCClientLink = 1  and p.Closed = 0 and p.NonBillable = 0)
					or
					@BCClientLink <> 1
					)

				and (@CompanyMediaKey is null or po.CompanyMediaKey = @CompanyMediaKey)

				AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)
	/*
	    if @BCClientLink = 1  -- through project
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		           EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	           TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select p.GLCompanyKey,
		           p.OfficeKey,
		           p.ClientKey,
		           p.ProjectKey,
		           e.MediaEstimateKey,
		           'Order',
		           'BC',
		           pod.PurchaseOrderDetailKey,
				   pod.DetailOrderDate,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               p.CampaignKey,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(case isnull(po.BillAt, 0) 
			           when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,isnull(TotalCost,0))
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0),
				   pod.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
	               left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
		     where pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0   -- vendor has not invoiced
		       and po.Status = 4 -- PO approved
		       and po.POKind = 2
	           and p.CompanyKey = @CompanyKey -- limit to the user's company
	           and p.NonBillable = 0
	           and p.Closed = 0
	           and isnull(pod.OnHold,0) = 0
	           and isnull(pod.Closed,0) = 0
	           and (p.ProjectKey = @ProjectKey and isnull(e.MediaEstimateKey,0) = isnull(@MediaEstimateKey,0))
				AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)
		else  -- through media estimate
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		           EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select e.GLCompanyKey,
		           e.OfficeKey,
		           e.ClientKey,
		           p.ProjectKey,
		           e.MediaEstimateKey,
		           'Order',
		           'BC',
		           pod.PurchaseOrderDetailKey,
	               pod.DetailOrderDate,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               e.CampaignKey,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(case isnull(po.BillAt, 0) 
                       when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,isnull(TotalCost,0))
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0),
				   pod.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		    inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
				   inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
		           inner join tCompany c (nolock) on e.ClientKey = c.CompanyKey
	       	       left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
	               left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
		     where pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0   -- vendor has not invoiced
		       and po.Status = 4 -- PO approved
		       and po.POKind = 2
	           and e.CompanyKey = @CompanyKey -- limit to the user's company	
	           and isnull(pod.OnHold,0) = 0
	           and isnull(pod.Closed,0) = 0
               and (e.MediaEstimateKey = @MediaEstimateKey and isnull(p.ProjectKey,0) = isnull(@ProjectKey,0))
				AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)
*/

	end

	create table #pokind (POKind int null)
	if @Interactive = 1 
		insert #pokind (POKind) values (4)

	if @Interactive = 1 
	BEGIN
			   insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		           EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select p.GLCompanyKey,
				   p.OfficeKey,	
				   p.ClientKey,
				   p.ProjectKey,
		           e.MediaEstimateKey,
		           'Order',
		           'Interactive',
		           pod.PurchaseOrderDetailKey,
	               pod.DetailOrderDate,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               p.CampaignKey,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(case isnull(po.BillAt, 0) 
			           when 0 then isnull(BillableCost,0)
				       when 1 then isnull(PTotalCost,isnull(TotalCost,0))
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0),
				   pod.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		 inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           --left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
	               left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
		     where pod.InvoiceLineKey is null -- customer not yet billed
		       and isnull(pod.AppliedCost, 0) = 0  -- vendor has not invoiced
		       and po.Status = 4 -- PO approved
		       and po.POKind in (select POKind from #pokind) -- Interactive + we can add to it here
	           and p.CompanyKey = @CompanyKey -- limit to the user's company
	           and isnull(pod.OnHold,0) = 0
	           and (@OpenOrdersOnly = 0 or isnull(pod.Closed,0) = 0)
	     	   and p.Closed = 0 
			   and p.NonBillable = 0
			   
			   -- these 3 fields are the grouped keys on the summary grid 	
			   and isnull(p.ProjectKey, 0) = isnull(@ProjectKey, 0)
			   and isnull(e.MediaEstimateKey,0) = isnull(@MediaEstimateKey,0)
			   and isnull(po.MediaWorksheetKey,0) = isnull(@MediaWorksheetKey, 0)
				
				and (@CompanyMediaKey is null or po.CompanyMediaKey = @CompanyMediaKey)

			   AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)

	end

	-- get all IOs with vendor invoices for this company/project/estimate
    if @Invoice = 1	
	begin
	
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		           EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select case when @IOClientLink = 1 then p.GLCompanyKey else e.GLCompanyKey end,
		           case when @IOClientLink = 1 then p.OfficeKey else e.OfficeKey end,
		           case when @IOClientLink = 1 then p.ClientKey else e.ClientKey end,
		           p.ProjectKey,
		           e.MediaEstimateKey,
		           'Voucher',
		           'Voucher',
		           vd.VoucherDetailKey,
	               CASE @UseInvoicePostingDate WHEN 1 THEN v.PostingDate WHEN 2 THEN pod.DetailOrderDate ELSE v.InvoiceDate END,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               case when @IOClientLink = 1 then p.CampaignKey else e.CampaignKey end,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(vd.BillableCost,0),
				   vd.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		  inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		           inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		           --inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
		           --inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
                   left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
                   --left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
                   left outer join tTask t (nolock) on vd.TaskKey = t.TaskKey
		     where vd.InvoiceLineKey is null -- customer not yet billed
			       and vd.WriteOff = 0
		           and v.Status = 4 -- Voucher approved
		           and po.POKind = 1
			       and v.CompanyKey = @CompanyKey -- limit to the user's company

				   -- these 3 fields are the grouped keys on the summary grid 	
					and isnull(p.ProjectKey, 0) = isnull(@ProjectKey, 0)
					and isnull(e.MediaEstimateKey,0) = isnull(@MediaEstimateKey,0)
					and isnull(po.MediaWorksheetKey,0) = isnull(@MediaWorksheetKey, 0)
		
				and (
					(@IOClientLink = 1  and p.Closed = 0 and p.NonBillable = 0)
					or
					@IOClientLink <> 1
					)
	               and isnull(vd.OnHold,0) = 0
                   and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0)) 

				   and (@CompanyMediaKey is null or po.CompanyMediaKey = @CompanyMediaKey)
	               AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)

/*
	    if @IOClientLink = 1  -- through project
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		           EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select p.GLCompanyKey,
		           p.OfficeKey,
		           p.ClientKey,
		           p.ProjectKey,
		           e.MediaEstimateKey,
		           'Voucher',
		           'Voucher',
		           vd.VoucherDetailKey,
	               CASE @UseInvoicePostingDate WHEN 1 THEN v.PostingDate WHEN 2 THEN pod.DetailOrderDate ELSE v.InvoiceDate END,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               p.CampaignKey,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(vd.BillableCost,0),
				   vd.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		  inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		           inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		           --inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           inner join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
		           inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
                   left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
                   --left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
                   left outer join tTask t (nolock) on vd.TaskKey = t.TaskKey
		     where vd.InvoiceLineKey is null -- customer not yet billed
			       and vd.WriteOff = 0
		           and v.Status = 4 -- Voucher approved
		           and po.POKind = 1
			       and p.CompanyKey = @CompanyKey -- limit to the user's company
     	           and p.NonBillable = 0
	               and p.Closed = 0
	               and isnull(vd.OnHold,0) = 0
                   --and isnull(pod.Closed,0) = 0
                   and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0)) 
	               and (p.ProjectKey = @ProjectKey and isnull(e.MediaEstimateKey,0) = isnull(@MediaEstimateKey,0))
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)
				
		else  -- through media estimate
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		           EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select e.GLCompanyKey,
		           e.OfficeKey,
		           e.ClientKey,
		           p.ProjectKey,
		           e.MediaEstimateKey,
		           'Voucher',
		           'Voucher',
		           vd.VoucherDetailKey,
	               CASE @UseInvoicePostingDate WHEN 1 THEN v.PostingDate WHEN 2 THEN pod.DetailOrderDate ELSE v.InvoiceDate END,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               e.CampaignKey,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(vd.BillableCost,0),
				   vd.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		           inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
				   inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
		           inner join tCompany c (nolock) on e.ClientKey = c.CompanyKey
	       	       --left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
	               left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
	               --left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
				   left outer join tTask t (nolock) on vd.TaskKey = t.TaskKey
		     where vd.InvoiceLineKey is null -- customer not yet billed
		       and vd.WriteOff = 0
		       and v.Status = 4 -- PO approved
		       and po.POKind = 1
	           and e.CompanyKey = @CompanyKey -- limit to the user's company	
	           and isnull(vd.OnHold,0) = 0
	           --and isnull(pod.Closed,0) = 0
               and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0)) 
               and (e.MediaEstimateKey = @MediaEstimateKey and isnull(p.ProjectKey,0) = isnull(@ProjectKey,0))
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)
	*/
	end

	-- get all BCs with vendor invoices for this company/project/estimate
    if @Invoice = 1	
	begin
		insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		           EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select case when @BCClientLink = 1 then p.GLCompanyKey else e.GLCompanyKey end,
		           case when @BCClientLink = 1 then p.OfficeKey else e.OfficeKey end,
		           case when @BCClientLink = 1 then p.ClientKey else e.ClientKey end,
		           p.ProjectKey,
		           e.MediaEstimateKey,
		           'Voucher',
		           'Voucher',
		           vd.VoucherDetailKey,
	               CASE @UseInvoicePostingDate WHEN 1 THEN v.PostingDate WHEN 2 THEN pod.DetailOrderDate ELSE v.InvoiceDate END,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               case when @BCClientLink = 1 then p.CampaignKey else e.CampaignKey end,
	               m.MediaMarketKey,
	           po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(vd.BillableCost,0),
				   vd.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		           inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		           --inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
		           --inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
	               --left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
		           left outer join tTask t (nolock) on vd.TaskKey = t.TaskKey
		     where vd.InvoiceLineKey is null -- customer not yet billed
		       and vd.WriteOff = 0
		       and v.Status = 4 -- PO approved
		       and po.POKind = 2
	           and v.CompanyKey = @CompanyKey -- limit to the user's company
	
	
				-- these 3 fields are the grouped keys on the summary grid 	
			   and isnull(p.ProjectKey, 0) = isnull(@ProjectKey, 0)
			   and isnull(e.MediaEstimateKey,0) = isnull(@MediaEstimateKey,0)
			   and isnull(po.MediaWorksheetKey,0) = isnull(@MediaWorksheetKey, 0)
	
			  and (
					(@BCClientLink = 1  and p.Closed = 0 and p.NonBillable = 0)
					or
					@BCClientLink <> 1
					)
	           and isnull(vd.OnHold,0) = 0
	           and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0)) 	           
	           and (@CompanyMediaKey is null or po.CompanyMediaKey = @CompanyMediaKey)	
				AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)
		/*					           
	    if @BCClientLink = 1  -- through project
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		           EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select p.GLCompanyKey,
		           p.OfficeKey,
		           p.ClientKey,
		           p.ProjectKey,
		           e.MediaEstimateKey,
		           'Voucher',
		           'Voucher',
		           vd.VoucherDetailKey,
	               CASE @UseInvoicePostingDate WHEN 1 THEN v.PostingDate WHEN 2 THEN pod.DetailOrderDate ELSE v.InvoiceDate END,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               p.CampaignKey,
	               m.MediaMarketKey,
	           po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(vd.BillableCost,0),
				   vd.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		           inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		           --inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           inner join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
		           inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
	               --left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
		           left outer join tTask t (nolock) on vd.TaskKey = t.TaskKey
		     where vd.InvoiceLineKey is null -- customer not yet billed
		       and vd.WriteOff = 0
		       and v.Status = 4 -- PO approved
		       and po.POKind = 2
	           and p.CompanyKey = @CompanyKey -- limit to the user's company
	           and p.NonBillable = 0
	           and p.Closed = 0
	           and isnull(vd.OnHold,0) = 0
	           --and isnull(pod.Closed,0) = 0
               and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0)) 	           
	           and (p.ProjectKey = @ProjectKey and isnull(e.MediaEstimateKey,0) = isnull(@MediaEstimateKey,0))
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)

		else  -- through media estimate
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		     EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	    MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select e.GLCompanyKey,
		           e.OfficeKey,
		           e.ClientKey,
		           p.ProjectKey,
		           e.MediaEstimateKey,
		           'Voucher',
		           'Voucher',
		           vd.VoucherDetailKey,
	               CASE @UseInvoicePostingDate WHEN 1 THEN v.PostingDate WHEN 2 THEN pod.DetailOrderDate ELSE v.InvoiceDate END,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               e.CampaignKey,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(vd.BillableCost,0),
				   vd.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		           inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		           inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
				   inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
		           inner join tCompany c (nolock) on e.ClientKey = c.CompanyKey
	       	       --left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
	               left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
	               left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
	               --left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
		           left outer join tTask t (nolock) on vd.TaskKey = t.TaskKey
		     where vd.InvoiceLineKey is null -- customer not yet billed
		       and vd.WriteOff = 0
		       and v.Status = 4 -- PO approved
		       and po.POKind = 2
	           and e.CompanyKey = @CompanyKey -- limit to the user's company	
	           and isnull(vd.OnHold,0) = 0
	           --and isnull(pod.Closed,0) = 0
               and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0)) 
              and (e.MediaEstimateKey = @MediaEstimateKey and isnull(p.ProjectKey,0) = isnull(@ProjectKey,0))
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)
		*/
	end
	    
	 -- get all Interactive or other orders with vendor invoices for this company/project/estimate
    if @Invoice = 1	
	begin
	
		    insert #tMediaMassBillingDetail
				   (GLCompanyKey,
				   OfficeKey,
				   ClientKey,
                   ProjectKey,
                   MediaEstimateKey,				   
		           Entity,
		           EntityClass,
		           EntityKey,
				   EntityDate,
		           ClientDivisionKey,
		           ClientProductKey,
				   CampaignKey,
	               MediaMarketKey,
	               PurchaseOrderNumber,
	               TaskID,
		           UnbilledAmount,
				   CurrencyID,
				   CurrencyKey
				   )
		    select p.GLCompanyKey,
		           p.OfficeKey,
		           p.ClientKey,
		           p.ProjectKey,
		           e.MediaEstimateKey,
		           'Voucher',
		           'Voucher',
		           vd.VoucherDetailKey,
	               CASE @UseInvoicePostingDate WHEN 1 THEN v.PostingDate WHEN 2 THEN pod.DetailOrderDate ELSE v.InvoiceDate END,
	               p.ClientDivisionKey,
	               p.ClientProductKey,
	               p.CampaignKey,
	               m.MediaMarketKey,
	               po.PurchaseOrderNumber,
	               t.TaskID,
		           isnull(vd.BillableCost,0),
				   vd.PCurrencyID, -- if there is a project on the POD, it should come from the project
				   0 -- will be generated later
		      from tPurchaseOrderDetail pod (nolock) 
		  inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		           inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		           inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		           --inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		           left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
		           --inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		           left outer join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
                   left outer join tCompanyMedia m (nolock) on po.CompanyMediaKey = m.CompanyMediaKey
                   --left outer join tTask t (nolock) on pod.TaskKey = t.TaskKey
                   left outer join tTask t (nolock) on vd.TaskKey = t.TaskKey
		     where vd.InvoiceLineKey is null -- customer not yet billed
			       and vd.WriteOff = 0
		           and v.Status = 4 -- Voucher approved
		           and po.POKind in (4,5,6)
			       and p.CompanyKey = @CompanyKey -- limit to the user's company
     	           and p.NonBillable = 0
	               and p.Closed = 0
				   
				   -- these 3 fields are the grouped keys on the summary grid 	
					and isnull(p.ProjectKey, 0) = isnull(@ProjectKey, 0)
					and isnull(e.MediaEstimateKey,0) = isnull(@MediaEstimateKey,0)
					and isnull(po.MediaWorksheetKey,0) = isnull(@MediaWorksheetKey, 0)
				
	               and isnull(vd.OnHold,0) = 0
                   and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0)) 
	               
				   and (@CompanyMediaKey is null or po.CompanyMediaKey = @CompanyMediaKey)

				   AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)
			end     
				 
	-- delete rows not matching criteria
	if @IOBeginDate is not null
		delete #tMediaMassBillingDetail
         where EntityClass = 'IO'
           and EntityDate < @IOBeginDate

	if @IOEndDate is not null
		delete #tMediaMassBillingDetail
         where EntityClass = 'IO'
           and EntityDate > @IOEndDate

	if @BCBeginDate is not null
		delete #tMediaMassBillingDetail
         where EntityClass = 'BC'
           and EntityDate < @BCBeginDate

	if @BCEndDate is not null
		delete #tMediaMassBillingDetail
         where EntityClass = 'BC'
           and EntityDate > @BCEndDate

	if @InteractiveBeginDate is not null
		delete #tMediaMassBillingDetail
         where EntityClass = 'Interactive'
           and EntityDate < @InteractiveBeginDate

	if @InteractiveEndDate is not null
		delete #tMediaMassBillingDetail
         where EntityClass = 'Interactive'
           and EntityDate > @InteractiveEndDate

	if @InvoiceBeginDate is not null
		delete #tMediaMassBillingDetail
         where EntityClass = 'Voucher'
           and EntityDate < @InvoiceBeginDate

	if @InvoiceEndDate is not null
		delete #tMediaMassBillingDetail
         where EntityClass = 'Voucher'
           and EntityDate > @InvoiceEndDate

	if @ClientKey is not null
		delete #tMediaMassBillingDetail
         where isnull(ClientKey,0) <> @ClientKey

	if @ParentClientKey is not null
		delete #tMediaMassBillingDetail
        from tCompany c (nolock)
		where #tMediaMassBillingDetail.ClientKey = c.CompanyKey
		and  isnull(#tMediaMassBillingDetail.ClientKey,0) <> @ParentClientKey
		and isnull(c.ParentCompanyKey,0) <> @ParentClientKey

	if @ClientDivisionKey is not null
		delete #tMediaMassBillingDetail
         where isnull(ClientDivisionKey,0) <> @ClientDivisionKey
         
	if @ClientProductKey is not null
		delete #tMediaMassBillingDetail
         where isnull(ClientProductKey,0) <> @ClientProductKey
                  
	if @CampaignKey is not null
		delete #tMediaMassBillingDetail
         where isnull(CampaignKey,0) <> @CampaignKey		

	if @MediaMarketKey is not null
		delete #tMediaMassBillingDetail
         where isnull(MediaMarketKey,0) <> @MediaMarketKey		

	if @PurchaseOrderNumber is not null
		delete #tMediaMassBillingDetail
       where isnull(PurchaseOrderNumber,'') <> @PurchaseOrderNumber		

	if @TaskID is not null
		delete #tMediaMassBillingDetail
         where isnull(TaskID,'') <> @TaskID		

	--issue 129332
    --delete #tMediaMassBillingDetail Where UnbilledAmount = 0

		-- Make sure that we do not have NULL for GLCompanyKey and OfficeKey
		-- This info will be used in loops later
		UPDATE #tMediaMassBillingDetail 
		SET GLCompanyKey = 0
		WHERE GLCompanyKey IS NULL
		 
		UPDATE #tMediaMassBillingDetail 
		SET OfficeKey = 0 
		WHERE OfficeKey IS NULL
   
   	IF @GLCompanyKey >= 0
		DELETE #tMediaMassBillingDetail WHERE GLCompanyKey <> @GLCompanyKey 
		 
	IF @OfficeKey >= 0
		DELETE #tMediaMassBillingDetail WHERE OfficeKey <> @OfficeKey
GO
