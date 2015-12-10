USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineTimeGet]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceLineTimeGet]

	(
		@InvoiceLineKey int,
		@TimeSummaryType int,    -- 1 No Summary = Detail, 2 Person & Service, 3 Service, 4 Person
								 -- 5 By Budget Task And Detail Subtask (specific to one company)
								 -- 6 By Budget Task
		@GroupLaborDetailBy int, -- 0 No grouping, 1 Person, 2 Service (Detail only)
		@Percentage decimal(24,4)
	)

AS --Encrypt

/*
|| When     Who Rel    What
|| 10/30/06 CRG 8.35   Modified to pull the tBillingDetail comments for the Invoice.
|| 12/11/06 CRG 8.4    (with help from Greg) modified how the BillingDetail comments are retreived to fix a subquery with multiple values.
|| 12/12/06 CRG 8.4    Modified to fix join to tTask when @TimeSummaryType = 5.
|| 12/28/06 GHL 8.4    Added @TimeSummaryType = 6.
|| 11/14/07 GHL 8.440  (15952) Added BilledRate when no grouping. Was displaying BilledRate with decimals
||                     differently from the invoice transactions screen  
|| 11/27/07 GHL 8.5    Removed alias in ORDER BY for SQL Server 2005
|| 03/11/08 GHL 8.5    (22295) Added BilledRate for 3 cases when @TimeSummaryType = 1
|| 10/10/12 MFT 10.561 (156524) Removed reference to tBillingDetail for comments. They are now copied during invoice generation.
                       Comments from vTimeDetail will now be BilledComment from tTime (or Comments when no BilledComment)
*/

Declare @InvoiceKey int
Select @InvoiceKey = InvoiceKey from tInvoiceLine (nolock) Where InvoiceLineKey = @InvoiceLineKey

Select @Percentage = @Percentage / 100

if @TimeSummaryType = 1
Begin

	if @GroupLaborDetailBy = 0 -- No grouping
	Select
		td.WorkDate,
		td.FirstName + ' ' + td.LastName as UserName,
		td.UserTitle,
		td.ServiceDescription,
		BilledHours * @Percentage as BilledHours,
		BilledRate,
		BilledTotal * @Percentage as BilledTotal,
		td.Comments
	from vTimeDetail td (nolock)
	Where InvoiceLineKey = @InvoiceLineKey
	Order By WorkDate

	if @GroupLaborDetailBy = 1 -- Group by Person
	Select
		td.WorkDate,
		td.FirstName + ' ' + td.LastName as UserName,
		td.UserTitle,
		td.ServiceDescription,
		BilledHours * @Percentage as BilledHours,
		BilledRate, -- Enabled when @TimeSummaryType = 1
		BilledTotal * @Percentage as BilledTotal,
		td.Comments
	from vTimeDetail td (nolock)
	Where InvoiceLineKey = @InvoiceLineKey
	Order By td.UserRate DESC, td.FirstName + ' ' + td.LastName, WorkDate

	if @GroupLaborDetailBy = 2 -- Group by Service
	Select
		td.WorkDate,
		td.FirstName + ' ' + td.LastName as UserName,
		td.UserTitle,
		td.BilledServiceDescription as ServiceDescription,
		BilledHours * @Percentage as BilledHours,
		BilledRate, -- Enabled when @TimeSummaryType = 1
		BilledTotal * @Percentage as BilledTotal,
		td.Comments
	from vTimeDetail td (nolock)
	Where InvoiceLineKey = @InvoiceLineKey
	Order By td.BilledServiceDescription, WorkDate

End


if @TimeSummaryType = 2

	Select 
		td.UserRate,
		td.FirstName + ' ' + td.LastName as UserName,
		td.UserTitle,
		td.BilledServiceDescription as ServiceDescription,
		sum(BilledHours) * @Percentage as BilledHours,
		--sum(BilledTotal) / sum(BilledHours) as BilledRate,
		sum(BilledTotal) * @Percentage as BilledTotal
	from vTimeDetail td (nolock)
	Where InvoiceLineKey = @InvoiceLineKey
	Group By
		td.UserRate, td.FirstName + ' ' + td.LastName, td.UserTitle, BilledServiceDescription
	Order By td.UserRate DESC, td.FirstName + ' ' + td.LastName, td.BilledServiceDescription
	
