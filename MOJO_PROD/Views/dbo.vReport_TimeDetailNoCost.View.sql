USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_TimeDetailNoCost]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_TimeDetailNoCost]
AS

/*
  || When     Who Rel     What
  || 12/28/06 GHL 8.4     Added Campaign ID
  || 11/06/07 CRG 8.5     (10954) Added DateBilled, Billing Item ID, and Billing Item Name
  || 11/06/07 CRG 8.5     (13158) Added Client Company Type
  || 11/07/07 CRG 8.5     (9651) Added Account Manager
  || 5/23/08  CRG 8.5.1.2 (25454) Added GLCompany
  || 7/20/08  GWG 10.0.0.6 (30741) Added GL Class from the project
  || 8/14/08  GHL 10.0.0.7 (32476) Added task description 
  || 04/06/09 MAS 10.0.2.2 (50443) Added Write-off Hours, Write-off Total, Marked Billed Hours and Marked Billed Total fields
  || 09/10/09 GHL 10.5    Added Transferred Out
  || 01/5/10  GWG 10.516   Added client's project number
  || 01/06/10 RLB 10.516   Added Task Type
  || 03/10/10 RLB 10.520   Formatting Date Worked Month
  || 04/29/10 RLB 10.522   (79487) removed time from Approved Date and Submitted Date 
  || 04/30/10 RLB 10.5.2.2 (63218)Added Parent Company Name
  || 07/28/10 RLB 10.5.3.3 (83803)Added Non Billable Project to the Data set
  || 08/30/10 RLB 10.5.3.4 (88843)Added Billed Service Code
  || 01/16/11 GWG 10.5.4.0 Added the rounding in for actual billable amount
  || 04/07/11 RLB 10.5.4.3 (108045) Removed Project Short Name
  || 06/29/11 RLB 10.5.4.5 (115335) changed tCompany to a left outer join because contacts could not have a company
  || 07/27/11 RLB 10.546 (114500) Added Line Number which is the tasks order in the projet schedule screen
  || 07/27/11 RLB 10.546  (111324) Added Campaign Segment
  || 10/8/11  GWG 10.549  Added a link to the task through the detail task key
  || 12/09/11 RLB 10.551 (121131) Added Verified
  || 01/09/12 MFT 10.552 (107579) Added Title
  || 02/29/12 MFT 10.553 Added Date Worked Week
  || 03/16/12 GHL 10.554 (137417) Add Date Time fields
  || 04/24/12 GHL 10.555 Added GLCompanyKey in order to map/restrict
  ||                     p.GLCompanySource = 0 then p.GLCompanyKey
  ||                     p.GLCompanySource = 1 then u.GLCompanyKey
  ||                     p.GLCompanySource is null i.e. no project then u.GLCompanyKey
  || 07/06/12 GHL 10.557 (148085) Getting now the parent company from the client on the project
  ||                     instead of from the company on the user
  || 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
  || 01/15/13 GWG 10.5.6.4 Added some additional fields for reporting
  || 02/13/13 WDF 10.5.6.5 (160177) Added Timesheet From/To dates
  || 05/01/13 GWG 10.5.6.7 Added users class
  || 05/22/13 MFT 10.5.6.8 (174957) Added ta.Comments
  || 08/08/13 GWG 10.5.7.0 Added Allocated Hours
  || 11/15/13 RLB 10.5.7.4 (191407) Added Yes OR No for tax 1 and 2  on tasks set on the time entry
  || 06/17/14 WDF 10.5.8.1 (217923) Added Vendor Invoice Number
  || 10/16/14 WDF 10.5.8.5 (Abelson Taylor) Added Billing Title
  || 10/28/14 WDF 10.5.8.5 (226655) Added Users Default GLCompany ID/Name
  || 12/16/14 RLB 10.5.8.7 (239571) Added Client Billing State and Company CustomFields from the client on the project
  || 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product ID
  || 03/10/15 GHL 10.5.9.0 (Abelson Taylor) Added Department at the Time 
  || 03/20/15 WDF 10.5.9.0 (Abelson Taylor) Added WriteOffDate
*/

