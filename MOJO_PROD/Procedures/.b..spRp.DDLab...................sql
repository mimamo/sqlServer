USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptDDLabor]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptDDLabor]

	(
		@ProjectKey int,
		@TaskKey int = null
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/31/07  CRG 8.5     Changed tTask to Left Join so that it'll return Time entries with no Task.
|| 11/12/07  CRG 8.5     Wrapped TaskKey with ISNULL.
|| 03/13/08  CRG 1.0.0.0 Added columns for new Project Budget View
|| 1/4/11    RLB 10.539  (94940)Change made for Flex Labor DD
|| 1/11/11   RLB 10.539  (100043)pulling billing comments for comments if nothing then use comments
|| 11/17/14  GHL 10.586  Added Title info for Abelson Taylor
*/

	Select
		t.TimeSheetKey,
		ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName,
		t.WorkDate,
		t.ProjectKey,
		p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName,
		ta.TaskID,
		ISNULL(ta.TaskKey, 0) AS TaskKey,
		Case t.RateLevel 
		When 1 then ISNULL(s.Description1, ISNULL(s.Description, '[No Service]'))
		When 2 then ISNULL(s.Description2, ISNULL(s.Description, '[No Service]'))
		When 3 then ISNULL(s.Description3, ISNULL(s.Description, '[No Service]'))
		When 4 then ISNULL(s.Description4, ISNULL(s.Description, '[No Service]'))
		When 5 then ISNULL(s.Description5, ISNULL(s.Description, '[No Service]'))
		Else ISNULL(s.Description, '[No Service]')
		END as [ServiceDescription],
		ISNULL(s.ServiceKey, 0) AS ServiceKey,
		t.RateLevel,
		t.ActualHours,
		t.ActualRate,
		ROUND(t.ActualHours * t.ActualRate, 2) as TotalAmount,
		t.InvoiceLineKey,
		t.WriteOff,
		ISNUlL(t.BilledComment, t.Comments) as Comments,
		t.CostRate,
		ROUND(t.ActualHours * t.CostRate, 2) as ActualCost,
		t.StartTime,
		t.EndTime,
		t.BilledComment,
		CASE 
			WHEN t.InvoiceLineKey IS NULL THEN
				CASE t.WriteOff
					WHEN 1 THEN 'Written Off'
					ELSE 'Unbilled'
				END
			ELSE 'Billed'
		END AS BillingStatus,
		i.InvoiceNumber,
		i.InvoiceDate,
		i.PostingDate,
		t.BilledHours,
		t.BilledRate,
		ROUND(t.BilledHours * t.BilledRate, 2) AS BilledTotal,
		CASE ts.Status
			WHEN 1 THEN 'Not Sent For Approval'
			WHEN 2 THEN 'Sent For Approval'
			WHEN 3 THEN 'Rejected'
			WHEN 4 THEN 'Approved' 
		END AS Status,
		CASE t.WIPPostingInKey 
			WHEN 0 THEN 0
			ELSE 1
		END AS PostedIntoWIP,
		CASE t.WIPPostingOutKey 
			WHEN 0 THEN 0
			ELSE 1
		END AS PostedOutOfWIP,
		t.TransferComment,
		ISNULL(ta.TaskID, '') + ' - ' + ISNULL(ta.TaskName, '') AS TaskIDName,
		wor.ReasonName AS WriteOffReason,
		CASE t.WriteOff
			WHEN 1 THEN t.DateBilled
			ELSE NULL
		END AS WriteOffDate,
		CASE ts.Status
			WHEN 4 THEN 1
			ELSE 0
		END AS ApprovalStatus --Used for grid filtering
		,isnull(t.TitleKey, 0) as TitleKey
		,isnull(ti.TitleName, '[No Title]') as TitleName
	From
		tTime t (nolock)
		Left Join tTask ta (nolock) on ta.TaskKey = t.TaskKey
		Inner Join tUser u (nolock) on u.UserKey = t.UserKey
		Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
		Left Outer Join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
		LEFT JOIN tInvoiceLine il (nolock) on t.InvoiceLineKey = il.InvoiceLineKey
		LEFT JOIN tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		LEFT JOIN tWriteOffReason wor (nolock) on t.WriteOffReasonKey = wor.WriteOffReasonKey
		INNER JOIN tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
		INNER JOIN tProject p (nolock) on t.ProjectKey = p.ProjectKey
	Where
		t.ProjectKey = @ProjectKey and (@TaskKey is null or t.TaskKey = @TaskKey)
	ORDER BY t.WorkDate
GO
