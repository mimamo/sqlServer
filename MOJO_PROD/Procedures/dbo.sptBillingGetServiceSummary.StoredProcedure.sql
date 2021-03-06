USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGetServiceSummary]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGetServiceSummary]

	 @ProjectKey int
	,@BillingKey int

as -- Encrypt

  /*
  || When     Who Rel   What
  || 09/28/06 GHL 8.4   Added Mark as Billed column 
  || 05/15/07 GHL 8.422 Join with tBillingDetail.ServiceKey instead of tTime.ServiceKey
  ||                    more accurate when we edit labor       
  || 01/22/08 GHL 8.502 (18071) McClain had problems with 160 services or items
  ||                    Initial subquery taking too long
  ||                    Decided to use temp table then determine if services are involved and delete if not
  ||                    This limits the number of services before calculations         
  || 12/15/08 GHL 10.015 (41479) The billed columns should not include the invoice created with the WS                   
  */
		
declare @CompanyKey int, @InvoiceKey int
	              
	select @CompanyKey = CompanyKey
	  from   tProject (nolock)
	 where  ProjectKey = @ProjectKey
	
	select @InvoiceKey = InvoiceKey
	  from   tBilling (nolock)
	 where  BillingKey = @BillingKey
	select @InvoiceKey = isnull(@InvoiceKey, 0)
	
 CREATE TABLE #Summary (
   WorkTypeName VARCHAR(200) NULL
  ,WorkTypeKey INT NULL
  ,ServiceKey INT NULL
  ,Description VARCHAR(200) NULL
  
  ,BudgetHrs DECIMAL(24,4) NULL
  ,COHrs DECIMAL(24,4) NULL
  ,BudgetAmt MONEY NULL
  ,COAmt MONEY NULL
  
  ,ActHrs DECIMAL(24,4) NULL
  ,ActAmt MONEY NULL
  
  ,AmountBilled MONEY NULL
  ,AmountToBeBilled MONEY NULL
  ,AmountOnBW MONEY NULL
  ,AmountNotSelected MONEY NULL
  ,AmountMarkAsBilled MONEY NULL
  
  ,ActualExists int
  ,BudgetExists int
  ,InvoiceExists int
  ,BillingWorksheetExists int
  )
	
	
-- 1) Insert services

 INSERT #Summary (WorkTypeName, WorkTypeKey, ServiceKey, Description)
 select wt.WorkTypeName, s.WorkTypeKey, s.ServiceKey, s.ServiceCode + ' - ' + s.Description 
		from tService s (nolock)
			left outer join tWorkType wt (nolock) on s.WorkTypeKey = wt.WorkTypeKey 
		where s.CompanyKey = @CompanyKey
 
 INSERT #Summary (WorkTypeName, WorkTypeKey, ServiceKey, Description)
 select   '' as WorkTypeName
			,0 as WorkTypeKey
			,0 AS ServiceKey  -- -1 as ServiceKey Change later to -1 
			,'[No Service]' as Description

--2) determine if records exists for these services
	
 UPDATE #Summary SET ActualExists = 0, BudgetExists = 0, InvoiceExists = 0, BillingWorksheetExists = 0
 			
 UPDATE #Summary
 SET    #Summary.BudgetHrs = pe.Qty
		,#Summary.COHrs = pe.COQty
		,#Summary.BudgetAmt = pe.Gross
		,#Summary.COAmt = pe.COGross
		,#Summary.BudgetExists = 1
 FROM   tProjectEstByItem pe (nolock) 
			where pe.ProjectKey = @ProjectKey   
			and isnull(pe.EntityKey, 0) = #Summary.ServiceKey
			and pe.Entity = 'tService'  
			
UPDATE #Summary
SET    #Summary.ActualExists = 1 
from tTime ti (nolock) 
where ti.ProjectKey = @ProjectKey
and isnull(ti.ServiceKey, 0) = #Summary.ServiceKey
and isnull(ti.ActualRate, 0) + isnull(ti.BilledRate, 0) <> 0 -- only interested if we are billing

UPDATE #Summary
SET    #Summary.InvoiceExists = 1 
from tInvoice i (nolock)
	INNER JOIN tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey 