SELECT 
	ts.CompanyKey, 
	ts.CompanyKey as OwnerCompanyKey,
	case when p.GLCompanySource = 0 then p.GLCompanyKey else u.GLCompanyKey end as GLCompanyKey,
	ts.TimeSheetKey,
	p.CustomFieldKey,
	cClient.CustomFieldKey AS CustomFieldKey2,
	cClient.CompanyName AS [Client Name], 
	cClient.CustomerID AS [Client ID],
	clad.State AS [Client Billing State],
	pcn.CompanyName AS [Parent Company],
	p.ProjectName AS [Project Name],  
	p.ProjectNumber AS [Project Number], 
	p.ClientProjectNumber AS [Client Project Number],
	pc.FirstName + ' ' + pc.LastName as [Project Primary Contact],
	p.ProjectNumber + ' \ ' + p.ProjectName AS [Project Full Name],
	pt.ProjectTypeName as [Project Type],
             cp.CampaignID as [Campaign ID],
	cp.CampaignName as [Campaign Name],
	cs.SegmentName as [Campaign Segment],
	am.FirstName + ' ' + am.LastName as [Account Manager],
	u.SystemID AS [User System ID], 
	u.FirstName AS [User First Name], 
	u.LastName AS [User Last Name], 
	u.FirstName + ' ' + u.LastName AS [User Full Name], 
	glc.GLCompanyID AS [Default GLCompany ID],
	glc.GLCompanyID + ' - ' + glc.GLCompanyName AS [Default GLCompany Full Name],
	d.DepartmentName AS [User Department],
	case when t.DepartmentKey is not null then d_t.DepartmentName 
		else case when isnull(pref.DefaultDepartmentFromUser, 0) = 1 then d.DepartmentName else d_s.DepartmentName end 
	end as [Department at the Time],	
	o.OfficeName AS [User Office Name],
	oP.OfficeName AS [Project Office Name],
	c.CompanyName AS [User Company Name],
	ta.TaskID AS [Task ID], 
	ta.TaskID + ' - ' + ta.TaskName AS [Task Full Name], 
	ta.TaskName as [Task Name],
	td.TaskID as [Assignment ID],
	td.TaskName as [Assignment Subject],
	ta.DueBy as [Task Due By],
	ta.PercComp as [Task Percent Complete],
	td.TaskID + ' - ' + td.TaskName AS [Assignment Full Name], 
	tat.TaskAssignmentType as [Task Type],
	ta.Description AS [Task Description],
	ta.ProjectOrder AS [Line Number],
	Case ISNULL(ta.Taxable, 0) When 1 then 'YES' else 'NO' end as [Task Taxable],
	Case ISNULL(ta.Taxable2, 0) When 1 then 'YES' else 'NO' end as [Task Taxable 2],
	ta.Comments AS [Task Status Comments],
	s.ServiceCode AS [Service Code], 
	bs.ServiceCode AS [Billed Service Code],
	t.RateLevel AS [Service Rate Level],
	
	Cast(Cast(MONTH(ts.DateCreated) as varchar) + '/' + Cast(DAY(ts.DateCreated) as varchar) + '/' + Cast(YEAR(ts.DateCreated) as varchar) as smalldatetime) as [Date Created],
	Cast(Cast(MONTH(ts.DateSubmitted) as varchar) + '/' + Cast(DAY(ts.DateSubmitted) as varchar) + '/' + Cast(YEAR(ts.DateSubmitted) as varchar) as smalldatetime) as [Date Submitted For Approval],
	Cast(Cast(MONTH(ts.DateApproved) as varchar) + '/' + Cast(DAY(ts.DateApproved) as varchar) + '/' + Cast(YEAR(ts.DateApproved) as varchar) as smalldatetime) as [Date Approved],
	
	ts.DateCreated as [Date And Time Created],
	ts.DateSubmitted as [Date And Time Submitted],
	ts.DateApproved as [Date And Time Approved],
	ts.StartDate as [Timesheet From],
	ts.EndDate as [Timesheet To],
	
	abk.UserName AS [Approved By],
	Case ts.Status
		When 1 then 'Not Sent For Approval'
		When 2 then 'Sent For Approval'
		When 3 then 'Rejected'
		When 4 then 'Approved' end as [Approval Status],
	wor.ReasonName AS [Write Off Reason],
	Case t.RateLevel 
		When 1 then ISNULL(s.Description1, s.Description)
		When 2 then ISNULL(s.Description2, s.Description)
		When 3 then ISNULL(s.Description3, s.Description)
		When 4 then ISNULL(s.Description4, s.Description)
		When 5 then ISNULL(s.Description5, s.Description)
		Else s.Description
	END as [Service Description],
	ti.TitleName as [Billing Title Name],
	ti.TitleID as [Billing Title ID],
	cd.DivisionName as [Client Division],
	cd.DivisionID as [Client Division ID],
	cpd.ProductName as [Client Product],
	cpd.ProductID as [Client Product ID],
	t.WorkDate AS [Date Worked], 
	DATEPART(Year, t.WorkDate) AS [Date Worked Year],
	CAST(DATEPART(Year, t.WorkDate) AS VARCHAR(4)) AS [Date Worked Year Formatted],
	DATENAME(Month, t.WorkDate) AS [Date Worked Month],
	RIGHT('0' + CAST(DATEPART(Month, t.WorkDate) AS VARCHAR(2)), 2) AS [Date Worked Month Formatted],
	t.ActualHours AS [Actual Hours Worked], 
	CASE WHEN (p.NonBillable = 0 OR p.NonBillable IS NULL) AND t.ActualRate > 0 THEN t.ActualHours
		ELSE 0 END AS [Actual Billable Hours],
	CASE WHEN p.NonBillable = 1 OR t.ProjectKey IS NULL OR t.ActualRate = 0 
		THEN t.ActualHours ELSE 0 END AS [Actual Non Billable Hours],
	CASE WHEN (p.NonBillable = 0 OR p.NonBillable IS NULL) AND t.ActualRate > 0 THEN ROUND(t.ActualHours * t.ActualRate, 2) ELSE 0 END AS [Actual Billable Amount], 
	CASE WHEN p.NonBillable = 1 OR t.ProjectKey IS NULL 
		THEN ROUND(t.ActualHours * t.ActualRate, 2) ELSE 0 END AS [Actual Non Billable Amount],
	t.ActualRate AS [Actual Billing Rate], 
	ISNULL(t.BilledHours, 0) AS [Billed Hours], 
	t.BilledRate AS [Billed Rate], 
	ROUND(t.BilledHours * t.BilledRate, 2) AS [Billed Total Amount],
	t.Comments,
	ps.ProjectStatus as [Project Status],
	CASE p.NonBillable WHEN 1 THEN 'YES' ELSE 'NO' END as [Non Billable Project],
	CASE p.Active WHEN 1 THEN 'YES' ELSE 'NO' END as [Active Project],
	CASE t.Downloaded WHEN 1 THEN 'YES' ELSE 'NO' END as Downloaded,
	v.InvoiceNumber as [Vendor Invoice Number],
	i.InvoiceNumber as [Invoice Number],
	Case When t.InvoiceLineKey IS NULL then
		Case t.WriteOff When 1 then 'Write Off' else 'Unbilled' end
		else 'Billed' end as [Billing Status],

	Case When t.InvoiceLineKey = 0 then
		t.ActualHours else 0 end as [Marked Billed Hours],

	Case When t.InvoiceLineKey = 0 then
		ROUND(t.ActualRate * t.ActualHours, 2) else 0 end as [Marked Billed Total],

	Case When t.WriteOff = 1 then
		t.ActualHours else 0 end as [Write off Hours],

	Case When t.WriteOff = 1 then
		ROUND(t.ActualRate * t.ActualHours, 2) else 0	end as [Write off Total],

	Case t.WriteOff
		When 1 then t.DateBilled
		else NULL
	end as [Write Off Date],

	Case When t.WIPPostingInKey = 0 then 'NO' else 'YES' end as [Posted Into WIP],
	Case When t.WIPPostingOutKey = 0 then 'NO' else 'YES' end as [Posted Out Of WIP],
	Case When t.Verified = 0 then 'NO' else 'YES' end as [Verified],
	CONVERT(VARCHAR(20), t.StartTime, 108 )  as [Start Time],
	CONVERT(VARCHAR(20), t.EndTime, 108 )  as [End Time],
	t.StartTime as [Start Date Time],
	t.EndTime as [End Date Time],
	Case When t.InvoiceLineKey is null then 0 else ROUND(t.ActualRate * t.ActualHours, 2) - ISNULL(ROUND(t.BilledHours * t.BilledRate, 2), 0) end AS [Billed Difference],
	ta.EstHours as [Budget Hours],
	apr.UserName as [Current Approver],
	t.DateBilled as [Date Billed],
	wt.WorkTypeID as [Billing Item ID],
	wt.WorkTypeName as [Billing Item Name],
	wti.WorkTypeID as [Billing Title Item ID],
	wti.WorkTypeName as [Billing Title Item Name],
	ct.CompanyTypeName as [Client Company Type],
	case when p.GLCompanySource = 0 then glcP.GLCompanyID else glc.GLCompanyID end as [Company ID],
	case when p.GLCompanySource = 0 then glcP.GLCompanyName else glc.GLCompanyName end as [Company Name],
	cl.ClassID as [Class ID],
	cl.ClassName as [Class Name],
	ucl.ClassID as [User Class ID],
	ucl.ClassName as [User Class Name],
	Case When t.TransferToKey IS NULL Then 'NO' else 'YES' end as [Transferred Out],
	u.Title,
	CONVERT(varchar(2), DATEPART(WEEK, t.WorkDate), 0) AS [Date Worked Week],
	Case p.BillingMethod When 1 then 'Time and Materials' When 2 then 'Fixed Fee' When 3 then 'Retainer' end as [Project Billing Method],
	p.StartDate as [Project Start Date],
	p.CompleteDate as [Project Due Date],
		-- Budgeted data
	p.EstHours + p.ApprovedCOHours as [Project Budget Hours], -- [Estimate Total Hours]
	p.EstLabor + p.ApprovedCOLabor as [Project Budget Labor Gross], -- [Estimate Total Labor]
	p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense as [Project Total Budget wo Taxes], -- [Estimate Total]
	p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense + ISNULL(p.SalesTax,0) + ISNULL(p.ApprovedCOSalesTax,0) as [Project Total Budget], --New field
	pr.BilledAmount as [Project Amount Billed],
	aa.Hours as [Allocated Hours],
	p.ProjectKey
