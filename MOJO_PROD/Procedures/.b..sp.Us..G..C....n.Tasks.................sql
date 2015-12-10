USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetCurrentTasks]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetCurrentTasks]
	(
		@UserKey int,
		@EndDate smalldatetime
	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 12/11/14  CRG 10.5.8.7 Added ProjectFullName and TaskFullName for Platinum Time Entry
|| 02/03/15  CRG 10.5.8.9 Added User's default RateLevel and Service
|| 04/13/15  MAS 10.5.9.1 Added additional fields for user.timeEntry.edit (PriorityName,ProjectStatus,CampaignName,ProjectTypeName)
|| 04/15/15  MAS 10.5.9.1 Added Hours used/remaining for user.timeEntry.edit 
*/

DECLARE	@RateLevel int,
		@DefaultServiceKey int,
		@ServiceDescription varchar(100),
		@ShowActualHours int,
		@CompanyKey int
		
Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) From tUser (nolock) Where UserKey = @UserKey		
Select @ShowActualHours = ISNULL(ShowActualHours, 0) From tPreference (nolock) Where CompanyKey = @CompanyKey	
	

SELECT	@RateLevel = u.RateLevel,
		@DefaultServiceKey = u.DefaultServiceKey,
		@ServiceDescription = s.Description
FROM	tUser u (nolock)
LEFT JOIN tService s (nolock) ON u.DefaultServiceKey = s.ServiceKey
WHERE	u.UserKey = @UserKey

Select Distinct
		p.ProjectNumber,
		p.ProjectName,
		p.ProjectKey,
		t.TaskID,
		t.TaskName,
		t.TaskKey,
		ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '') AS ProjectFullName,
		ISNULL(t.TaskID, '') + '-' + ISNULL(t.TaskName, '') AS TaskFullName,
		@RateLevel AS RateLevel,
		@DefaultServiceKey AS ServiceKey,
		@ServiceDescription AS ServiceDescription,
		CASE t.Priority
			WHEN 1 THEN '1 - High'
			WHEN 2 THEN '2 - Medium'
			WHEN 3 THEN '3 - Low'
			ELSE ''
		END AS PriorityName,
		ISNULL(cp.CampaignID, '') + '-' + ISNULL(cp.CampaignName, '') AS CampaignFullName,
		ISNULL(ps.ProjectStatus, '') AS ProjectStatus,
		ISNULL(pt.ProjectTypeName, '') AS ProjectTypeName,
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
From	tTask t (nolock)
inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
Where	t.TaskKey in
			(Select	t2.BudgetTaskKey
			From	tTask t2 (NOLOCK)
			inner join tTaskUser tu (nolock) on t2.TaskKey = tu.TaskKey
			Where	tu.UserKey = @UserKey
			And		((t2.PercCompSeparate = 0 And ISNULL(t2.PercComp, 0) < 100) Or (t2.PercCompSeparate = 1 And ISNULL(tu.PercComp, 0) < 100)))
and		t.PlanStart <= @EndDate 
and		p.Active = 1 
and		ps.TimeActive = 1
and		t.TrackBudget = 1
Order By
	p.ProjectNumber, t.TaskID
GO
