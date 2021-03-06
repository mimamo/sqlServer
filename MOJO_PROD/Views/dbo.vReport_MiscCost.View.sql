USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_MiscCost]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_MiscCost]
AS

/*
|| When      Who Rel     What
|| 10/11/07  CRG  8.5    Added Class and Department
|| 09/10/09  GHL 10.5    Added Transferred Out
|| 02/18/10  GHL 10.518  (73756) Added Amount Billed Approved
|| 07/27/11  RLB 10.546  (114500) Added Line Number which is the tasks order in the projet schedule screen
|| 04/24/12  GHL 10.555  Added GLCompanyKey in order to map/restrict
|| 08/22/12  WDF 10.559  (152086) Run function fFormatDateNoTime against DateEntered 
|| 10/29/12  CRG 10.561  (156391) Added ProjectKey
|| 01/27/15  WDF 10.588  (Abelson Taylor) Added Division and Product
*/

SELECT 
	p.CompanyKey, 
	p.GLCompanyKey,
	p.ProjectNumber AS [Project Number], 
	p.ProjectName AS [Project Name], 
	p.ProjectNumber + ' - ' + p.ProjectName AS [Project Full Name],
	case p.Closed when 1 then 'YES' else 'NO' end as [Project Closed], 
	cp.CampaignName as [Campaign Name],
	t.TaskID AS [Task ID], 
	t.TaskName AS [Task Name], 
	t.TaskID + ' - ' + t.TaskName AS [Task Full Name],
	t.ProjectOrder AS [Line Number],
	c.CompanyName AS [Client Name], 
	c.CustomerID AS [Client ID],
	it.ItemID as [Item ID],
	it.ItemName as [Item Name],
	gl.AccountNumber as [Item Expense Account],
	mc.ExpenseDate AS [Expense Date], 
	mc.ShortDescription AS Description, 
	mc.LongDescription AS Comments, 
	mc.Quantity AS Quantity, 
	mc.UnitCost AS [Unit Cost], 
	mc.UnitDescription AS [Unit Description], 
	mc.TotalCost AS [Net Amount], 
	mc.Markup,
	case mc.Billable when 1 then 'YES' else 'NO' end as Billable, 
	mc.BillableCost AS [Gross Amount], 
	mc.AmountBilled AS [Amount Billed], 
    case when isnull(i.InvoiceStatus, 0) = 4 then mc.AmountBilled else 0 end as [Amount Billed Approved],
	dbo.fFormatDateNoTime(mc.DateEntered) AS [Date Entered], 
	case mc.WriteOff when 1 then 'YES' else 'NO' end as WriteOff,
	i.InvoiceNumber AS [Invoice Number], 
	i.InvoiceDate AS [Invoice Date],
	Case When mc.WIPPostingInKey = 0 then 'NO' else 'YES' end as [Posted Into WIP],
	Case When mc.WIPPostingOutKey = 0 then 'NO' else 'YES' end as [Posted Out Of WIP],
	cl.ClassID as [Class ID],
	cl.ClassName as [Class Name],
	d.DepartmentName as Department,
	Case When mc.TransferToKey IS NULL Then 'NO' else 'YES' end as [Transferred Out],
	p.ProjectKey,
	cd.DivisionID as [Client Division ID],
    cd.DivisionName as [Client Division],
    pc.ProductID as [Client Product ID],
    pc.ProductName as [Client Product]
FROM 
	tMiscCost mc (nolock)
	Left Outer Join tProject p (nolock) on mc.ProjectKey = p.ProjectKey
	Left Outer Join tTask t (nolock) on mc.TaskKey = t.TaskKey
	Left Outer Join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	Left Outer Join tItem it (nolock) on mc.ItemKey = it.ItemKey
	Left Outer Join tInvoiceLine il (nolock) on mc.InvoiceLineKey = il.InvoiceLineKey
	Left Outer Join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
	Left Outer Join tGLAccount gl (nolock) on it.ExpenseAccountKey = gl.GLAccountKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tClass cl (nolock) on mc.ClassKey = cl.ClassKey
	left outer join tDepartment d (nolock) on mc.DepartmentKey = d.DepartmentKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  pc (nolock) on p.ClientProductKey  = pc.ClientProductKey
GO
