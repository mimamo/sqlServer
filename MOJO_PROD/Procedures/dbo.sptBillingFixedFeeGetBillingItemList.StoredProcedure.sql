USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingFixedFeeGetBillingItemList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingFixedFeeGetBillingItemList]
	(
		@BillingKey int,
		@ProjectKey int
	)
AS --Encrypt

  SET NOCOUNT ON
		
  /*
  || When     Who Rel   What
  || 09/27/06 GHL 8.4   Creation for fixed fee billing per Billing Item 
  || 07/09/07 GHL 8.5   Added restriction on ER
  || 07/10/07 QMD 8.5   Expense Type reference changed to tItem             
  || 01/31/08 GHL 8.5   (20123) Using now invoice summary rather project cost view
  || 07/15/09 GHL 10.505 (56484) Added support of the [No Billing Item] line
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
  */

/*
There is a zero bucket when no billing items cannot be found
So we have a Union All to include the zero bucket
Calculation of estimate amounts:

1) For EstType > 1 
---------------

Expenses
--------
Link through tItem.WorkTypeKey
tEstimateTaskExpense.ItemKey is NEVER NULL
Filter out tEstimate.EstType > 1 since we may also have records in there for By Task only
but there are rolled up to tEstimateTask

tEstimateTaskExpense = WorkTypeKey buckets (when tItem.WorkTypeKey is not null) 
						+ zero bucket (when tItem.WorkTypeKey is null)
	
Labor
-----
Link through tService.WorkTypeKey
tEstimateTaskExpense.ServiceKey MAY BE NULL

tEstimateTaskLabor = BillingItem buckets (when ServiceKey is not null and tService.WorkTypeKey not null)
						+ zero bucket (when ServiceKey is null or tService.WorkTypeKey null)

2) EstType = 1
--------------
Link through tTask.WorkTypeKey
tEstimateTask.TaskKey IS NEVER NULL

Use tEstimateTask only

*/
	DECLARE @CompanyKey INT
	       
	SELECT @CompanyKey = CompanyKey
	FROM   tProject (NOLOCK)
	WHERE  ProjectKey = @ProjectKey
	
	SELECT wt.WorkTypeKey
	      ,wt.WorkTypeID
	      ,wt.WorkTypeName
	      ,ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType > 1  
			and isnull(i.WorkTypeKey, 0) = wt.WorkTypeKey), 0)
					
		+ ISNULL((Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
				inner join tTask t (nolock) on et.TaskKey = t.TaskKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType = 1  
			and isnull(t.WorkTypeKey, 0) = wt.WorkTypeKey), 0) 
			
		As EstExpenses
		
		, ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
				inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey 
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType > 1 
			and isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey), 0)
			
		+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
				inner join tTask t (nolock) on et.TaskKey = t.TaskKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType = 1 
			and isnull(t.WorkTypeKey, 0) = wt.WorkTypeKey), 0)
			
		As EstLabor
	
		, ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
				inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey 
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType > 1 
			and isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey), 0)
			
		+ ISNULL((Select Sum(et.Hours)
			from tEstimateTask et  (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
				inner join tTask t (nolock) on et.TaskKey = t.TaskKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType = 1 
			and isnull(t.WorkTypeKey, 0) = wt.WorkTypeKey), 0)
			
		As EstHours
		
		,ISNULL((select sum(ti.ActualHours) 
			from tTime ti (nolock)
				inner join tService s (nolock) on ti.ServiceKey = s.ServiceKey 
			Where ti.ProjectKey = @ProjectKey
			and   isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey
			), 0) 
			
		As ActHours
	
		,ISNULL((select SUM(ROUND(ti.ActualHours * ti.ActualRate, 2)) 
			from tTime ti (nolock)
				inner join tService s (nolock) on ti.ServiceKey = s.ServiceKey 
			Where ti.ProjectKey = @ProjectKey
			and   isnull(s.WorkTypeKey, 0) = wt.WorkTypeKey
			), 0) 
			
		As ActLabor

		,ISNULL((Select SUM(pod.TotalCost - ISNULL(pod.AppliedCost, 0)) 
			from tPurchaseOrderDetail pod (nolock) 
			inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
			inner join tItem i (nolock) on pod.ItemKey = i.ItemKey
			where po.Closed = 0
			and   pod.ProjectKey = @ProjectKey
			and   isnull(i.WorkTypeKey, 0) = wt.WorkTypeKey
			), 0) 		
	
		AS OpenPOAmt
			
		, ISNULL((Select SUM(vd.BillableCost) 
			from tVoucherDetail vd (nolock)
				inner join tItem i (nolock) on vd.ItemKey = i.ItemKey
			where vd.ProjectKey = @ProjectKey
			and   isnull(i.WorkTypeKey, 0) = wt.WorkTypeKey
			), 0)
		
		+ ISNULL((Select SUM(mc.BillableCost) 
			from tMiscCost mc (nolock)
				inner join tItem i (nolock) on mc.ItemKey = i.ItemKey  
			where mc.ProjectKey = @ProjectKey
			and  isnull(i.WorkTypeKey, 0) = wt.WorkTypeKey
			), 0)	
			
		+ ISNULL((Select SUM(er.BillableCost) 
			from tExpenseReceipt er (nolock)
				inner join tItem i (nolock) on er.ItemKey = i.ItemKey
			where er.ProjectKey = @ProjectKey
			and   ISNULL(i.WorkTypeKey, 0) = wt.WorkTypeKey
			and   er.VoucherDetailKey IS NULL
			), 0)	
			
		As ActExpenses

		,ISNULL((Select Sum(il.TotalAmount) 
		 from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
	     Where il.ProjectKey = @ProjectKey 
	     And   ISNULL(il.WorkTypeKey, 0) = wt.WorkTypeKey 
	     And   invc.AdvanceBill = 0
	     And   il.BillFrom = 1				-- Fixed Fee Only
	     ), 0)
	     
	    + ISNULL((SELECT Sum(isum.Amount) 
		from tInvoiceSummary isum (NOLOCK)
		inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
		inner join tInvoiceLine il (NOLOCK) on isum.InvoiceLineKey = il.InvoiceLineKey
		inner join tService s (NOLOCK) ON isum.EntityKey = s.ServiceKey
		WHERE isum.ProjectKey = @ProjectKey
		AND   inv.AdvanceBill = 0
		And   il.BillFrom = 2
		AND   isum.Entity = 'tService'
		AND   ISNULL(s.WorkTypeKey, 0) = wt.WorkTypeKey 
		), 0)
		 
		+ ISNULL((SELECT Sum(isum.Amount) 
		from tInvoiceSummary isum (NOLOCK)
		inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
		inner join tInvoiceLine il (NOLOCK) on isum.InvoiceLineKey = il.InvoiceLineKey
		inner join tItem i (NOLOCK) ON isum.EntityKey = i.ItemKey
		WHERE isum.ProjectKey = @ProjectKey
		AND   inv.AdvanceBill = 0
		And   il.BillFrom = 2
		AND   isum.Entity = 'tItem'
		AND   ISNULL(i.WorkTypeKey, 0) = wt.WorkTypeKey 
		), 0)
		
		as AmountBilled
		
		/*
		,ISNULL((Select Sum(il.TotalAmount) 
		 from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
	     Where il.ProjectKey = @ProjectKey 
	     And   ISNULL(il.WorkTypeKey, 0) = wt.WorkTypeKey 
	     And   invc.AdvanceBill = 0
	     And   il.BillFrom = 1				-- Fixed Fee Only
	     ), 0)
	     +
	     ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
				LEFT OUTER JOIN tItem (nolock) on ProjectCosts.ItemKey = tItem.ItemKey
			 WHERE ProjectCosts.ProjectKey = @ProjectKey
			 AND   ISNULL(tItem.WorkTypeKey, 0) = wt.WorkTypeKey
			 AND   ProjectCosts.Type IN ('MISCCOST', 'VOUCHER', 'ORDER') 
			 AND   ProjectCosts.InvoiceLineKey >0), 0) -- Detail  
		 +
		 ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
				LEFT OUTER JOIN tItem (nolock) on ProjectCosts.ItemKey = tItem.ItemKey
			 WHERE ProjectCosts.ProjectKey = @ProjectKey
			 AND   ISNULL(tItem.WorkTypeKey, 0) = wt.WorkTypeKey
			 AND   ProjectCosts.Type IN ('EXPRPT') 
			 AND   ProjectCosts.InvoiceLineKey >0), 0) -- Detail 
                 +
		 ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
				LEFT OUTER JOIN tService (nolock) on ProjectCosts.ItemKey = tService.ServiceKey
			 WHERE ProjectCosts.ProjectKey = @ProjectKey
			 AND   ISNULL(tService.WorkTypeKey, 0) = wt.WorkTypeKey
			 AND   ProjectCosts.Type IN ('LABOR') 
			 AND   ProjectCosts.InvoiceLineKey >0), 0) -- Detail 
			 
		AS AmountBilled
		*/
		
		,0 As AllEstimatesAmountBilled
	   
	   ,0 As InvoiceLineKey
	   ,ISNULL((Select sum(Percentage) from tBillingFixedFee Where Entity = 'tWorkType' and EntityKey = wt.WorkTypeKey and BillingKey = @BillingKey), 0) as InvoiceLinePercent
	   ,ISNULL((Select sum(Amount) from tBillingFixedFee Where Entity = 'tWorkType' and EntityKey = wt.WorkTypeKey and BillingKey = @BillingKey), 0) as InvoiceLineAmount
       ,Cast(0 as Money) As RemainingInv

	FROM tWorkType wt (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	
	UNION ALL
	
	SELECT 0 AS WorkTypeKey 
		  ,'[No Billing Item]' AS WorkTypeID 
		  ,'[No Billing Item]' AS WorkTypeName
		  ,ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) 
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				left outer join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType > 1  
			and isnull(i.WorkTypeKey, 0) = 0), 0)
		
		+ ISNULL((Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
				inner join tTask t (nolock) on et.TaskKey = t.TaskKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType = 1  
			and isnull(t.WorkTypeKey, 0) = 0), 0) As EstExpenses
			
		, ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
				left outer join tService s (nolock) on etl.ServiceKey = s.ServiceKey 
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType > 1 
			and (isnull(etl.ServiceKey, 0) = 0 OR isnull(s.WorkTypeKey, 0) = 0)), 0)
			
		+ ISNULL((Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
				inner join tTask t (nolock) on et.TaskKey = t.TaskKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType = 1 
			and isnull(t.WorkTypeKey, 0) = 0), 0)
			
		As EstLabor	

		, ISNULL((Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl  (nolock) 
				inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
				left outer join tService s (nolock) on etl.ServiceKey = s.ServiceKey 
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType > 1 
			and (isnull(etl.ServiceKey, 0) = 0 OR isnull(s.WorkTypeKey, 0) = 0)), 0)
			
		+ ISNULL((Select Sum(et.Hours)
			from tEstimateTask et  (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
				inner join tTask t (nolock) on et.TaskKey = t.TaskKey
			Where e.ProjectKey = @ProjectKey
			and e.Approved = 1
			and e.EstType = 1 
			and isnull(t.WorkTypeKey, 0) = 0), 0)
			
		As EstHours
		
		,ISNULL((select sum(ti.ActualHours) 
			from tTime ti (nolock)
				left outer join tService s (nolock) on ti.ServiceKey = s.ServiceKey 
			Where ti.ProjectKey = @ProjectKey
			and  (isnull(ti.ServiceKey, 0) = 0 OR isnull(s.WorkTypeKey, 0) = 0)
			), 0) 
			
		as ActHours
		
		,ISNULL((select SUM(ROUND(ti.ActualHours * ti.ActualRate, 2)) 
			from tTime ti (nolock)
				left outer join tService s (nolock) on ti.ServiceKey = s.ServiceKey 
			Where ti.ProjectKey = @ProjectKey
			and  (isnull(ti.ServiceKey, 0) = 0 OR isnull(s.WorkTypeKey, 0) = 0)
			), 0) 
			
		As ActExpenses
		
		,ISNULL((Select SUM(pod.TotalCost - ISNULL(pod.AppliedCost, 0)) 
			from tPurchaseOrderDetail pod (nolock) 
			inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
			left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
			where po.Closed = 0
			and   pod.ProjectKey = @ProjectKey
			and  (isnull(pod.ItemKey, 0) = 0 OR isnull(i.WorkTypeKey, 0) = 0)
			), 0) 		
		
		AS OpenPOAmt
		
		,  ISNULL((Select SUM(vd.BillableCost) 
			from tVoucherDetail vd (nolock)
				left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
			where vd.ProjectKey = @ProjectKey
			and   (isnull(vd.ItemKey, 0) = 0 OR isnull(i.WorkTypeKey, 0) = 0)
			), 0)

		+ ISNULL((Select SUM(mc.BillableCost) 
			from tMiscCost mc (nolock)
				left outer join tItem i (nolock) on mc.ItemKey = i.ItemKey  
			where mc.ProjectKey = @ProjectKey
			and   (isnull(mc.ItemKey, 0) = 0 OR isnull(i.WorkTypeKey, 0) = 0)
			), 0)
				
		+ ISNULL((Select SUM(er.BillableCost) 
			from tExpenseReceipt er (nolock)
				inner join tItem i (nolock) on er.ItemKey = i.ItemKey
			where er.ProjectKey = @ProjectKey
			and   ISNULL(i.WorkTypeKey, 0) = 0
			and   er.VoucherDetailKey is null
			), 0)	
			
		AS ActAmt
		
		,ISNULL((Select Sum(il.TotalAmount) 
		 from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
	     Where il.ProjectKey = @ProjectKey 
	     And   ISNULL(il.WorkTypeKey, 0) = 0 
	     And   invc.AdvanceBill = 0
	     And   il.BillFrom = 1				-- Fixed Fee Only
	     ), 0)
	     
	    + ISNULL((SELECT Sum(isum.Amount) 
		from tInvoiceSummary isum (NOLOCK)
		inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
		inner join tInvoiceLine il (NOLOCK) on isum.InvoiceLineKey = il.InvoiceLineKey
		left outer join tService s (NOLOCK) ON isum.EntityKey = s.ServiceKey
		WHERE isum.ProjectKey = @ProjectKey
		AND   inv.AdvanceBill = 0
		And   il.BillFrom = 2
		AND   isum.Entity = 'tService'
		AND   ISNULL(s.WorkTypeKey, 0) = 0 
		), 0)
		 
		+ ISNULL((SELECT Sum(isum.Amount) 
		from tInvoiceSummary isum (NOLOCK)
		inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
		inner join tInvoiceLine il (NOLOCK) on isum.InvoiceLineKey = il.InvoiceLineKey
		left outer join tItem i (NOLOCK) ON isum.EntityKey = i.ItemKey
		WHERE isum.ProjectKey = @ProjectKey
		AND   inv.AdvanceBill = 0
		And   il.BillFrom = 2
		AND   ISNULL(isum.Entity, '') in ('', 'tItem')
		AND   ISNULL(i.WorkTypeKey, 0) = 0 
		), 0)
		
		as AmountBilled
		
		/*
		
		,ISNULL((Select Sum(il.TotalAmount) 
		 from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
	     Where il.ProjectKey = @ProjectKey 
	     And   ISNULL(il.WorkTypeKey, 0) = 0 
	     And   invc.AdvanceBill = 0
	     And   il.BillFrom = 1			-- Fixed Fees
	     ), 0) 
	     +
	     ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
				LEFT OUTER JOIN tItem (nolock) on ProjectCosts.ItemKey = tItem.ItemKey
			 WHERE ProjectCosts.ProjectKey = @ProjectKey
			 AND   ISNULL(tItem.WorkTypeKey, 0) = 0
			 AND   ProjectCosts.Type IN ('MISCCOST', 'VOUCHER', 'ORDER') 
			 AND   ProjectCosts.InvoiceLineKey >0), 0) -- Detail 
		 +
		 ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
				LEFT OUTER JOIN tItem (nolock) on ProjectCosts.ItemKey = tItem.ItemKey
			 WHERE ProjectCosts.ProjectKey = @ProjectKey
			 AND   ISNULL(tItem.WorkTypeKey, 0) = 0
			 AND   ProjectCosts.Type IN ('EXPRPT') 
			 AND   ProjectCosts.InvoiceLineKey >0), 0) -- Detail 
         +
		 ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
				LEFT OUTER JOIN tService (nolock) on ProjectCosts.ItemKey = tService.ServiceKey
			 WHERE ProjectCosts.ProjectKey = @ProjectKey
			 AND   ISNULL(tService.WorkTypeKey, 0) = 0
			 AND   ProjectCosts.Type IN ('LABOR') 
			 AND   ProjectCosts.InvoiceLineKey >0), 0) -- Detail 
			 
		 As AmountBilled
*/
		  
	   ,0 As AllEstimatesAmountBilled
	    
	   ,0 As InvoiceLineKey
	   ,ISNULL((Select sum(Percentage) from tBillingFixedFee Where Entity = 'tWorkType' and EntityKey = 0 and BillingKey = @BillingKey), 0) as InvoiceLinePercent
	   ,ISNULL((Select sum(Amount) from tBillingFixedFee Where Entity = 'tWorkType' and EntityKey = 0 and BillingKey = @BillingKey), 0) as InvoiceLineAmount
       ,Cast(0 as Money) As RemainingInv
	     	
	ORDER BY WorkTypeName	
     		     	
	RETURN 1
GO