if @TimeSummaryType = 3

	Select 
		td.BilledServiceDescription as ServiceDescription,
		sum(BilledHours) * @Percentage as BilledHours,
		--sum(BilledTotal) / sum(BilledHours) as BilledRate,
		sum(BilledTotal) * @Percentage as BilledTotal
	from vTimeDetail td (nolock)
	Where InvoiceLineKey = @InvoiceLineKey
	Group By td.BilledServiceDescription
	Order By td.BilledServiceDescription
	
if @TimeSummaryType = 4
	Select 
		td.UserRate,
		td.FirstName + ' ' + td.LastName as UserName,
		td.UserTitle,
		sum(BilledHours) * @Percentage as BilledHours,
		--sum(BilledTotal) / sum(BilledHours) as BilledRate,
		sum(BilledTotal) * @Percentage as BilledTotal
	from vTimeDetail td (nolock)
	Where InvoiceLineKey = @InvoiceLineKey
	Group By
		td.UserRate, td.FirstName + ' ' + td.LastName, td.UserTitle
	Order By td.UserRate DESC, td.FirstName + ' ' + td.LastName
	

if @TimeSummaryType = 5
	-- By Budget Task, then Detail Task
	Select  
		bt.TaskID,
		bt.TaskName,
		ISNULL(bt.TaskID + ' - ', '') + bt.TaskName as TaskFullName,
		bt.ProjectOrder,
		dt.TaskKey,
		CAST(ISNULL(dt.Description, dt.TaskName) AS VARCHAR(4000)) as WorkDescription,
		dt.PlanComplete,
		dt.PlanStart,
		MAX(ti.WorkDate) AS WorkDate, 
		sum(ti.BilledHours) * @Percentage as BilledHours,
		sum(ROUND(ti.BilledHours * ti.BilledRate, 2) ) * @Percentage as BilledTotal
	from	tTime ti (NOLOCK)
		left outer join tTask dt (nolock) on ti.DetailTaskKey = dt.TaskKey
		left outer join tTask bt (nolock) on ti.TaskKey = bt.TaskKey 
	Where   ti.InvoiceLineKey = @InvoiceLineKey
	Group By bt.TaskID, bt.TaskName, bt.ProjectOrder, dt.TaskKey,
	CAST(ISNULL(dt.Description, dt.TaskName) AS VARCHAR(4000)), 
	dt.PlanComplete, dt.PlanStart
	Order By bt.ProjectOrder, dt.PlanComplete, dt.PlanStart
	
	
if @TimeSummaryType = 6
		-- By Budget Task only
		Select  
		bt.TaskID,
		bt.TaskName,
		ISNULL(bt.TaskID + ' - ', '') + bt.TaskName as TaskFullName,
		bt.ProjectOrder,
		bt.TaskKey,
		CAST(ISNULL(bt.Description, bt.TaskName) AS VARCHAR(4000)) as WorkDescription,
		bt.PlanComplete,
		bt.PlanStart,
		MAX(ti.WorkDate) AS WorkDate, 
		sum(ti.BilledHours) * @Percentage as BilledHours,
		sum(ROUND(ti.BilledHours * ti.BilledRate, 2) ) * @Percentage as BilledTotal
	from	tTime ti (NOLOCK)
		left outer join tTask bt (nolock) on ti.TaskKey = bt.TaskKey 
	Where   ti.InvoiceLineKey = @InvoiceLineKey
	Group By bt.TaskID, bt.TaskName, bt.ProjectOrder, bt.TaskKey,
	CAST(ISNULL(bt.Description, bt.TaskName) AS VARCHAR(4000)), 
	bt.PlanComplete, bt.PlanStart
	Order By bt.ProjectOrder, bt.PlanComplete, bt.PlanStart
GO