FROM 
	tTimeSheet ts (nolock)
	INNER JOIN tPreference pref (nolock) on ts.CompanyKey = pref.CompanyKey
	INNER JOIN tTime t (nolock) ON ts.TimeSheetKey = t.TimeSheetKey 
	INNER JOIN tUser u (nolock) ON t.UserKey = u.UserKey 
	LEFT OUTER JOIN tVoucher v (nolock) ON t.VoucherKey = v.VoucherKey
	LEFT OUTER JOIN tCompany c (nolock) ON u.CompanyKey = c.CompanyKey 
	LEFT OUTER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey 
	LEFT OUTER JOIN tDepartment d (nolock) ON u.DepartmentKey = d.DepartmentKey
	LEFT OUTER JOIN tDepartment d_t (nolock) ON t.DepartmentKey = d_t.DepartmentKey
	LEFT OUTER JOIN tOffice o (nolock) ON u.OfficeKey = o.OfficeKey 
	LEFT OUTER JOIN tOffice oP (nolock) ON p.OfficeKey = oP.OfficeKey 
	LEFT OUTER JOIN tService s (nolock) ON t.ServiceKey = s.ServiceKey 
	LEFT OUTER JOIN tDepartment d_s (nolock) ON s.DepartmentKey = d_s.DepartmentKey 
	LEFT OUTER JOIN tTitle ti (nolock) ON t.TitleKey = ti.TitleKey
	LEFT OUTER JOIN tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
	LEFT OUTER JOIN tClientProduct cpd (nolock) on p.ClientProductKey = cpd.ClientProductKey
	LEFT OUTER JOIN tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	LEFT OUTER JOIN tCompany cClient (nolock) ON p.ClientKey = cClient.CompanyKey 
	LEFT OUTER JOIN tTask ta (nolock) ON t.TaskKey = ta.TaskKey
	LEFT OUTER JOIN tTask td (nolock) ON t.DetailTaskKey = td.TaskKey
	LEFT OUTER JOIN tTaskAssignmentType tat (nolock) on ta.TaskAssignmentTypeKey = tat.TaskAssignmentTypeKey
	LEFT OUTER JOIN tInvoiceLine il (nolock) on t.InvoiceLineKey = il.InvoiceLineKey
	LEFT OUTER JOIN tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
	LEFT OUTER JOIN tWriteOffReason wor (nolock) on t.WriteOffReasonKey = wor.WriteOffReasonKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tUser pc (nolock) on p.BillingContact = pc.UserKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join vUserName abk (nolock) on ts.ApprovedByKey = abk.UserKey
	left outer join vUserName apr (nolock) on u.TimeApprover = apr.UserKey
	LEFT OUTER JOIN tWorkType wt (nolock) ON s.WorkTypeKey = wt.WorkTypeKey
	LEFT OUTER JOIN tWorkType wti (nolock) ON ti.WorkTypeKey = wti.WorkTypeKey
	LEFT OUTER JOIN tCompanyType ct (nolock) ON cClient.CompanyTypeKey = ct.CompanyTypeKey
	LEFT OUTER JOIN tUser am (nolock) on p.AccountManager = am.UserKey
	LEFT OUTER JOIN tGLCompany glcP (nolock) ON p.GLCompanyKey = glcP.GLCompanyKey
	LEFT OUTER JOIN tGLCompany glc (nolock) ON u.GLCompanyKey = glc.GLCompanyKey
    LEFT OUTER JOIN tClass cl (nolock) ON p.ClassKey = cl.ClassKey
	LEFT OUTER JOIN tClass ucl (nolock) ON u.ClassKey = ucl.ClassKey
	LEFT OUTER JOIN tCompany pcn (nolock) ON cClient.ParentCompanyKey = pcn.CompanyKey
	LEFT OUTER JOIN tService bs (nolock) ON t.BilledService = bs.ServiceKey
	LEFT OUTER JOIN tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey
	LEFT OUTER JOIN tProjectRollup pr (nolock) ON p.ProjectKey = pr.ProjectKey
	LEFT OUTER JOIN tAddress clad (nolock) ON cClient.BillingAddressKey = clad.AddressKey
	LEFT OUTER JOIN (Select UserKey, TaskKey, Sum(Hours) as Hours from tTaskUser (nolock) Group By UserKey, TaskKey) as aa on t.UserKey = aa.UserKey and ISNULL(t.DetailTaskKey, t.TaskKey) = aa.TaskKey
GO
