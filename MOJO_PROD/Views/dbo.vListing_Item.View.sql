USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Item]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    View [dbo].[vListing_Item]
AS

/*
|| When      Who Rel     What
|| 10/10/07  CRG 8.5     Added Department, Class ID, Class Name 
||                       (class columns added to make it consistent with other views 
||                       even though it already had a GL Class column that combined them).
|| 10/8/08   GWG 10.01   Added Taxable1 and 2 columns
|| 02/14/14  PLC 10.576  Added Broadcast type
|| 03/04/14  PLC 10.577  Removed Broadcast type
*/

Select
	i.ItemKey
	,i.CompanyKey
	,i.ItemType
	,i.ItemID as [Item ID]
	,i.ItemName as [Item Name]
	,i.UnitCost as [Unit Cost]
	,i.UnitRate as [Unit Rate]
	,i.Markup
	,i.UnitDescription as [Unit Description]
	,i.StandardDescription as Description
	,i.QuantityOnHand as [Quantity on Hand]
	,bi.WorkTypeName as [Billing Item]
	,gl.AccountNumber + ' - ' + gl.AccountName as [Expense Account]
	,gl2.AccountNumber + ' - ' + gl2.AccountName as [Sales Account]
	,cl.ClassID + ' - ' + cl.ClassName as [GL Class]
	,CASE when i.Active = 1 then 'YES' else 'NO' end AS [Active]
	,CASE when i.Taxable = 1 then 'YES' else 'NO' end AS [Taxable 1]
	,CASE when i.Taxable2 = 1 then 'YES' else 'NO' end AS [Taxable 2]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,d.DepartmentName as Department
From 
	tItem i (nolock)
	left outer join tWorkType bi (nolock) on i.WorkTypeKey = bi.WorkTypeKey
	left outer join tGLAccount gl (nolock) on i.ExpenseAccountKey = gl.GLAccountKey
	left outer join tGLAccount gl2 (nolock) on i.SalesAccountKey = gl2.GLAccountKey
	left outer join tClass cl (nolock) on i.ClassKey = cl.ClassKey
	left outer join tDepartment d (nolock) on i.DepartmentKey = d.DepartmentKey
GO
