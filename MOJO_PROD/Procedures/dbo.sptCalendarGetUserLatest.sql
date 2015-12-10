USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetUserLatest]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetUserLatest]
	@UserKey int
AS --Encrypt

	SELECT 	YEAR(MAX(c.EventEnd)) AS LatestYear
	FROM	tCalendar c (NOLOCK)
	INNER JOIN tCalendarAttendee ca (NOLOCK) ON c.CalendarKey = ca.CalendarKey AND ca.Entity='Organizer'
	WHERE ca.EntityKey = @UserKey
GO
