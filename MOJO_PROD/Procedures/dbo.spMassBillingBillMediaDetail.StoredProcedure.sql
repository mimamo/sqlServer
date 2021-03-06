USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spMassBillingBillMediaDetail]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spMassBillingBillMediaDetail]
 	 @UserKey int,
	 @Entity varchar(10),
	 @EntityKey int,
     @OpenOrdersOnlyOnInvoices int = 0,
	 @OpenOrdersOnly int = 1

AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/03/07 GHL 8.5   Added logic for GLCompanyKey and OfficeKey   
  || 10/18/07 GHL 8.438   (14701) Removed restrictions on vouchers with po closed
  || 12/20/07 GHL 8.5     (17723) Added restrictions on vouchers with po closed because another customer complained
  ||                       Using now a parameter to determine this
  || 01/24/08 GHL 8.502   (19677) Nerland. Changed Project on invoices from pod.ProjectKey to v.ProjectKey    
  || 10/04/13 GHL 10.573 Added support for multi currency 
  || 09/04/14 GHL 10.584  (228260) Added param @OpenOrdersOnly for new media screen
  ||                      Must be able to bill closed orders
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
	
	-- get company key
	select @CompanyKey = isnull(OwnerCompanyKey,CompanyKey)
	  from tUser (nolock)
	 where UserKey = @UserKey   
 
	-- get client link settings, default to 'through project'
	select @IOClientLink = isnull(IOClientLink,1),
           @BCClientLink = isnull(BCClientLink,1)
      from tPreference (nolock)
     where CompanyKey = @CompanyKey

	-- get all IO
	if @Entity = 'IO' 
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
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0))
					  end ,0),
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
	           and isnull(pod.OnHold,0) = 0
	           and (@OpenOrdersOnly = 0 or isnull(pod.Closed,0) = 0)
	           and pod.PurchaseOrderDetailKey = @EntityKey
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
				       when 1 then isnull(PTotalCost,isnull(TotalCost, 0))
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost, 0)) 
					end ,0),
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
               and (@OpenOrdersOnly = 0 or isnull(pod.Closed,0) = 0)
	           and pod.PurchaseOrderDetailKey = @EntityKey
				AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)	           

	-- get the BC
    if @Entity = 'BC'	
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
				       when 1 then isnull(PTotalCost,isnull(TotalCost, 0))
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost, 0)) 
					   end ,0),
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
	           and isnull(pod.OnHold,0) = 0
	           and (@OpenOrdersOnly = 0 or isnull(pod.Closed,0) = 0)
	           and pod.PurchaseOrderDetailKey = @EntityKey
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
				       when 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) 
					end ,0),
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
	           and (@OpenOrdersOnly = 0 or isnull(pod.Closed,0) = 0)
	           and pod.PurchaseOrderDetailKey = @EntityKey
				AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey 
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)	           


	-- get all IOs with vendor invoices for this company/project/estimate
    if @Entity = 'Invoice'	
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
	               v.InvoiceDate,
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
		           and v.Status = 4 -- Voucher approved
		           and po.POKind = 1
			       and p.CompanyKey = @CompanyKey -- limit to the user's company
	               and isnull(vd.OnHold,0) = 0
                   and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0)) 
	               and vd.VoucherDetailKey = @EntityKey
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
	               v.InvoiceDate,
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
		       and v.Status = 4 -- PO approved
		       and po.POKind = 1
	           and e.CompanyKey = @CompanyKey -- limit to the user's company	
	           and isnull(vd.OnHold,0) = 0
	           and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0)) 
	           and vd.VoucherDetailKey = @EntityKey
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)


	-- get all BCs with vendor invoices for this company/project/estimate
    if @Entity = 'Invoice'	
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
	               v.InvoiceDate,
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
		       and v.Status = 4 -- PO approved
		       and po.POKind = 2
	     and p.CompanyKey = @CompanyKey -- limit to the user's company
	           and isnull(vd.OnHold,0) = 0
	           and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0)) 
				and vd.VoucherDetailKey = @EntityKey
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
	               v.InvoiceDate,
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
		       and v.Status = 4 -- PO approved
		       and po.POKind = 2
	           and e.CompanyKey = @CompanyKey -- limit to the user's company	
	           and isnull(vd.OnHold,0) = 0
	           and (@OpenOrdersOnlyOnInvoices = 0 or (@OpenOrdersOnlyOnInvoices = 1 and isnull(pod.Closed,0) = 0)) 
			   and vd.VoucherDetailKey = @EntityKey
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5		
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)
	    
	      	 
		-- Make sure that we do not have NULL for GLCompanyKey and OfficeKey
		-- This info will be used in loops later
		UPDATE #tMediaMassBillingDetail 
		SET GLCompanyKey = 0
		WHERE GLCompanyKey IS NULL
		 
		UPDATE #tMediaMassBillingDetail 
		SET OfficeKey = 0 
		WHERE OfficeKey IS NULL
GO
