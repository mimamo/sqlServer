USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingFixedFeeGetItemList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptBillingFixedFeeGetItemList]
	(
		@BillingKey int,
		@ProjectKey INT
	)
AS --Encrypt

 /*
  || When     Who Rel   What
  || 09/28/06 GHL 8.35  Reviewed calc of AmountBilled to make same as spRptExpenseSummary  
  || 06/11/07 GHL 8.43  Lifted ambiguity on Taxable fields
  || 07/09/07 GHL 8.5   Added restriction on ERs
  || 07/10/07 QMD 8.5   (+ GHL) Expense Type reference changed to tItem
  || 01/08/08 GHL 8.501 (18745) Removed Union since Item were ItemType = 3 can be in exp receipts and Vouchers 
  || 01/31/08 GHL 8.5   (20123) Using now invoice summary rather project cost view
  || 07/15/09 GHL 10.505 Added sort so that [No Expense Item] is the first line
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
		,ISNULL((SELECT pe.Gross
		  FROM   tProjectEstByItem pe (NOLOCK)
		  WHERE  pe.ProjectKey = @ProjectKey
		  AND    ISNULL(pe.EntityKey, 0) = i.ItemKey
		  AND    pe.Entity = 'tItem' 
		  ), 0) AS BudgetAmt
		,ISNULL((SELECT pe.COGross
		  FROM   tProjectEstByItem pe (NOLOCK)
		  WHERE  pe.ProjectKey = @ProjectKey
		  AND    ISNULL(pe.EntityKey, 0) = i.ItemKey
		  AND    pe.Entity = 'tItem' 
		  ), 0) AS COAmt		  	
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
			and   er.VoucherDetailKey is null
			), 0) 												AS ActAmt
		, cast(0 as MONEY)										AS VarianceAmt

		,ISNULL((SELECT Sum(isum.Amount) 
				from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice inv (NOLOCK) on isum.InvoiceKey = inv.InvoiceKey
				WHERE isum.ProjectKey = @ProjectKey
				AND   ISNULL(isum.Entity, '') IN ('','tItem')
				AND   ISNULL(isum.EntityKey, 0) = i.ItemKey
				AND   inv.AdvanceBill = 0), 0)
				
				as AmountBilled
				
		/*
		,ISNULL((Select Sum(il.TotalAmount) 
		 from tInvoiceLine il (nolock) inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
	     Where il.ProjectKey = @ProjectKey 
	     And   ISNULL(il.Entity, '') = 'tItem'		
	     And   ISNULL(il.EntityKey, 0) = i.ItemKey 
	     And   invc.AdvanceBill = 0
	     And   il.BillFrom = 1), 0)		-- Fixed Fee
		 +
		 ISNULL((SELECT Sum(AmountBilled) from ProjectCosts (NOLOCK)
			 WHERE ProjectCosts.ProjectKey = @ProjectKey
			 AND   ISNULL(ProjectCosts.ItemKey, 0) = i.ItemKey
			 AND   ProjectCosts.Type IN ('MISCCOST', 'VOUCHER', 'ORDER', 'EXPRPT') 
			 AND   ProjectCosts.InvoiceLineKey > 0), 0) -- Detail  
		AS AmountBilled
	    */
	     
	    ,0 As AllEstimatesAmountBilled
	     	
		,0 as InvoiceLineKey
		,ISNULL((Select sum(Percentage) from tBillingFixedFee Where Entity = 'tItem' and EntityKey = i.ItemKey and BillingKey = @BillingKey), 0) as InvoiceLinePercent
		,ISNULL((Select sum(Amount) from tBillingFixedFee Where Entity = 'tItem' and EntityKey = i.ItemKey and BillingKey = @BillingKey), 0) as InvoiceLineAmount
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
	
	ORDER BY ItemName
	
	RETURN 1
GO
