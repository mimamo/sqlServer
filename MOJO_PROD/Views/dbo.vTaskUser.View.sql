USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vTaskUser]    Script Date: 12/21/2015 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vTaskUser]

as 

/*
  || When     Who Rel      What
  || 9/10/10  GWG 10.5.3.5 Wrapped names in isnull so they dont return null
  || 02/14/12 MFT 10.5.5.2 Added AssignedHours
  || 04/18/12 GHL 10.5.5.5 Added p.GLCompanyKey for filtering in reports
  || 07/09/13 RLB 10.5.7.0 (183575) If no user then use service code
  || 09/10/13 RLB 10.5.7.2 (187729) Added Project Type as a filter on staff schedule
*/

Select 
	p.CompanyKey,
	p.GLCompanyKey,
	p.ProjectKey,
	p.ClientKey,
	p.Active,
	p.ProjectStatusKey,
	p.ProjectTypeKey,
	p.ProjectNumber,
	p.ProjectName,
	p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName,
	p.OfficeKey,
	p.AccountManager,
	t.TaskKey,
	t.TaskID,
	t.TaskName,
	isnull(t.TaskID + ' ', '') + t.TaskName as TaskFullName,
	t.Description,
	t.TaskStatus,
	t.PredecessorsComplete,
	t.PercCompSeparate,
	t.PercComp As TaskPercComp,
	t.ActStart As TaskActStart,
	t.ActComplete As TaskActComplete,
	t.PlanStart,
	t.PlanComplete,
	t.PlanDuration,
	t.DueBy,
	t.CustomFieldKey,
	t.ConstraintDate,
	tu.ServiceKey,
	tu.PercComp,
	tu.ActStart,
	tu.ActComplete,
	u.Email,
	u.FirstName,
	u.LastName,
	u.MiddleName,
	ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName,
	CASE
		WHEN ISNULL(u.UserKey, 0 ) > 0 Then upper(isnull(left(u.FirstName, 1), '')+isnull(left(u.MiddleName, 1), '')+isnull(left(u.LastName, 1), ''))
		ELSE s.ServiceCode END AS Initials,
	u.DepartmentKey,
	u.UserKey,
	u.Active as UserActive,
	tu.Hours AS AssignedHours
FROM 
	tTask t (nolock) 
	INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey 
	LEFT JOIN tTaskUser tu (nolock) ON t.TaskKey = tu.TaskKey
	LEFT JOIN tUser u (nolock) ON tu.UserKey = u.UserKey
	LEFT JOIN tService s (nolock) ON tu.ServiceKey = s.ServiceKey
GO
