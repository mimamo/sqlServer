USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetResourceEventList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetResourceEventList]
	(
		@CalendarResourceKey INT,
		@CompanyKey int,
		@StartDate as datetime,
		@EndDate as datetime
	)
AS
	SET NOCOUNT ON
	
	-- Created in 81 to detect conflicts when creating calendar events
	
	SELECT  c.*, u.TimeZoneIndex
	FROM	tCalendarAttendee ca (NOLOCK)
		INNER JOIN tCalendar c (NOLOCK) ON ca.CalendarKey = c.CalendarKey
		INNER JOIN tCalendarAttendee caOrg (nolock) on caOrg.CalendarKey = c.CalendarKey and caOrg.Entity = 'Organizer'
		INNER JOIN tUser u (nolock) on u.UserKey = caOrg.EntityKey
	WHERE 
		((c.EventEnd >= @StartDate AND c.EventStart <= @EndDate) or 
		(c.Recurring = 1) or (ParentKey > 0))
	AND	c.CompanyKey = @CompanyKey 
	AND ca.Entity = 'Resource'
	AND ca.EntityKey = @CalendarResourceKey
	AND u.Active = 1
	
	RETURN 1
GO
