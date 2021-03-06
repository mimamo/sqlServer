USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTrafficGetCalendarEvents]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTrafficGetCalendarEvents]
	(
		@CompanyKey int,
		@StartDate datetime,
		@EndDate datetime,
		@ProjectStatusKey int = NULL,
		@OfficeKey int = NULL,
		@DepartmentKey int = NULL,
		@ServiceKey int = NULL,
		@SkillKey int = NULL,
		@UserKey int = NULL,
		@TeamKey int = NULL,
		@SearchProjectKey int = NULL,
		@ClientKey int = NULL
	)
AS --Encrypt

  /*
  || When     Who Rel       What
  || 03/19/08 GHL wmj	   Creation for the new traffic screens   
  || 05/19/08 CRG 10.0.0.0 Added Organizer             
  || 07/15/08 GHL 10.0.0.5 (29944) Added restriction on Active users  
  || 08/08/08 GHL 10.0.0.6 (31708) Added UserKey param
  || 11/20/08 CRG 10.0.1.3 (40899) Added Deleted = 0 so that deleted recurring events don't show on the staff schedule.
  || 9/11/09  GWG 10.5.1.0 (62978) Modified the join to the folder to be off off the attendees in the meeting. case where organizer did not put in folder, but 
  ||							   the others did and was not showing up on the SS
  || 7/01/10  RLB 10.5.3.2 (84366) added filter Organizer must be active
  || 7/29/10  MAS 10.5.3.3 (85631) added filters SearchProjectKey and ClientKey
  || 10/15/11 GWG 10.5.4.9  Added a filter for Team
  */
  
	SET NOCOUNT ON

	SELECT 'tCalendar'		AS Entity
			,c.CalendarKey	AS TaskKey
			,c.Subject		AS FormattedName
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
	WHERE  c.CompanyKey = @CompanyKey
	AND	   fo.UserKey > 0
	AND    c.BlockOutOnSchedule = 1
	AND    c.AllDayEvent = 0
	AND    c.EventStart > dateadd("d",-1,@StartDate)  -- due to variations in time zone, get events from the day before 
	AND    c.EventStart < dateadd("d",1,@EndDate)  -- due to variations in time zone, get events from the day before 
	AND    (ca.Status = 1 or ca.Status = 2)  -- attendee has not declined yet	

	AND   (@OfficeKey IS NULL OR u.OfficeKey = @OfficeKey)
	AND   (@DepartmentKey IS NULL OR u.DepartmentKey = @DepartmentKey)
	--AND   @ProjectStatusKey 
	AND	  (@ServiceKey IS NULL OR @ServiceKey IN (SELECT us.ServiceKey FROM tUserService us (NOLOCK)
				WHERE us.UserKey = u.UserKey))
	AND	  (@SkillKey IS NULL OR @SkillKey IN (SELECT us2.SkillKey FROM tUserSkill us2 (NOLOCK)
				WHERE us2.UserKey = u.UserKey))
	AND   (@SearchProjectKey IS NULL OR c.ProjectKey = @SearchProjectKey )
	AND   (@ClientKey IS NULL OR @ClientKey IN (SELECT ClientKey FROM tProject (NOLOCK)
				WHERE ProjectKey = c.ProjectKey))				
	AND    u.Active = 1
	AND    u2.Active = 1
	AND   (@UserKey IS NULL OR u.UserKey = @UserKey)
	AND   (@TeamKey IS NULL OR u.UserKey in (Select UserKey from tTeamUser (nolock) Where TeamKey = @TeamKey))
	AND	  ISNULL(c.Deleted, 0) = 0
	ORDER BY c.EventStart
	
	RETURN 1
GO
