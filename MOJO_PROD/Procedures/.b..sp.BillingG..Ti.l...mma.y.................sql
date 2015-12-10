USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGetTitleSummary]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGetTitleSummary]

	 @ProjectKey int
	,@BillingKey int

as -- Encrypt

  /*
  || When     Who Rel   What
  || 09/28/06 GHL 8.4   Added Mark as Billed column 
  || 05/15/07 GHL 8.422 Join with tBillingDetail.TitleKey instead of tTime.TitleKey
  ||                    more accurate when we edit labor       
  || 01/22/08 GHL 8.502 (18071) McClain had problems with 160 Titles or items
  ||                    Initial subquery taking too long
  ||                    Decided to use temp table then determine if Titles are involved and delete if not
  ||                    This limits the number of Titles before calculations         
  || 12/15/08 GHL 10.015 (41479) The billed columns should not include the invoice created with the WS  
  || 11/13/14 GHL 10.586 Creation by cloning sptBillingGetTitleSummary                 
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
  ,TitleKey INT NULL
  ,Description VARCHAR(500) NULL
  
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

-- in tBillingDetail we do not have a TitleKey, get it now
create table #billingdetail (TimeKey uniqueidentifier  null, TitleKey int null, Total money null, Action int null)
insert #billingdetail (TimeKey, Total, Action)
select EntityGuid, Total, Action 
from tBillingDetail (nolock) where BillingKey = @BillingKey and Entity = 'tTime'

update 	#billingdetail
set     #billingdetail.TitleKey = t.TitleKey
from    tTime t (nolock)
where   #billingdetail.TimeKey = t.TimeKey 
	
update 	#billingdetail
set     #billingdetail.TitleKey = isnull(#billingdetail.TitleKey, 0)

-- 1) Insert Titles

 INSERT #Summary (WorkTypeName, WorkTypeKey, TitleKey, Description)
 select wt.WorkTypeName, s.WorkTypeKey, s.TitleKey, s.TitleID + ' - ' + s.TitleName 
		from tTitle s (nolock)
			left outer join tWorkType wt (nolock) on s.WorkTypeKey = wt.WorkTypeKey 
		where s.CompanyKey = @CompanyKey
 
 INSERT #Summary (WorkTypeName, WorkTypeKey, TitleKey, Description)
 select   '' as WorkTypeName
			,0 as WorkTypeKey
			,0 AS TitleKey  -- -1 as TitleKey Change later to -1 
			,'[No Title]' as Description

--2) determine if records exists for these Titles
	
 UPDATE #Summary SET ActualExists = 0, BudgetExists = 0, InvoiceExists = 0, BillingWorksheetExists = 0
 			
 UPDATE #Summary
 SET    #Summary.BudgetHrs = pe.Qty
		,#Summary.COHrs = pe.COQty
		,#Summary.BudgetAmt = pe.Gross
		,#Summary.COAmt = pe.COGross
		,#Summary.BudgetExists = 1
 FROM   tProjectEstByTitle pe (nolock) 
			where pe.ProjectKey = @ProjectKey   
			and isnull(pe.TitleKey, 0) = #Summary.TitleKey
			and isnull(pe.TitleKey, 0) > 0 -- filterout TitleKey = 0, they are expenses in tProjectEstByTitle  
			
UPDATE #Summary
SET    #Summary.ActualExists = 1 
from tTime ti (nolock) 
where ti.ProjectKey = @ProjectKey
and isnull(ti.TitleKey, 0) = #Summary.TitleKey
and isnull(ti.ActualRate, 0) + isnull(ti.BilledRate, 0) <> 0 -- only interested if we are billing

/* At this time, we do not have FF invoices by Title
UPDATE #Summary
SET    #Summary.InvoiceExists = 1 
from tInvoice i (nolock)
	INNER JOIN tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey 
where il.ProjectKey = @ProjectKey
and   ISNULL(il.Entity, '') in ( '',  'tTitle')	
				and   ISNULL(il.EntityKey, 0) = #Summary.TitleKey 
				and i.AdvanceBill = 0
				and il.BillFrom = 1			-- Fixed Fee 
*/

UPDATE #Summary
SET    #Summary.BillingWorksheetExists = 1 
from #billingdetail bd (nolock) 
where ISNULL(bd.TitleKey, 0) = #Summary.TitleKey

-- can delete if nothing there			
DELETE #Summary WHERE ActualExists + BudgetExists + InvoiceExists + BillingWorksheetExists = 0

-- 3)perform calcs on limited Titles 

UPDATE #Summary
SET    #Summary.ActHrs = isnull((select sum(ti.ActualHours) 
			from tTime ti (nolock) 
			where ti.ProjectKey = @ProjectKey
			and isnull(ti.TitleKey, 0) = #Summary.TitleKey), 0) 
			

UPDATE #Summary
SET    #Summary.ActAmt =			
			isnull((select sum(round(ti.ActualHours * ti.ActualRate, 2)) 
			from tTime ti (nolock) 
			where ti.ProjectKey = @ProjectKey
			and isnull(ti.TitleKey, 0) = #Summary.TitleKey), 0) 

UPDATE #Summary
SET    #Summary.AmountBilled =			
			isnull((select sum(round(ti.BilledHours * ti.BilledRate, 2)) 
			    from tTime ti (nolock)
			    inner join tInvoiceSummaryTitle il (nolock) on ti.InvoiceLineKey = il.InvoiceLineKey  
			   where ti.ProjectKey = @ProjectKey 
			     and il.InvoiceKey <> @InvoiceKey
			     and isnull(ti.TitleKey, 0) = #Summary.TitleKey),0)
			/* no FF billing yet
			+ isnull((select sum(il.TotalAmount) 
				from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
				where il.ProjectKey = @ProjectKey 
				and   ISNULL(il.Entity, '') in ( '',  'tTitle')	
				and   ISNULL(il.EntityKey, 0) = #Summary.TitleKey 
				and invc.AdvanceBill = 0
				and invc.InvoiceKey <> @InvoiceKey
				and il.BillFrom = 1			-- Fixed Fee
				), 0) 
			*/

UPDATE #Summary
SET    #Summary.AmountToBeBilled =				
			isnull((select sum(Total) 
			    from #billingdetail bd (nolock) 
		       where Action = 1
			     and ISNULL(bd.TitleKey, 0) = #Summary.TitleKey), 0)  			
						
			
UPDATE #Summary
SET    #Summary.AmountOnBW =				
				(select sum(Total) 
			    from #billingdetail bd (nolock) 
		       where ISNULL(bd.TitleKey, 0) = #Summary.TitleKey)

UPDATE #Summary
SET    #Summary.AmountNotSelected =				
	isnull((select sum(BillableCost) 
				   from vBillingItemSelect 
				  where vBillingItemSelect.ProjectKey = @ProjectKey
				  and   ISNULL(vBillingItemSelect.TitleKey, 0) = #Summary.TitleKey 
				  and   vBillingItemSelect.Type = 'LABOR' 
				), 0) 


UPDATE #Summary
SET    #Summary.AmountMarkAsBilled =	
			isnull((select sum(round(BilledHours * BilledRate, 2)) 
			    from tTime ti (nolock) 
			   where ti.ProjectKey = @ProjectKey 
			     and InvoiceLineKey = 0
			     and isnull(ti.TitleKey, 0) = #Summary.TitleKey),0)
			     
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
SET    TitleKey = -1
WHERE  TitleKey = 0

SELECT * FROM #Summary
			     		     			
RETURN 1
GO
