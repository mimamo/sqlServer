USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeGetUserForWorkDate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeGetUserForWorkDate]
	@UserKey int,
	@WorkDate smalldatetime,
	@EndWorkDate smalldatetime = NULL
AS --Encrypt

/*
|| When      Who Rel     What
|| 3/28/08   CRG 1.0.0.0 Added RegisteredUser, Billed, WipPost, BillingDetail, Status, UserKey. 
||                       These are used to determine whether a Time entry can be modified.
|| 4/22/08   QMD 1.0.0.0 Changed Status "Not Sent For Approval" to "Unapproved"
|| 06/15/12  RLB 10.557  (144531) Order by WorkDate then StartTime
|| 06/19/13  WDF 10.569  (181720) Add Campaign ID/Name
|| 08/23/13  RLB 10.571  (187974) Added Client ID from project clientkey
|| 01/21/14  GWG 10.577  Added the keys for the new app
|| 11/20/14  CRG 10.586  Added optional @EndWorkDate to allow a range of time entries to be loaded for a user
|| 02/03/15  CRG 10.589  Changed ServiceName to ServiceDescription to match other stored procedures
|| 04/15/15  MAS 10.591  Added ActualHoursTotal, AllocatedHours,PriorityName, ProjectStatus,CampaignName,ProjectTypeName
*/

	DECLARE	@Registered tinyint,
			@ShowActualHours int,
			@CompanyKey int
		
	Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) From tUser (nolock) Where UserKey = @UserKey		
	Select @ShowActualHours = ISNULL(ShowActualHours, 0) From tPreference (nolock) Where CompanyKey = @CompanyKey	

	if exists(Select 1 From tUser (nolock) Where UserKey = @UserKey and	Len(UserID) > 0 and	Active = 1 and ClientVendorLogin = 0)
		Select @Registered = 1
	else
		Select @Registered = 0
	
	SELECT	t.TimeKey,
			t.ActualHours,
			t.WorkDate,
			t.StartTime,
			t.EndTime,
			p.ProjectKey,
			p.ProjectNumber, 
			p.ProjectName,
			ta.TaskKey,
			ta.TaskID, 
			ta.TaskName,
			ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '') AS ProjectFullName,
			ISNULL(ta.TaskID, '') + '-' + ISNULL(ta.TaskName, '') AS TaskFullName,
			cc.CustomerID,
			c.CampaignID,
			c.CampaignName,
			ISNULL(c.CampaignID, '') + '-' + ISNULL(c.CampaignName, '') AS CampaignFullName,
			CASE t.RateLevel 
				WHEN 1 THEN ISNULL(s.Description1, ISNULL(s.Description, '[No Service]'))
				WHEN 2 THEN ISNULL(s.Description2, ISNULL(s.Description, '[No Service]'))
				WHEN 3 THEN ISNULL(s.Description3, ISNULL(s.Description, '[No Service]'))
				WHEN 4 THEN ISNULL(s.Description4, ISNULL(s.Description, '[No Service]'))
				WHEN 5 THEN ISNULL(s.Description5, ISNULL(s.Description, '[No Service]'))
				ELSE ISNULL(s.Description, '[No Service]')
			END AS ServiceDescription,
			CASE t.RateLevel 
				WHEN 1 THEN ISNULL(s.Description1, ISNULL(s.Description, '[No Service]'))
				WHEN 2 THEN ISNULL(s.Description2, ISNULL(s.Description, '[No Service]'))
				WHEN 3 THEN ISNULL(s.Description3, ISNULL(s.Description, '[No Service]'))
				WHEN 4 THEN ISNULL(s.Description4, ISNULL(s.Description, '[No Service]'))
				WHEN 5 THEN ISNULL(s.Description5, ISNULL(s.Description, '[No Service]'))
				ELSE ISNULL(s.Description, '[No Service]')
			END AS ServiceName,			
			s.ServiceKey,
			t.RateLevel,
			t.Comments,
			ts.TimeSheetKey,
			CASE ts.Status
				WHEN 1 THEN 'Unapproved'
				WHEN 2 THEN 'Sent For Approval'
				WHEN 3 THEN 'Rejected'
				WHEN 4 THEN 'Approved'
			END	AS StatusName,
			CASE
				WHEN BillingDetailKey IS NOT NULL AND bd.Entity = 'tTime' AND b.Status < 5 THEN 1
				ELSE 0
			END AS BillingDetail,
			CASE 
				WHEN t.InvoiceLineKey IS NOT NULL OR t.WriteOff = 1 THEN 1
				ELSE 0
			END AS Billed,
			CASE
				WHEN t.WIPPostingInKey > 0 or t.WIPPostingOutKey > 0 THEN 1
				ELSE 0
			END AS WipPost,
			ts.Status,
			t.UserKey,
			@Registered AS RegisteredUser,
			CASE ta.Priority
				WHEN 1 THEN '1 - High'
				WHEN 2 THEN '2 - Medium'
				WHEN 3 THEN '3 - Low'
				ELSE ''
			END AS PriorityName,
			ISNULL(ps.ProjectStatus, '') As ProjectStatus,
			ISNULL(pt.ProjectTypeName, '') As ProjectTypeName,
			CASE @ShowActualHours
				WHEN 0 THEN 
					(ISNULL((SELECT SUM(ti.ActualHours) 
					FROM tTime ti WITH (INDEX=IX_tTime_1, NOLOCK) 
					WHERE ti.UserKey = @UserKey
					AND (ti.TaskKey = t.TaskKey OR ti.DetailTaskKey = t.TaskKey)
					AND (t.ServiceKey is null OR ti.ServiceKey = t.ServiceKey)), 0))
				WHEN 1 THEN 
					(ISNULL((SELECT SUM(ti.ActualHours) 
					FROM tTime ti WITH (INDEX=IX_tTime_1, NOLOCK) 
					WHERE ti.UserKey = @UserKey
					AND (ti.TaskKey = t.TaskKey OR ti.DetailTaskKey = t.TaskKey)), 0))				
			END AS ActualHoursTotal,
			(ISNULL((Select SUM(Hours) From tTaskUser tu (nolock) Where t.TaskKey = tu.TaskKey) ,0)) As AllocatedHours			
	FROM	tTime t (nolock)
	INNER JOIN tTimeSheet ts (nolock) ON t.TimeSheetKey = ts.TimeSheetKey
	LEFT JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
	LEFT JOIN tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	LEFT JOIN tCampaign c (nolock) ON p.CampaignKey = c.CampaignKey
	LEFT JOIN tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	LEFT JOIN tTask ta (nolock) ON t.TaskKey = ta.TaskKey
	LEFT JOIN tService s (nolock) ON t.ServiceKey = s.ServiceKey
	LEFT JOIN tBillingDetail bd (nolock) ON t.TimeKey = bd.EntityGuid
	LEFT JOIN tBilling b (nolock) ON bd.BillingKey = b.BillingKey
	LEFT JOIN tCompany cc (nolock) ON p.ClientKey = cc.CompanyKey
	WHERE	t.UserKey = @UserKey
	AND		(@EndWorkDate IS NOT NULL AND t.WorkDate BETWEEN @WorkDate AND @EndWorkDate
			OR	
			t.WorkDate = @WorkDate)

	ORDER By t.WorkDate, t.StartTime
GO
