USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetAttendeeAssigned]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetAttendeeAssigned]
	(
		@UserKey INT
	)
AS -- Encrypt
	SET NOCOUNT ON

	DECLARE @CompanyKey INT
	
	SELECT @CompanyKey = CompanyKey
	FROM   tUser (NOLOCK)
	WHERE  UserKey = @UserKey
	
	-- Assume done in web page, only CalendarKey should be populated
	--CREATE TABLE #tSchedule (UserKey int null, CalendarKey int null, IsAttendee int null, IsAssigned int null)

	UPDATE #tSchedule
	SET    UserKey = @UserKey, IsAttendee = 0, IsAssigned = 0 
	
	-- Add other users sharing calendars with this user
	INSERT #tSchedule (UserKey, CalendarKey, IsAttendee, IsAssigned)
	Select u.UserKey, b.CalendarKey, 0, 0
	From
		tUser u (nolock) inner join tCalendarUser c (nolock) on u.UserKey = c.UserKey
		,#tSchedule b		-- Cross Join on 
	Where c.CalendarUserKey = @UserKey
	and   u.CompanyKey = @CompanyKey	
	and   u.Active = 1
	and   c.AccessType > 0
	
	-- Update flags
	UPDATE #tSchedule 
	SET    #tSchedule.IsAttendee = 1
	FROM   tCalendarAttendee ca (nolock) 
	WHERE  #tSchedule.CalendarKey = ca.CalendarKey
	AND    #tSchedule.UserKey = ca.EntityKey
	AND    ca.Entity <> 'Resource' 
	AND    ca.Entity <> 'Group' 
	AND    ca.Status <> 3 
		  
	UPDATE #tSchedule 
	SET    #tSchedule.IsAssigned = 1
	FROM   tAssignment a (nolock)
			inner join tCalendar c (NOLOCK) ON a.ProjectKey = c.ProjectKey
	WHERE  #tSchedule.CalendarKey = c.CalendarKey
	AND    #tSchedule.UserKey = a.UserKey
	AND    c.CompanyKey = @CompanyKey
	
	SELECT * FROM #tSchedule
					
	RETURN 1
GO
