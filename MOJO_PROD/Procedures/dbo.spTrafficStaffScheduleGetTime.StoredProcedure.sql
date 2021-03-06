USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTrafficStaffScheduleGetTime]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTrafficStaffScheduleGetTime]
	(
		@CompanyKey int,
		@StartDate datetime,
		@EndDate datetime,
		@OfficeKey int = NULL,
		@ServiceKey int = NULL,
		@UserKey int = NULL,
		@SearchProjectKey int = NULL,
		@ClientKey int = NULL,
		@GLCompanyKey int = null,
		@LoggedUserKey int = null
	)
	
AS

  /*
  || When     Who Rel       What
  || 11/11/11 RLB 105.5.0	(118328) Created for enhancement of New Staff Schedule passing in temp tables with Department and Team keys
  || 11/30/11 RLB 105.5.0   (109878) Added GL Company Filter
  || 02/08/12 RLB 10.5.5.2  Project status is not being used so i removed the field because i am not passing in a temp table if project status is needed.
  || 02/20/12 GWG 10.5.5.3  Added a date and verified filter for time so that only unverified time after today shows up.
  || 03/15/12 GWG 10.5.5.4  Fixed the filter as it was looking at the wrong field (was on task, should have been on time entry)
  || 04/30/12 GHL 10.5.5.5  Added @LoggedUserKey and logic for tUserGLCompanyAccess
  ||                        Note: @UserKey is the assigned user key from the user drop down, we need the logged user key
  || 09/10/13 RLB 10.5.7.2  (187729) Added Project Type as a filter on staff schedule
  || 10/24/13 RLB 10.5.7.3  (193931) made actual hours = hours
  */
 
 	DECLARE @AllDepartments int, @AllTeams int, @AllProjectTypes int
	
	if (Select  count(*) from #departmentKeys) = 0
		Select @AllDepartments = 0
	else
		Select @AllDepartments = 1
		
	if (Select  count(*) from #teamKeys) = 0
		Select @AllTeams = 0
	else
		Select @AllTeams = 1

	if (Select  count(*) from #projectTypeKeys) = 0
		Select @AllProjectTypes = 0
	else
		Select @AllProjectTypes = 1  
 
 Declare @RestrictToGLCompany int

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
		from tUser u (nolock)
		inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		Where u.UserKey = @LoggedUserKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

Select 
	'tTime' as Entity
	,t.TimeKey
	,t.TaskKey
	,t.DetailTaskKey
	,t.UserKey
	,t.ServiceKey
	,u.FirstName + ' ' + u.LastName				AS FormattedName
	,p.ProjectNumber + ' - ' + ProjectName		AS ProjectFullName
    ,t.ProjectKey								AS ProjectKey
    ,ta.TaskID
    ,ta.TaskName
	,t.WorkDate									AS PlanStart
	,t.WorkDate									AS PlanComplete
	,1											AS PlanDuration
	,1											AS WorkAnyDay
	,t.ActualHours								AS Hours
	,t.Comments
	,t.StartTime
	,t.EndTime
	,t.Verified
	,u.CompanyKey
	,1 AS WorkSun, 1 AS WorkMon, 1 AS WorkTue, 1 AS WorkWed, 1 AS WorkThur, 1 AS WorkFri, 1 AS WorkSat 
	,0											AS PercComp
	,t.ActualHours
From
	tTime t (nolock)
	inner join tUser u (nolock) on t.UserKey = u.UserKey
	inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	left outer join tTask ta (nolock) on ISNULL(t.DetailTaskKey, t.TaskKey) = ta.TaskKey
Where
		  t.WorkDate >= @StartDate
	AND   t.WorkDate <= @EndDate
	AND   ((t.WorkDate < dbo.fFormatDateNoTime(GETDATE()) AND Verified = 1) OR Verified = 0)
	AND   p.CompanyKey = @CompanyKey
	AND   (@OfficeKey IS NULL OR u.OfficeKey = @OfficeKey)
	--AND   (@GLCompanyKey IS NULL OR p.GLCompanyKey = @GLCompanyKey)

	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @LoggedUserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

    AND   (@AllProjectTypes = 0 or ISNULL(p.ProjectTypeKey, 0) in (Select ProjectTypeKey from #projectTypeKeys))
	AND   (@AllDepartments = 0 or ISNULL(u.DepartmentKey, 0) in (Select DepartmentKey from #departmentKeys))
	AND   (@SearchProjectKey IS NULL OR p.ProjectKey = @SearchProjectKey)
	AND   (@ClientKey IS NULL OR p.ClientKey = @ClientKey)
	AND   (@AllTeams = 0 or t.UserKey in (Select UserKey from tTeamUser (nolock) inner join #teamKeys on tTeamUser.TeamKey = #teamKeys.TeamKey))
	
	
	/*	Removed so that all time is pulled regardless of the status of projects you are searching for
		AND   (
			(@ProjectStatusKey = -1 AND p.Active = 1)
			 OR 
			(@ProjectStatusKey = -2 AND p.Active = 0 )
			OR
			 @ProjectStatusKey = -3
			OR
			 p.ProjectStatusKey = @ProjectStatusKey
		  )
	AND	  (@ServiceKey IS NULL OR t.ServiceKey = @ServiceKey) */
	
	AND   u.Active = 1	
	AND   t.TransferToKey is null
GO
