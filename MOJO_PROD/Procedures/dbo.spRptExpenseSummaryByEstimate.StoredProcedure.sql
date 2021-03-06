USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptExpenseSummaryByEstimate]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptExpenseSummaryByEstimate]
	(
		@ProjectKey INT
		,@EstimateKey INT
	)
AS --Encrypt

 /*
  || When     Who Rel   What
  || 05/15/07 GHL 8.5   Lifted ambiguity on Taxable fields now in multiple tables  
  || 07/09/07 GHL 8.5   Added restriction on ERs  
  || 07/10/07 QMD/GHL 8.5  Expense Type reference changed to tItem  
  || 01/08/08 GHL 8.5   (18745) Simplified the query to use only tItem regardless of ItemType (w/o Union) since
  ||                     expense reports can be converted to voucher details.
 */
 
	SET NOCOUNT ON 
	
	DECLARE @CompanyKey INT
	       
	SELECT @CompanyKey = CompanyKey
	FROM   tProject (NOLOCK)
	WHERE  ProjectKey = @ProjectKey

	SELECT 	i.ItemType
		,ISNULL(wt.WorkTypeName, '[No Billing Item]') AS WorkTypeName
		,i.WorkTypeKey 
		,i.ItemKey												AS ItemKey
		,i.ItemName												AS ItemName
		,ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey 
			and e.EstType > 1 and e.ChangeOrder = 0 
			and isnull(ete.ItemKey, 0) = i.ItemKey), 0) 
		+ ISNULL((Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey 
			and e.EstType = 1 and e.ChangeOrder = 0
			and i.ItemKey = 0), 0) As BudgetAmt 
		,ISNULL((Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end ) 
			from tEstimateTaskExpense ete  (nolock) inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey 
			and e.EstType > 1 and e.ChangeOrder = 1 
			and isnull(ete.ItemKey, 0) = i.ItemKey), 0) 
		+ ISNULL((Select Sum(et.EstExpenses)
			from tEstimateTask et  (nolock) inner join tEstimate e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.EstimateKey = @EstimateKey 
			and e.EstType = 1 and e.ChangeOrder = 1
			and i.ItemKey = 0), 0) As COAmt 				  	
		,ISNULL((Select SUM(pod.TotalCost - ISNULL(pod.AppliedCost, 0)) 
			from tPurchaseOrderDetail pod (nolock) 
			inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
			where po.Closed = 0
			and   pod.ProjectKey = @ProjectKey
			and   ISNULL(pod.ItemKey, 0) = i.ItemKey), 0) 		AS OpenPOAmt
		,ISNULL((Select SUM(vd.BillableCost) 
			from tVoucherDetail vd (nolock)
			where ISNULL(vd.ItemKey, 0) = i.ItemKey
			and   vd.ProjectKey = @ProjectKey), 0)
		+ ISNULL((Select SUM(mc.BillableCost) 
			from tMiscCost mc (nolock) 
			where ISNULL(mc.ItemKey, 0) = i.ItemKey
			and   mc.ProjectKey = @ProjectKey
			), 0)	
		 + ISNULL((Select SUM(er.BillableCost) 
			from tExpenseReceipt er (nolock)
			where er.ProjectKey = @ProjectKey
			and   ISNULL(er.ItemKey, 0) = i.ItemKey
			and   er.VoucherDetailKey IS NULL
			), 0)												AS ActAmt
		, cast(0 as MONEY)										AS VarianceAmt

		,ISNULL((Select Sum(il.TotalAmount) 
		 from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
	     Where il.ProjectKey = @ProjectKey 
	     And   il.EstimateKey = @EstimateKey
	     And   ISNULL(il.Entity, '') = 'tItem'		
	     And   ISNULL(il.EntityKey, 0) = i.ItemKey 
	     And invc.AdvanceBill = 0), 0) as AmountBilled

		,ISNULL((Select Sum(il.TotalAmount) 
		 from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
	     Where il.ProjectKey = @ProjectKey 
	     And   ISNULL(il.Entity, '') = 'tItem'		
	     And   ISNULL(il.EntityKey, 0) = i.ItemKey 
	     And invc.AdvanceBill = 0), 0) as AllEstimatesAmountBilled
	     	
		,0 as InvoiceLineKey
		,Cast(0 as Money) as InvoiceLineAmount
		,Cast(0 as Money) As RemainingInv
		,i.Taxable
		,i.Taxable2


	FROM  
		(
		SELECT ItemKey
		      ,ItemName 
		      ,WorkTypeKey
		      ,Taxable
		      ,Taxable2
		      ,ItemType
		FROM   tItem (NOLOCK)
		WHERE  CompanyKey = @CompanyKey
		
		UNION
		
		SELECT 0 AS ItemKey
		     ,'[No Expense Item]' As ItemName
		     ,0 AS WorkTypeKey
		     ,0
		     ,0
		     ,0
		) AS i 
		LEFT OUTER JOIN tWorkType wt (NOLOCK) ON i.WorkTypeKey = wt.WorkTypeKey
	
	
	RETURN 1
GO
