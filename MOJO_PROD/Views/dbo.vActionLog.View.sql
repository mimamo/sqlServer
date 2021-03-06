USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vActionLog]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vActionLog]
AS

 /*
  || When     Who Rel    What
  || 03/25/13 RLB 10.566 Added for TimeLine
  || 04/30/13 RLB 10.567 Fixed Edit field
  || 07/09/13 RLB 10.570 Fix for Update to Sync
  || 07/29.14 RLB 10.582 fix for bad editicon
  */
  
  
  SELECT al.Entity,
				al.EntityKey,
				al.Action,
				al.ActionDate,
				al.ActionBy,
				al.Comments,
				al.CompanyKey,
				al.Reference,
				al.ProjectKey,
				al.SourceCompanyID,
				al.UserKey,
				dbo.fFormatDateNoTime(al.ActionDate) as ActionDateFormat,
				CASE ISNULL(al.EntityKey, 0)
					WHEN 0 Then Null
					Else CASE al.Action
							WHEN 'Deleted Activity' THEN NULL
							WHEN 'Deleted Diary' THEN NULL
							WHEN 'Deleted ToDo' THEN NULL
							WHEN 'Deleted Project ToDo' THEN NULL
							WHEN 'Deleted' THEN NULL
							WHEN 'Specification Deleted' THEN NULL
							WHEN 'Project Deliverable Deleted' THEN NULL
							WHEN 'File Delete' THEN NULL
							WHEN 'Delete Project' THEN NULL
							WHEN 'Update Project Status' THEN NULL
							WHEN 'Project Added' THEN NULL
							WHEN 'Project Closed' THEN NULL
							WHEN 'Project Reopened' THEN NULL
							WHEN 'Sent Notification' THEN NULL
							WHEN 'Project Start Date Changed' THEN NULL
							WHEN 'Task Percent Updated' THEN NULL
							WHEN 'Task Reassigned' THEN NULL
							WHEN 'Project Billing Status Changed' THEN NULL
							WHEN 'Project Next Steps Updated' THEN NULL
							WHEN 'Task Completed' THEN NULL
							WHEN 'Account Manager Changed' THEN NULL
							WHEN 'Project Project Complete Date Changed' THEN NULL
							WHEN 'Users Added To Project' THEN NULL
							WHEN 'Users Removed From Project' THEN NULL
							WHEN 'Project Purchasing Markups Changed' THEN NULL
							WHEN 'Project Labor Rate Changed' THEN NULL
							WHEN 'File Deleted' THEN NULL
							WHEN 'Update to Sync' THEN NULL
							WHEN 'Project Schedule Change' Then  Null
							ELSE 'edit'
						END
				END as EditIcon,
				0 as ActualHours,
				ISNULL(p.GLCompanyKey, u.GLCompanyKey) as GLCompanyKey,
				u.DepartmentKey,
				p.AccountManager,
				p.OfficeKey,
				p.ProjectNumber + '-' + p.ProjectName as FullProjectName					
	FROM tActionLog al (nolock)
	LEFT OUTER JOIN tUser u (nolock) ON al.UserKey = u.UserKey
	LEFT OUTER JOIN tProject p (nolock) ON al.ProjectKey = p.ProjectKey

	Union ALL


	SELECT 'Time' as Entity,
				ts.TimeSheetKey as EntityKey,
				'Time Entered' as Action,
				t.WorkDate as ActionDate,
				u.FirstName + ' ' + u.LastName as ActionBy,
				CAST(CAST(Round(ISNULL(t.ActualHours, 0), 2) as decimal(24,2)) as varchar) + ' hours was entered on project ' + p.ProjectNumber + '-'+ p.ProjectName + ' for task ' + tk.TaskID + '-' + tk.TaskName as Comments,
				ts.CompanyKey,
				u.FirstName + ' ' + u.LastName as ActionBy,
				t.ProjectKey,
				'' as SourceCompanyID,
				t.UserKey,
				t.WorkDate as ActionDateFormat,
				'edit' as EditIcon,
				t.ActualHours,
				ISNULL(p.GLCompanyKey, u.GLCompanyKey) as GLCompanyKey,
				u.DepartmentKey,
				p.AccountManager,
				p.OfficeKey,
				p.ProjectNumber + '-' + p.ProjectName as FullProjectName					
	FROM tTime t with (index=IX_tTime_8, nolock)
	INNER JOIN tTimeSheet ts (nolock) ON t.TimeSheetKey = ts.TimeSheetKey
	INNER JOIN tUser u (nolock) ON t.UserKey = u.UserKey
	INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
	INNER JOIN tTask tk (nolock) ON t.TaskKey = tk.TaskKey
	where t.TransferToKey is null
GO
