USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vSalesGLDetail]    Script Date: 12/11/2015 15:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vSalesGLDetail]

as


/*
|| When     Who Rel     What
|| 06/13/07 GHL 8.5   Added OfficeKey, DepartmentKey, ProjectKey
|| 07/12/07 GHL 8.5   Getting now office from project, department from the item, not the user 
||                                  Changed Expense Type to Item
|| 10/15/07 GHL 8.5   Corrected ProjectKey for VI
|| 10/31/07 GHL 8.5   Logic for ClassKey is: try to get it from transaction first then project then item 
|| 12/19/07 GHL 8.5   Added Hint for tTime
|| 02/26/08 GHL 8.5   Change for SQL 2005 With Index
|| 10/23/08 GHL 10.011 Added ItemClassKey for U of A customization
*/


Select 
	'L' as Type
	,t.InvoiceLineKey
	,s.GLAccountKey as SalesAccountKey
	,CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN p.ClassKey ELSE s.ClassKey END AS ClassKey
	,s.ClassKey AS ItemClassKey
    ,s.DepartmentKey
	,p.OfficeKey
	,t.ProjectKey
	,ROUND(t.BilledHours * t.BilledRate, 2) as Amount
	,ROUND(t.ActualHours * t.ActualRate, 2) as Standard
From 
	tTime t with (index=IX_tTime_3, nolock)
	left outer join tService s (nolock) on t.ServiceKey = s.ServiceKey
	left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
Where
	t.InvoiceLineKey > 0



Union all

Select 
	'M' as Type
	,t.InvoiceLineKey
	,i.SalesAccountKey as SalesAccountKey
	,CASE WHEN ISNULL(t.ClassKey, 0) > 0 THEN t.ClassKey  
		ELSE CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN p.ClassKey
			       ELSE  i.ClassKey	
		END 
	END AS ClassKey
	,i.ClassKey AS ItemClassKey
    ,i.DepartmentKey 
	,p.OfficeKey
	,t.ProjectKey
	,t.AmountBilled as Amount
	,t.BillableCost as Standard
From 
	tMiscCost t (nolock)
	inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	left outer join tItem i (nolock) on t.ItemKey = i.ItemKey
	
Where
	t.InvoiceLineKey > 0



Union all


Select 
	'E' as Type
	,t.InvoiceLineKey
	,i.SalesAccountKey as SalesAccountKey
	,CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN p.ClassKey ELSE i.ClassKey END AS ClassKey
	,i.ClassKey AS ItemClassKey
    ,i.DepartmentKey
	,p.OfficeKey
	,t.ProjectKey
	,t.AmountBilled as Amount
	,t.BillableCost as Standard
From 
	tExpenseReceipt t (nolock)
	left outer join tItem  i (nolock) on t.ItemKey = i.ItemKey
	left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
Where
	t.InvoiceLineKey > 0


Union all

Select 
	'V' as Type
	,t.InvoiceLineKey
	,i.SalesAccountKey as SalesAccountKey
	,CASE WHEN ISNULL(t.ClassKey, 0) > 0 THEN t.ClassKey  
		ELSE CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN p.ClassKey
			       ELSE  i.ClassKey	
		END 
	END AS ClassKey
	,i.ClassKey AS ItemClassKey
    ,t.DepartmentKey
	,t.OfficeKey
	,t.ProjectKey
	,t.AmountBilled as Amount
	,t.BillableCost as Standard
From 
	tVoucherDetail t (nolock)
	left outer join tItem i (nolock) on t.ItemKey = i.ItemKey
	left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
Where
	t.InvoiceLineKey > 0

Union all

Select 
	'P' as Type
	,pod.InvoiceLineKey
	,i.SalesAccountKey as SalesAccountKey
	,CASE WHEN ISNULL(pod.ClassKey, 0) > 0 THEN pod.ClassKey  
		ELSE CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN p.ClassKey
			       ELSE  i.ClassKey	
		END 
	END AS ClassKey
	,i.ClassKey AS ItemClassKey
    ,pod.DepartmentKey
	,pod.OfficeKey
	,pod.ProjectKey
	,pod.AmountBilled as Amount
	,CASE 
		WHEN po.BillAt = 0 THEN pod.BillableCost
		WHEN po.BillAt = 1 THEN pod.TotalCost
		WHEN po.BillAt = 2 THEN pod.BillableCost - pod.TotalCost
		ELSE pod.BillableCost			
	END AS Standard
From 
	tPurchaseOrderDetail pod (nolock)
	inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	left outer join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
Where
	pod.InvoiceLineKey > 0
GO