where il.ProjectKey = @ProjectKey
and   ISNULL(il.Entity, '') in ( '',  'tService')	
				and   ISNULL(il.EntityKey, 0) = #Summary.ServiceKey 
				and i.AdvanceBill = 0
				and il.BillFrom = 1			-- Fixed Fee 


UPDATE #Summary
SET    #Summary.BillingWorksheetExists = 1 
from tBillingDetail bd (nolock) 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity = 'tTime' 
			     and ISNULL(bd.ServiceKey, 0) = #Summary.ServiceKey

-- can delete if nothing there			
DELETE #Summary WHERE ActualExists + BudgetExists + InvoiceExists + BillingWorksheetExists = 0

-- 3)perform calcs on limited services 

UPDATE #Summary
SET    #Summary.ActHrs = isnull((select sum(ti.ActualHours) 
			from tTime ti (nolock) 
			where ti.ProjectKey = @ProjectKey
			and isnull(ti.ServiceKey, 0) = #Summary.ServiceKey), 0) 
			

UPDATE #Summary
SET    #Summary.ActAmt =			
			isnull((select sum(round(ti.ActualHours * ti.ActualRate, 2)) 
			from tTime ti (nolock) 
			where ti.ProjectKey = @ProjectKey
			and isnull(ti.ServiceKey, 0) = #Summary.ServiceKey), 0) 

UPDATE #Summary
SET    #Summary.AmountBilled =			
			isnull((select sum(round(BilledHours * BilledRate, 2)) 
			    from tTime ti (nolock)
			    inner join tInvoiceLine il (nolock) on ti.InvoiceLineKey = il.InvoiceLineKey  
			   where ti.ProjectKey = @ProjectKey 
			     --and InvoiceLineKey > 0
			     and il.InvoiceKey <> @InvoiceKey
			     and isnull(ti.ServiceKey, 0) = #Summary.ServiceKey),0)
			+ isnull((select sum(il.TotalAmount) 
				from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
				where il.ProjectKey = @ProjectKey 
				and   ISNULL(il.Entity, '') in ( '',  'tService')	
				and   ISNULL(il.EntityKey, 0) = #Summary.ServiceKey 
				and invc.AdvanceBill = 0
				and invc.InvoiceKey <> @InvoiceKey
				and il.BillFrom = 1			-- Fixed Fee
				), 0) 
	
UPDATE #Summary
SET    #Summary.AmountToBeBilled =				
			isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity = 'tTime' 
			     and Action = 1
			     and ISNULL(bd.ServiceKey, 0) = #Summary.ServiceKey), 0)  			
						
			
UPDATE #Summary
SET    #Summary.AmountOnBW =				
				(select sum(Total) 
			    from tBillingDetail bd (nolock) 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity = 'tTime' 
			     and ISNULL(bd.ServiceKey, 0) = #Summary.ServiceKey)

UPDATE #Summary
SET    #Summary.AmountNotSelected =				
	isnull((select sum(BillableCost) 
				   from vBillingItemSelect 
				  where vBillingItemSelect.ProjectKey = @ProjectKey
				  and   ISNULL(vBillingItemSelect.ItemKey, 0) = #Summary.ServiceKey -- ItemKey = tTime.ServiceKey = NULL??
				  and   vBillingItemSelect.Type = 'LABOR' 
				), 0) 


UPDATE #Summary
SET    #Summary.AmountMarkAsBilled =	
			isnull((select sum(round(BilledHours * BilledRate, 2)) 
			    from tTime ti (nolock) 
			   where ti.ProjectKey = @ProjectKey 
			     and InvoiceLineKey = 0
			     and isnull(ti.ServiceKey, 0) = #Summary.ServiceKey),0)
			     
UPDATE #Summary
SET  BudgetHrs = ISNULL(BudgetHrs, 0)
  ,COHrs = ISNULL(COHrs, 0)
  ,BudgetAmt = ISNULL(BudgetAmt, 0)
  ,COAmt = ISNULL(COAmt, 0)
  
  ,ActHrs = ISNULL(ActHrs, 0)
  ,ActAmt = ISNULL(ActAmt, 0)
  
  ,AmountBilled = ISNULL(AmountBilled, 0)
  ,AmountToBeBilled = ISNULL(AmountToBeBilled, 0)
  ,AmountOnBW = ISNULL(AmountOnBW, 0)
  ,AmountNotSelected = ISNULL(AmountNotSelected, 0)
  ,AmountMarkAsBilled = ISNULL(AmountMarkAsBilled, 0)

-- Correct for the UI
UPDATE #Summary
SET    ServiceKey = -1
WHERE  ServiceKey = 0

SELECT * FROM #Summary
			     		     			
RETURN 1
 
/* 
	select   isnull(wt.WorkTypeName, '')  as WorkTypeName
			,isnull(s.WorkTypeKey, 0) as WorkTypeKey
			,s.ServiceKey 
			,s.Description
			,isnull((select pe.Qty  
			from tProjectEstByItem pe (nolock) 
			where pe.ProjectKey = @ProjectKey   
			and isnull(pe.EntityKey, 0) = s.ServiceKey
			and pe.Entity = 'tService'  
			), 0) as BudgetHrs
			
			,isnull((select pe.COQty  
			from tProjectEstByItem pe (nolock) 
			where pe.ProjectKey = @ProjectKey   
			and isnull(pe.EntityKey, 0) = s.ServiceKey
			and pe.Entity = 'tService'  
			), 0) as COHrs

			,isnull((select sum(ti.ActualHours) 
			from tTime ti (nolock) 
			where ti.ProjectKey = @ProjectKey
			and isnull(ti.ServiceKey, 0) = s.ServiceKey), 0) as ActHrs
			
			,isnull((select pe.Gross  
			from tProjectEstByItem pe (nolock) 
			where pe.ProjectKey = @ProjectKey   
			and isnull(pe.EntityKey, 0) = s.ServiceKey
			and pe.Entity = 'tService'  
			), 0) as BudgetAmt

			,isnull((select pe.COGross  
			from tProjectEstByItem pe (nolock) 
			where pe.ProjectKey = @ProjectKey   
			and isnull(pe.EntityKey, 0) = s.ServiceKey
			and pe.Entity = 'tService'  
			), 0) as COAmt
			
			,isnull((select sum(round(ti.ActualHours * ti.ActualRate, 2)) 
			from tTime ti (nolock) 
			where ti.ProjectKey = @ProjectKey
			and isnull(ti.ServiceKey, 0) = s.ServiceKey), 0) as ActAmt

			,isnull((select sum(round(BilledHours * BilledRate, 2)) 
			    from tTime ti (nolock) 
			   where ti.ProjectKey = @ProjectKey 
			     and InvoiceLineKey > 0
			     and isnull(ti.ServiceKey, 0) = s.ServiceKey),0)
			+ isnull((select sum(il.TotalAmount) 
				from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
				where il.ProjectKey = @ProjectKey 
				and   ISNULL(il.Entity, '') in ( '',  'tService')	
				and   ISNULL(il.EntityKey, 0) = s.ServiceKey 
				and invc.AdvanceBill = 0
				and il.BillFrom = 1			-- Fixed Fee
				), 0) 
				as AmountBilled			

			,isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity = 'tTime' 
			     and Action = 1
			     and bd.ServiceKey = s.ServiceKey), 0) as AmountToBeBilled 			
			
			,(select sum(Total) 
			    from tBillingDetail bd (nolock) 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity = 'tTime' 
			     and bd.ServiceKey = s.ServiceKey) as AmountOnBW 
			    						 			
			,isnull((select sum(BillableCost) 
				   from vBillingItemSelect 
				  where vBillingItemSelect.ProjectKey = @ProjectKey
				  and   ISNULL(vBillingItemSelect.ItemKey, 0) = s.ServiceKey -- ItemKey = tTime.ServiceKey = NULL??
				  and   vBillingItemSelect.Type = 'LABOR' 
				), 0) as AmountNotSelected

			,isnull((select sum(round(BilledHours * BilledRate, 2)) 
			    from tTime ti (nolock) 
			   where ti.ProjectKey = @ProjectKey 
			     and InvoiceLineKey = 0
			     and isnull(ti.ServiceKey, 0) = s.ServiceKey),0)
			    as AmountMarkAsBilled 
	  from		
		(
		select ServiceKey
			  ,ServiceCode + ' - ' + Description as Description
			  ,WorkTypeKey
		from tService (nolock)
		where CompanyKey = @CompanyKey
		
		) as s 
		left outer join tWorkType wt (nolock) ON s.WorkTypeKey = wt.WorkTypeKey

	union all
	
	select   '' as WorkTypeName
			,0 as WorkTypeKey
			,-1 as ServiceKey 
			,'[No Service]' as Description
			,isnull((select pe.Qty  
			from tProjectEstByItem pe (nolock) 
			where pe.ProjectKey = @ProjectKey   
			and isnull(pe.EntityKey, 0) = 0
			and pe.Entity = 'tService'  
			), 0) as BudgetHrs
			
			,isnull((select pe.COQty  
			from tProjectEstByItem pe (nolock) 
			where pe.ProjectKey = @ProjectKey   
			and isnull(pe.EntityKey, 0) = 0
			and pe.Entity = 'tService'  
			), 0) as COHrs
			
			,isnull((select sum(ti.ActualHours) 
			from tTime ti (nolock) 
			where ti.ProjectKey = @ProjectKey
			and ISNULL(ti.ServiceKey, 0) = 0),0) as ActHrs
			
			,isnull((select pe.Gross  
			from tProjectEstByItem pe (nolock) 
			where pe.ProjectKey = @ProjectKey   
			and isnull(pe.EntityKey, 0) = 0
			and pe.Entity = 'tService'  
			), 0) as BudgetAmt

			,isnull((select pe.COGross  
			from tProjectEstByItem pe (nolock) 
			where pe.ProjectKey = @ProjectKey   
			and isnull(pe.EntityKey, 0) = 0
			and pe.Entity = 'tService'  
			), 0) as COAmt		
				
			,isnull((select sum(ROUND(ti.ActualHours * ti.ActualRate, 2)) 
			from tTime ti (nolock) 
			where ti.ProjectKey = @ProjectKey
			and ISNULL(ti.ServiceKey, 0) = 0),0) as ActAmt
			
			,isnull((select sum(round(BilledHours * BilledRate, 2)) 
			    from tTime ti (nolock) 
			   where ti.ProjectKey = @ProjectKey 
			     and InvoiceLineKey > 0
			     and isnull(ti.ServiceKey, 0) = 0),0)
			+
			isnull((select sum(il.TotalAmount) 
			from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
			where il.ProjectKey = @ProjectKey 
			and   ISNULL(il.Entity, '') in ('', 'tService') -- include billed for tasks without service	
			and   ISNULL(il.EntityKey, 0) = 0
			and   il.BillFrom = 1 -- Fixed Fee 
			and invc.AdvanceBill = 0), 0) 
			as AmountBilled
			
			,isnull((select sum(Total) 
			    from tBillingDetail bd (nolock)
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity = 'tTime' 
			     and Action = 1
			     and ISNULL(bd.ServiceKey, 0) = 0), 0) as AmountToBeBilled 			
			
			,(select sum(Total) 
			    from tBillingDetail bd (nolock) 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity = 'tTime' 
			     and ISNULL(bd.ServiceKey, 0) = 0) as AmountOnBW 
			          						 			
			,isnull((select sum(BillableCost) 
				   from vBillingItemSelect 
				  where vBillingItemSelect.ProjectKey = @ProjectKey
				  and   ISNULL(vBillingItemSelect.ItemKey, 0) = 0 -- ItemKey is ServiceKey
				  and vBillingItemSelect.Type = 'LABOR' 
				), 0) as AmountNotSelected
					
			,isnull((select sum(round(BilledHours * BilledRate, 2)) 
			    from tTime ti (nolock) 
			   where ti.ProjectKey = @ProjectKey 
			     and InvoiceLineKey = 0
			     and isnull(ti.ServiceKey, 0) = 0),0)
			
			 as AmountMarkAsBilled			
			       	
	return 1 
*/
GO
