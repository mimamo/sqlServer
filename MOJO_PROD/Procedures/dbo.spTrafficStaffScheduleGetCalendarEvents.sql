USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTrafficStaffScheduleGetCalendarEvents]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTrafficStaffScheduleGetCalendarEvents]
(
		@CompanyKey int,
		@StartDate datetime,
		@EndDate datetime,
		@ProjectStatusKey int,
		@OfficeKey int = NULL,
		@ServiceKey int = NULL,
		@SkillKey int = NULL,
		@UserKey int = NULL,
		@SearchProjectKey int = NULL,
		@ClientKey int = NULL,
		@GLCompanyKey int = NULL,
		@LoggedUserKey int = null
	)
AS --Encrypt

  /*
  || When     Who Rel       What
  || 11/11/11 RLB 105.5.0	(118328) Created for enhancement of New Staff Schedule passing in temp tables with Department and Team keys   
  || 11/30/11 RLB 105.5.0   (109878) Added GL Company Filter 
  || 04/30/12 GHL 10.5.5.5  Added @LoggedUserKey and logic for tUserGLCompanyAccess
  ||                        Note: @UserKey is the assigned user key from the user drop down, we need the logged user key
  || 7/3/12   CRG 10.5.5.7  (147941) Hiding the subject of private meetings
  || 09/10/13 RLB 10.5.7.2  (187729) Added Project Type as a filter on staff schedule
  */
  
	SET NOCOUNT ON

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


	SELECT 'tCalendar'		AS Entity
			,c.CalendarKey	AS TaskKey
			,CASE c.Private
				WHEN 1 THEN 'Private meeting'
				ELSE c.Subject	
			END AS FormattedName
			,''				AS ProjectNumber
		    ,''				AS ProjectName
		    ,0				AS ProjectKey
		    ,CAST(NULL AS DATETIME)			AS PlanStart -- We will convert from UTC to regular
		    ,CAST(NULL AS DATETIME)			AS PlanComplete -- We will convert from UTC to regular
		    ,1				AS PlanDuration
		    ,1				AS WorkAnyDay
		    -- get diff as DECIMAL(24, 4) like tTaskUser.Hours
		    ,ROUND(CAST(DATEDIFF(minute, c.EventStart, c.EventEnd) AS DECIMAL(24, 4)) / 60.0, 2)
		    AS Hours
		    ,u.UserKey
		    ,u.CompanyKey
		    ,1 AS WorkSun, 1 AS WorkMon, 1 AS WorkTue, 1 AS WorkWed, 1 AS WorkThur, 1 AS WorkFri, 1 AS WorkSat 
		    ,0 AS PercComp
		    ,0 AS ActualHours			
		    ,c.EventStart	-- We will convert from UTC to regular
		    ,c.EventEnd		-- We will convert from UTC to regular
		    ,(Select u_org.TimeZoneIndex 
					From tCalendarAttendee ca_org (NOLOCK)
					INNER JOIN tUser u_org (NOLOCK) ON ca_org.EntityKey = u_org.UserKey
				WHERE ca_org.CalendarKey = c.CalendarKey
				AND   ca_org.Entity = 'Organizer'	
		        ) AS TimeZoneIndex
			,1 As ValidDate -- after UTC to local conversion, determine if valid or not
			,u2.UserName AS Organizer
	FROM   tCalendar c (NOLOCK)
		INNER JOIN tCalendarAttendee ca (NOLOCK) ON c.CalendarKey = ca.CalendarKey and (ca.Entity = 'Organizer' or ca.Entity = 'Attendee')
		INNER JOIN tUser u (nolock) on ca.EntityKey = u.UserKey
		INNER JOIN tCalendarAttendee ca2 (nolock) ON c.CalendarKey = ca2.CalendarKey and ca2.Entity = 'Organizer'
		inner join vUserName u2 (nolock) on ca2.EntityKey = u2.UserKey
		inner join tCMFolder fo (nolock) on ca.CMFolderKey = fo.CMFolderKey
		left outer join tProject p (nolock) on c.ProjectKey = p.ProjectKey
	WHERE  c.CompanyKey = @CompanyKey
	AND	   fo.UserKey > 0
	AND    c.BlockOutOnSchedule = 1
	AND    c.AllDayEvent = 0
	AND    c.EventStart > dateadd("d",-1,@StartDate)  -- due to variations in time zone, get events from the day before 
	AND    c.EventStart < dateadd("d",1,@EndDate)  -- due to variations in time zone, get events from the day before 
	AND    (ca.Status = 1 or ca.Status = 2)  -- attendee has not declined yet	

	AND   (@OfficeKey IS NULL OR u.OfficeKey = @OfficeKey)
	AND   (@AllDepartments = 0 or ISNULL(u.DepartmentKey, 0) in (Select DepartmentKey from #departmentKeys))
	--AND   @ProjectStatusKey 
	AND	  (@ServiceKey IS NULL OR @ServiceKey IN (SELECT us.ServiceKey FROM tUserService us (NOLOCK)
				WHERE us.UserKey = u.UserKey))
	AND	  (@SkillKey IS NULL OR @SkillKey IN (SELECT us2.SkillKey FROM tUserSkill us2 (NOLOCK)
				WHERE us2.UserKey = u.UserKey))
	AND   (@SearchProjectKey IS NULL OR c.ProjectKey = @SearchProjectKey )
	AND   (@ClientKey IS NULL OR @ClientKey IN (SELECT ClientKey FROM tProject (NOLOCK)
				WHERE ProjectKey = c.ProjectKey))	
/*
	AND   (@GLCompanyKey IS NULL OR @GLCompanyKey IN (SELECT GLCompanyKey FROM tProject (NOLOCK)
				WHERE ProjectKey = c.ProjectKey))				
*/

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

	AND    u.Active = 1
	AND    u2.Active = 1
	AND   (@UserKey IS NULL OR u.UserKey = @UserKey)
	AND   (@AllProjectTypes = 0 or ISNULL(p.ProjectTypeKey, 0) in (Select ProjectTypeKey from #projectTypeKeys))
	AND   (@AllTeams = 0 or u.UserKey in (Select UserKey from tTeamUser (nolock) inner join #teamKeys on tTeamUser.TeamKey = #teamKeys.TeamKey))
	AND	  ISNULL(c.Deleted, 0) = 0
	ORDER BY c.EventStart
	
	RETURN 1
GO
