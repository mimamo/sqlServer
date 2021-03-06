USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGetExpenseSummary]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGetExpenseSummary]

	 @ProjectKey int
	,@BillingKey int

as -- Encrypt

  /*
  || When     Who Rel   What
  || 09/28/06 GHL 8.4   Added Mark as Billed column 
  || 07/09/07 GHL 8.5   Added restriction on ERs
  || 07/10/07 QMD/GHL 8.5  Expense Type reference changed to tItem 
  || 01/08/08 GHL 8.5  (18745) Removed Union in query since Expense Reports can be converted to voucher details                   
  || 01/22/08 GHL 8.502 (18071) McClain had problems with 160 services or items
  ||                    Initial subquery taking too long
  ||                    Decided to use temp table then determine if items are involved and delete if not
  ||                    This limits the number of items before calculations  
  || 12/15/08 GHL 10.015 (41479) The billed columns should not include the invoice created with the WS    
  || 01/20/11 GHL 10.540 (100902) Passing now ItemKey = -1 for No Item case to make it consistent with tasks and services 
  ||                      Because the summary section in worksheet_tm.aspx passes 0 for All Items
  || 03/26/15 GHL 10.591 (228570) Take in account Gross when calculating OpenPOAmt (same as sptProjectRollupUpdate)
  ||                      1) Recalc NewGross as a function of po.BillAt
  ||                      2) NewGross = NewGross * (Amt Unapplied / TotalCost) = NewGross * ((TotalCost - AppliedCost) / TotalCost)
  ||                         = NewGross * (1 - (AppliedCost / TotalCost))                     
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
  ,ItemKey INT NULL
  ,ItemName VARCHAR(250) NULL
  ,ItemType int NULL
  
  ,BudgetAmt MONEY NULL
  ,COAmt MONEY NULL
  
  ,OpenPOAmt MONEY NULL
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

-- 1) Insert items

 INSERT #Summary (WorkTypeName, WorkTypeKey, ItemKey, ItemName, ItemType)
 select ISNULL(wt.WorkTypeName, '[No Billing Item]') , i.WorkTypeKey, i.ItemKey, i.ItemName, i.ItemType 
		from tItem i (nolock)
			left outer join tWorkType wt (nolock) on i.WorkTypeKey = wt.WorkTypeKey 
		where i.CompanyKey = @CompanyKey
 
 INSERT #Summary (WorkTypeName, WorkTypeKey, ItemKey, ItemName, ItemType)
 select   '[No Billing Item]' as WorkTypeName
			,0 as WorkTypeKey
			,0 AS ItemKey   
			,'[No Item]' as ItemType
			,0

--2) determine if records exists for these items
	
 UPDATE #Summary SET ActualExists = 0, BudgetExists = 0, InvoiceExists = 0, BillingWorksheetExists = 0
 			
 UPDATE #Summary
 SET    #Summary.BudgetAmt = pe.Gross
		,#Summary.COAmt = pe.COGross
		,#Summary.BudgetExists = 1
 FROM   tProjectEstByItem pe (nolock) 
			where pe.ProjectKey = @ProjectKey   
			and isnull(pe.EntityKey, 0) = #Summary.ItemKey
			and pe.Entity = 'tItem'  
			
UPDATE #Summary
SET    #Summary.ActualExists = 1 
from tPurchaseOrderDetail pod (nolock) 
			inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
where pod.ProjectKey = @ProjectKey
and   po.Closed = 0
and isnull(pod.ItemKey, 0) = #Summary.ItemKey
and #Summary.ActualExists = 0

UPDATE #Summary
SET    #Summary.ActualExists = 1 
from tVoucherDetail vd (nolock) 
where vd.ProjectKey = @ProjectKey
and isnull(vd.ItemKey, 0) = #Summary.ItemKey
and #Summary.ActualExists = 0

UPDATE #Summary
SET    #Summary.ActualExists = 1 
from tMiscCost mc (nolock) 
where mc.ProjectKey = @ProjectKey
and isnull(mc.ItemKey, 0) = #Summary.ItemKey
and #Summary.ActualExists = 0
  
UPDATE #Summary
SET    #Summary.ActualExists = 1 
from tExpenseReceipt er (nolock) 
where er.ProjectKey = @ProjectKey
and isnull(er.ItemKey, 0) = #Summary.ItemKey
and #Summary.ActualExists = 0
and er.VoucherDetailKey is null

UPDATE #Summary
SET    #Summary.InvoiceExists = 1 
from tInvoice i (nolock)
	INNER JOIN tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey 
where il.ProjectKey = @ProjectKey
and   ISNULL(il.Entity, '') = 'tItem'
				and   ISNULL(il.EntityKey, 0) = #Summary.ItemKey 
				and i.AdvanceBill = 0
				and il.BillFrom = 1			-- Fixed Fee 

UPDATE #Summary
SET    #Summary.BillingWorksheetExists = 1 
from tBillingDetail bd (nolock) 
inner join tPurchaseOrderDetail pod (nolock) on bd.EntityKey = pod.PurchaseOrderDetailKey
where bd.BillingKey = @BillingKey 
and bd.Entity = 'tPurchaseOrderDetail' 
and ISNULL(pod.ItemKey, 0) = #Summary.ItemKey  
and #Summary.BillingWorksheetExists = 0

UPDATE #Summary
SET    #Summary.BillingWorksheetExists = 1 
from tBillingDetail bd (nolock) 
inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey
where bd.BillingKey = @BillingKey 
and bd.Entity = 'tVoucherDetail' 
and ISNULL(vd.ItemKey, 0) = #Summary.ItemKey  
and #Summary.BillingWorksheetExists = 0

UPDATE #Summary
SET    #Summary.BillingWorksheetExists = 1 
from tBillingDetail bd (nolock) 
inner join tMiscCost mc (nolock) on bd.EntityKey = mc.MiscCostKey
where bd.BillingKey = @BillingKey 
and bd.Entity = 'tMiscCost' 
and ISNULL(mc.ItemKey, 0) = #Summary.ItemKey  
and #Summary.BillingWorksheetExists = 0

UPDATE #Summary
SET    #Summary.BillingWorksheetExists = 1 
from tBillingDetail bd (nolock) 
inner join tExpenseReceipt er (nolock) on bd.EntityKey = er.ExpenseReceiptKey
where bd.BillingKey = @BillingKey 
and bd.Entity = 'tExpenseReceipt' 
and ISNULL(er.ItemKey, 0) = #Summary.ItemKey  
and #Summary.BillingWorksheetExists = 0
  
 
-- can delete if nothing there			
DELETE #Summary WHERE ActualExists + BudgetExists + InvoiceExists + BillingWorksheetExists = 0

-- 3)perform calcs on limited items

UPDATE #Summary
set #Summary.OpenPOAmt = ISNULL((
				SELECT SUM(
							CASE 
								WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
								WHEN AppliedCost > 0 AND AppliedCost < TotalCost AND TotalCost <> 0
									THEN NewBillableCost * (1 - cast(AppliedCost as Decimal(24,8)) / cast(TotalCost as Decimal(24,8) ) )	
								ELSE NewBillableCost 
							END
						)
				FROM				
				(
				SELECT CASE po.BillAt 
						WHEN 0 THEN ISNULL(pod.BillableCost, 0)
						WHEN 1 THEN ISNULL(pod.PTotalCost,0) -- multiple changes for MC
    					WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
						END AS NewBillableCost
						,pod.PTotalCost as TotalCost
						,pod.PAppliedCost as AppliedCost
						,pod.BillableCost
				FROM	tPurchaseOrderDetail pod (NOLOCK)
					INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
				WHERE	pod.Closed = 0					-- still open
				AND		pod.ProjectKey = @ProjectKey
				and     isnull(pod.ItemKey, 0) = #Summary.ItemKey
				AND     pod.DateBilled IS NULL  -- Non Prebilled only
				) AS OpenOrders	
				), 0)

UPDATE #Summary
SET    #Summary.ActAmt =  
isnull((select sum(vd.BillableCost) 
			from tVoucherDetail vd (nolock) 
			where vd.ProjectKey = @ProjectKey
			and   isnull(vd.ItemKey, 0) = #Summary.ItemKey), 0)
+ isnull((select sum(mc.BillableCost) 
			from tMiscCost mc (nolock) 
			where mc.ProjectKey = @ProjectKey
			and   isnull(mc.ItemKey, 0) = #Summary.ItemKey), 0)
+ isnull((select sum(er.BillableCost) 
			from tExpenseReceipt er (nolock) 
			where er.ProjectKey = @ProjectKey
			and er.VoucherDetailKey is null
			and   isnull(er.ItemKey, 0) = #Summary.ItemKey), 0)
		
UPDATE #Summary
SET    #Summary.AmountBilled =  		
isnull((select sum(vd.AmountBilled) 
			from tVoucherDetail vd (nolock)
				inner join tInvoiceLine il (nolock) on vd.InvoiceLineKey = il.InvoiceLineKey 
			where isnull(vd.ItemKey, 0) = #Summary.ItemKey
			and   vd.ProjectKey = @ProjectKey
			--and vd.InvoiceLineKey >0
			and il.InvoiceKey <> @InvoiceKey
			), 0)
		+ isnull((select sum(mc.AmountBilled) 
			from tMiscCost mc (nolock) 
				inner join tInvoiceLine il (nolock) on mc.InvoiceLineKey = il.InvoiceLineKey 
			where isnull(mc.ItemKey, 0) = #Summary.ItemKey
			and   mc.ProjectKey = @ProjectKey
			--and mc.InvoiceLineKey >0
			and il.InvoiceKey <> @InvoiceKey
			), 0)
		+ isnull((select sum(pod.AmountBilled) 
			from tPurchaseOrderDetail pod (nolock)
				inner join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey 
			where isnull(pod.ItemKey, 0) = #Summary.ItemKey
			and pod.ProjectKey = @ProjectKey
			--and pod.InvoiceLineKey >0
			and il.InvoiceKey <> @InvoiceKey
			), 0)
		 + isnull((select sum(er.AmountBilled) 
			from tExpenseReceipt er (nolock)
				inner join tInvoiceLine il (nolock) on er.InvoiceLineKey = il.InvoiceLineKey 
			where er.ProjectKey = @ProjectKey
			and isnull(er.ItemKey, 0) = #Summary.ItemKey
			--and er.InvoiceLineKey >0
			and il.InvoiceKey <> @InvoiceKey
			), 0)	
		+ isnull((select sum(il.TotalAmount) 
			from tInvoiceLine il (nolock) 
			inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
			where il.ProjectKey = @ProjectKey 
			and   isnull(il.Entity, '') = 'tItem'		
			and   isnull(il.EntityKey, 0) = #Summary.ItemKey 
			and invc.AdvanceBill = 0
			and invc.InvoiceKey <> @InvoiceKey
			and il.BillFrom = 1), 0)		


UPDATE #Summary
SET    #Summary.AmountToBeBilled =  		
isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity  = 'tVoucherDetail' 
			     and Action = 1
			     and ISNULL(vd.ItemKey, 0) = #Summary.ItemKey
			     ),0)
		+isnull((select sum(Total) 
			  from tBillingDetail bd (nolock) 
			    inner join tPurchaseOrderDetail pod (nolock) on bd.EntityKey = pod.PurchaseOrderDetailKey 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity  = 'tPurchaseOrderDetail' 
			     and Action = 1
			     and ISNULL(pod.ItemKey, 0) = #Summary.ItemKey
			     ),0)	    
		+isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tMiscCost mc (nolock) on bd.EntityKey = mc.MiscCostKey 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity  = 'tMiscCost' 
			     and Action = 1
			     and ISNULL(mc.ItemKey, 0) = #Summary.ItemKey
			     ),0)	 
		+isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tExpenseReceipt er (nolock) on er.ExpenseReceiptKey = bd.EntityKey
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity = 'tExpenseReceipt' 
			     and Action = 1
			     and ISNULL(er.ItemKey, 0) = #Summary.ItemKey
			     ), 0)	         								
			   
UPDATE #Summary
SET    #Summary.AmountOnBW =  		
isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey 
		    where bd.BillingKey = @BillingKey 
			     and bd.Entity  = 'tVoucherDetail' 
			     and ISNULL(vd.ItemKey, 0) = #Summary.ItemKey
			     ),0)
		+isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tPurchaseOrderDetail pod (nolock) on bd.EntityKey = pod.PurchaseOrderDetailKey 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity  = 'tPurchaseOrderDetail' 
			     and ISNULL(pod.ItemKey, 0) = #Summary.ItemKey
			     ),0)	    
		+isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tMiscCost mc (nolock) on bd.EntityKey = mc.MiscCostKey 
		     where bd.BillingKey = @BillingKey 
			     and bd.Entity  = 'tMiscCost' 
			     and ISNULL(mc.ItemKey, 0) = #Summary.ItemKey
			     ),0)	  
		+isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tExpenseReceipt er (nolock) on er.ExpenseReceiptKey = bd.EntityKey
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity = 'tExpenseReceipt' 
			     and ISNULL(er.ItemKey, 0) = #Summary.ItemKey
			     ), 0)	        												     
		
		
UPDATE #Summary
SET    #Summary.AmountNotSelected =  		
isnull((select sum(BillableCost) 
				   from vBillingItemSelect 
				  where vBillingItemSelect.ProjectKey = @ProjectKey
				  and   ISNULL(vBillingItemSelect.ItemKey, 0) = #Summary.ItemKey
				  and   vBillingItemSelect.Type IN ('MISCCOST', 'VOUCHER', 'ORDER', 'EXPRPT') 
				), 0) 		
				
UPDATE #Summary
SET    #Summary.AmountMarkAsBilled =  		
isnull((select sum(vd.AmountBilled) 
			from tVoucherDetail vd (nolock)
			where isnull(vd.ItemKey, 0) = #Summary.ItemKey
			and   vd.ProjectKey = @ProjectKey
			and vd.InvoiceLineKey =0), 0)
		+ isnull((select sum(mc.AmountBilled) 
			from tMiscCost mc (nolock) 
			where isnull(mc.ItemKey, 0) = #Summary.ItemKey
			and   mc.ProjectKey = @ProjectKey
			and mc.InvoiceLineKey =0), 0)
		+isnull((select sum(pod.AmountBilled) 
			from tPurchaseOrderDetail pod (nolock)
			where isnull(pod.ItemKey, 0) = #Summary.ItemKey
			and pod.ProjectKey = @ProjectKey
			and pod.InvoiceLineKey =0), 0)
		+isnull((select sum(er.AmountBilled) 
			from tExpenseReceipt er (nolock)
			where er.ProjectKey = @ProjectKey
			and isnull(er.ItemKey, 0) = #Summary.ItemKey
			and er.InvoiceLineKey =0), 0)	
			

UPDATE #Summary
SET  BudgetAmt = ISNULL(BudgetAmt, 0)
	 ,COAmt = ISNULL(COAmt, 0)
  
  ,OpenPOAmt = ISNULL(OpenPOAmt, 0)
  ,ActAmt = ISNULL(ActAmt, 0)
  
  ,AmountBilled = ISNULL(AmountBilled, 0)
  ,AmountToBeBilled = ISNULL(AmountToBeBilled, 0)
  ,AmountOnBW = ISNULL(AmountOnBW, 0)
  ,AmountNotSelected = ISNULL(AmountNotSelected, 0)
  ,AmountMarkAsBilled = ISNULL(AmountMarkAsBilled, 0)

-- Correct for the UI
UPDATE #Summary
SET    ItemKey = -1
WHERE  ItemKey = 0

SELECT ItemType as Type, * FROM #Summary -- added Type for deployment to McClain
			     		     			
RETURN 1
											
					     						 
/*	
	select 	i.ItemType
		,isnull(wt.WorkTypeName, '[No Billing Item]') as WorkTypeName
		,i.WorkTypeKey 
		,i.ItemKey												as ItemKey
		,i.ItemName												as ItemName
		,isnull((select pe.Gross
		  from   tProjectEstByItem pe (nolock)
		  where  pe.ProjectKey = @ProjectKey
		  and    isnull(pe.EntityKey, 0) = i.ItemKey
		  and    pe.Entity = 'tItem' 
		  ), 0)													as BudgetAmt
		,isnull((select pe.COGross
		  from   tProjectEstByItem pe (nolock)
		 where  pe.ProjectKey = @ProjectKey
		  and    isnull(pe.EntityKey, 0) = i.ItemKey
		  and    pe.Entity = 'tItem' 
		  ), 0)													as COAmt		  	
		
		,isnull((select sum(pod.TotalCost - isnull(pod.AppliedCost, 0)) 
			from tPurchaseOrderDetail pod (nolock) 
			inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
			where po.Closed = 0
			and   pod.ProjectKey = @ProjectKey
			and   isnull(pod.ItemKey, 0) = i.ItemKey), 0) 		as OpenPOAmt
		
		,isnull((select sum(vd.BillableCost) 
			from tVoucherDetail vd (nolock)
			where isnull(vd.ItemKey, 0) = i.ItemKey
			and   vd.ProjectKey = @ProjectKey), 0)
		+ isnull((select sum(mc.BillableCost) 
			from tMiscCost mc (nolock) 
			where isnull(mc.ItemKey, 0) = i.ItemKey
			and   mc.ProjectKey = @ProjectKey
			), 0) 
		 + isnull((select sum(er.BillableCost) 
			from tExpenseReceipt er (nolock)
			where er.ProjectKey = @ProjectKey
			and isnull(er.ItemKey, 0) = i.ItemKey
			and er.VoucherDetailKey is null
			), 0)												as ActAmt
		
		,isnull((select sum(vd.AmountBilled) 
			from tVoucherDetail vd (nolock)
			where isnull(vd.ItemKey, 0) = i.ItemKey
			and   vd.ProjectKey = @ProjectKey
			and vd.InvoiceLineKey >0), 0)
		+ isnull((select sum(mc.AmountBilled) 
			from tMiscCost mc (nolock) 
			where isnull(mc.ItemKey, 0) = i.ItemKey
			and   mc.ProjectKey = @ProjectKey
			and mc.InvoiceLineKey >0), 0)
		+ isnull((select sum(pod.AmountBilled) 
			from tPurchaseOrderDetail pod (nolock)
			where isnull(pod.ItemKey, 0) = i.ItemKey
			and pod.ProjectKey = @ProjectKey
			and pod.InvoiceLineKey >0), 0)
		 + isnull((select sum(er.AmountBilled) 
			from tExpenseReceipt er (nolock)
			where er.ProjectKey = @ProjectKey
			and isnull(er.ItemKey, 0) = i.ItemKey
			and er.InvoiceLineKey >0), 0)	
		+ isnull((select sum(il.TotalAmount) 
			from tInvoiceLine il (nolock) 
			inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
			where il.ProjectKey = @ProjectKey 
			and   isnull(il.Entity, '') = 'tItem'		
			and   isnull(il.EntityKey, 0) = i.ItemKey 
			and invc.AdvanceBill = 0
			and il.BillFrom = 1), 0)							as AmountBilled
	     
		,isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity  = 'tVoucherDetail' 
			     and Action = 1
			     and ISNULL(vd.ItemKey, 0) = i.ItemKey
			     ),0)
		+isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tPurchaseOrderDetail pod (nolock) on bd.EntityKey = pod.PurchaseOrderDetailKey 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity  = 'tPurchaseOrderDetail' 
			     and Action = 1
			     and ISNULL(pod.ItemKey, 0) = i.ItemKey
			     ),0)	    
		+isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tMiscCost mc (nolock) on bd.EntityKey = mc.MiscCostKey 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity  = 'tMiscCost' 
			     and Action = 1
			     and ISNULL(mc.ItemKey, 0) = i.ItemKey
			     ),0)	 
		+isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tExpenseReceipt er (nolock) on er.ExpenseReceiptKey = bd.EntityKey
		 where bd.BillingKey = @BillingKey 
			     and bd.Entity = 'tExpenseReceipt' 
			     and Action = 1
			     and ISNULL(er.ItemKey, 0) = i.ItemKey
			     ), 0)	         							as AmountToBeBilled 			

		,isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey 
		    where bd.BillingKey = @BillingKey 
			     and bd.Entity  = 'tVoucherDetail' 
			     and ISNULL(vd.ItemKey, 0) = i.ItemKey
			     ),0)
		+isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			 inner join tPurchaseOrderDetail pod (nolock) on bd.EntityKey = pod.PurchaseOrderDetailKey 
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity  = 'tPurchaseOrderDetail' 
			     and ISNULL(pod.ItemKey, 0) = i.ItemKey
			     ),0)	    
		+isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tMiscCost mc (nolock) on bd.EntityKey = mc.MiscCostKey 
		     where bd.BillingKey = @BillingKey 
			     and bd.Entity  = 'tMiscCost' 
			     and ISNULL(mc.ItemKey, 0) = i.ItemKey
			     ),0)	  
		+isnull((select sum(Total) 
			    from tBillingDetail bd (nolock) 
			    inner join tExpenseReceipt er (nolock) on er.ExpenseReceiptKey = bd.EntityKey
		       where bd.BillingKey = @BillingKey 
			     and bd.Entity = 'tExpenseReceipt' 
			     and ISNULL(er.ItemKey, 0) = i.ItemKey
			     ), 0)	        								as AmountOnBW 		

		,isnull((select sum(BillableCost) 
				   from vBillingItemSelect 
				  where vBillingItemSelect.ProjectKey = @ProjectKey
				  and   ISNULL(vBillingItemSelect.ItemKey, 0) = i.ItemKey
				  and   vBillingItemSelect.Type IN ('MISCCOST', 'VOUCHER', 'ORDER', 'EXPRPT') 
				), 0) as AmountNotSelected
				
		,isnull((select sum(vd.AmountBilled) 
			from tVoucherDetail vd (nolock)
			where isnull(vd.ItemKey, 0) = i.ItemKey
			and   vd.ProjectKey = @ProjectKey
			and vd.InvoiceLineKey =0), 0)
		+ isnull((select sum(mc.AmountBilled) 
			from tMiscCost mc (nolock) 
			where isnull(mc.ItemKey, 0) = i.ItemKey
			and   mc.ProjectKey = @ProjectKey
			and mc.InvoiceLineKey =0), 0)
		+isnull((select sum(pod.AmountBilled) 
			from tPurchaseOrderDetail pod (nolock)
			where isnull(pod.ItemKey, 0) = i.ItemKey
			and pod.ProjectKey = @ProjectKey
			and pod.InvoiceLineKey =0), 0)
		+isnull((select sum(er.AmountBilled) 
			from tExpenseReceipt er (nolock)
			where er.ProjectKey = @ProjectKey
			and isnull(er.ItemKey, 0) = i.ItemKey
			and er.InvoiceLineKey =0), 0)					As AmountMarkAsBilled
				
	from  
		(
		select ItemKey
		      ,ItemName 
		      ,WorkTypeKey
		      ,Taxable
		      ,Taxable2
		      ,ItemType
		from   tItem (nolock)
		where  CompanyKey = @CompanyKey
		
		UNION
		
		SELECT 0 AS ItemKey
		     ,'[No Expense Item]' As ItemName
		     ,0 AS WorkTypeKey
		     ,0
		     ,0
		     ,0
		) as i 
		left outer join tWorkType wt (nolock) on i.WorkTypeKey = wt.WorkTypeKey
	
	return 1

*/
GO
