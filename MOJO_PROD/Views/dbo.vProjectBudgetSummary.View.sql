USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vProjectBudgetSummary]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
|| When     Who Rel   What
|| 04/26/07 GHL 8.4   Get TotalGross from tProjectRollup instead of tProject.TotalGross 
|| 07/09/07 GHL 8.5   Added restriction on ER 
*/



CREATE            View [dbo].[vProjectBudgetSummary]

as

Select 
	p.*,
	c.CustomerID,
	c.CompanyName as ClientName,
	o.OfficeName,
	u.FirstName + ' ' + u.LastName as ProjectManagerName,
	pt.ProjectTypeName,
	ps.ProjectStatus
	,ISNULL((select sum(ActualHours) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey), 0) as ActHours
	,ISNULL((Select SUM(ROUND(ActualHours * ActualRate, 2)) from tTime (nolock) where tTime.ProjectKey = p.ProjectKey), 0) as ActualLabor
	,ISNULL((Select SUM(BillableCost) from tExpenseReceipt (nolock) where tExpenseReceipt.ProjectKey = p.ProjectKey and tExpenseReceipt.VoucherDetailKey is null), 0) as ExpReceiptAmt
	,ISNULL((Select SUM(BillableCost) from tMiscCost (nolock) where tMiscCost.ProjectKey = p.ProjectKey), 0) as MiscCostAmt
	,ISNULL((Select SUM(BillableCost) 
		from tVoucherDetail (nolock)
		where tVoucherDetail.ProjectKey = p.ProjectKey), 0) as VoucherAmt
	,ISNULL((Select SUM(pod.AmountBilled) 
			from tPurchaseOrderDetail pod (nolock) 
			where pod.AmountBilled IS NOT NULL
			and   pod.ProjectKey = p.ProjectKey), 0)		AS PreBilledPOAmt  
	,ISNULL((Select SUM(TotalAmount) from tInvoiceLine il (nolock) 
			inner join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey where i.AdvanceBill = 1 and il.ProjectKey = p.ProjectKey),0) as AmountAdvanceBilled
	,ISNULL((Select SUM(TotalAmount) from tInvoiceLine il (nolock) 
			inner join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey where i.AdvanceBill = 0 and il.ProjectKey = p.ProjectKey),0) as AmountBilled
	,ISNULL((Select SUM(ROUND(ActualHours * ActualRate, 2)) from tTime (nolock) where tTime.ProjectKey = p.ProjectKey and WriteOff = 0 and InvoiceLineKey IS NULL), 0) +
		ISNULL((Select SUM(BillableCost) from tExpenseReceipt (nolock) where tExpenseReceipt.ProjectKey = p.ProjectKey and WriteOff = 0 and InvoiceLineKey IS NULL and VoucherDetailKey is null), 0) +
		ISNULL((Select SUM(BillableCost) from tMiscCost (nolock) where tMiscCost.ProjectKey = p.ProjectKey and WriteOff = 0 and InvoiceLineKey IS NULL), 0) +
		ISNULL((Select SUM(BillableCost) from tVoucherDetail (nolock) where tVoucherDetail.ProjectKey = p.ProjectKey and WriteOff = 0 and InvoiceLineKey IS NULL), 0) as Unbilled
	,ISNULL(roll.LaborGross, 0)+ISNULL(roll.MiscCostGross, 0)+ISNULL(roll.ExpReceiptGross, 0)+ISNULL(roll.VoucherGross, 0)+ISNULL(roll.OpenOrderGross, 0) as TotalGross
From
	tProject p (nolock)
	LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey
	LEFT OUTER JOIN tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	LEFT OUTER JOIN tUser u (nolock) on p.AccountManager = u.UserKey
	LEFT OUTER JOIN tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	LEFT OUTER JOIN tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	LEFT OUTER JOIN tProjectRollup roll (nolock) on p.ProjectKey = roll.ProjectKey
GO
