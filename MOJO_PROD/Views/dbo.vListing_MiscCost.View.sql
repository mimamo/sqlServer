USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_MiscCost]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_MiscCost]
AS

/*
|| When      Who Rel     What
|| 09/29/10  MFT 10.535	 Created
|| 06/22/11  RLB 10.545  Added Added By field
|| 07/27/11  RLB 10.546  (114500) Added Line Number which is the tasks order in the projet schedule screen
|| 04/02/12  MFT 10.555  Added GLCompanyKey in order to map/restrict
|| 01/27/15  WDF 10.588  (Abelson Taylor) Added Division and Product
*/

SELECT
	--m.TaskKey,
	--m.EnteredByKey,
	--m.InvoiceLineKey,
	--m.TransferComment,
	--m.WriteOffReasonKey,
	--m.DateBilled,
	--m.JournalEntryKey,
	--m.OnHold,
	--m.BilledComment,
	--m.DepartmentKey,
	--m.TransferInDate,
	--m.TransferOutDate,
	--m.TransferFromKey,
	--m.WIPAmount,
	m.MiscCostKey,
	m.ProjectKey,
	m.ExpenseDate AS [Expense Date],
	m.ShortDescription AS Description,
	m.LongDescription AS Comments,
	m.Quantity AS Quantity,
	m.UnitCost AS [Unit Cost],
	m.UnitDescription AS [Unit Description],
	m.TotalCost AS [Net Cost],
	m.Markup,
	m.UnitRate AS [Unit Rate],
	CASE m.Billable WHEN 1 THEN 'YES' ELSE 'NO' END AS Billable,
	m.BillableCost AS [Gross],
	m.AmountBilled AS [Amount Billed],
	CASE WHEN ISNULL(iv.InvoiceStatus, 0) = 4 THEN m.AmountBilled ELSE 0 END AS [Amount Billed Approved],
	m.DateEntered AS [Date Entered],
	CASE m.WriteOff WHEN 1 THEN 'YES' ELSE 'NO' END AS [Write Off],
	CASE WHEN m.WIPPostingInKey = 0 THEN 'NO' ELSE 'YES' END AS [Posted Into WIP],
	CASE WHEN m.WIPPostingOutKey = 0 THEN 'NO' ELSE 'YES' END AS [Posted Out Of WIP],
	u.FirstName AS [Entered By First Name],
	u.LastName AS [Entered By Last Name],
	ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as [Added By],
	iv.InvoiceNumber AS [Invoice Number],
	p.CompanyKey,
	p.ProjectNumber AS [Project Number],
	p.ProjectName AS [Project Name],
	p.ProjectNumber + ' - ' + p.ProjectName AS [Project Full Name],
	CASE p.Closed WHEN 1 THEN 'YES' ELSE 'NO' END AS [Project Closed],
	cp.CampaignName AS [Campaign Name],
	t.TaskID AS [Task ID],
	t.TaskName AS [Task Name],
	t.TaskID + ' - ' + t.TaskName AS [Task Full Name],
	t.ProjectOrder AS [Line Number],
	c.CompanyName AS [Client Name],
	c.CustomerID AS [Client ID],
	it.ItemID AS [Item ID],
	it.ItemName AS [Item Name],
	gl.AccountNumber as [Item Expense Account],
	iv.InvoiceDate AS [Invoice Date],
	cl.ClassID AS [Class ID],
	cl.ClassName AS [Class Name],
	d.DepartmentName AS Department,
	CASE WHEN m.TransferToKey IS NULL THEN 'NO' ELSE 'YES' END AS [Transferred Out],
	CASE ISNULL(m.InvoiceLineKey, -1)
		WHEN 0 THEN 'Marked as Billed'
		WHEN -1 THEN
			CASE ISNULL(WriteOff, 0)
				WHEN 0 THEN 'Unbilled'
				ELSE 'Written Off' END
		ELSE 'Billed'
		END +
		CASE
			WHEN ISNULL(WIPPostingInKey, 0) != 0 OR ISNULL(WIPPostingOutKey, 0) != 0 THEN ' Posted to WIP' ELSE ''
	END AS Status,
	p.GLCompanyKey,
	cd.DivisionID as [Client Division ID],
    cd.DivisionName as [Client Division],
    cpr.ProductID as [Client Product ID],
    cpr.ProductName as [Client Product]
FROM
	tMiscCost m (nolock)
	LEFT JOIN tUser u (nolock) ON m.EnteredByKey = u.UserKey
	LEFT JOIN tTask t (nolock) ON m.TaskKey = t.TaskKey
	LEFT JOIN tItem it (nolock) ON m.ItemKey = it.ItemKey
	LEFT JOIN tClass cl (nolock) ON m.ClassKey = cl.ClassKey
	LEFT JOIN tDepartment d (nolock) ON m.DepartmentKey = d.DepartmentKey
	LEFT JOIN tProject p (nolock) ON m.ProjectKey = p.ProjectKey
	LEFT JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
	LEFT JOIN tInvoiceLine il (nolock) ON m.InvoiceLineKey = il.InvoiceLineKey
	LEFT JOIN tInvoice iv (nolock) ON il.InvoiceKey = iv.InvoiceKey
	LEFT JOIN tGLAccount gl (nolock) ON it.ExpenseAccountKey = gl.GLAccountKey
	LEFT JOIN tCampaign cp (nolock) ON p.CampaignKey = cp.CampaignKey
	LEFT JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    LEFT JOIN tClientProduct  cpr (nolock) on p.ClientProductKey  = cpr.ClientProductKey
GO
