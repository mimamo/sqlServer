USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetAttendee]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarGetAttendee]

	(
		@CalendarKey int,
		@UserKey int
	)

AS --Encrypt


Select c.*,
	ca.CalendarAttendeeKey,	
	ca.Entity,
	ca.EntityKey,
	ca.Status,
	ca.Comments
From
	tCalendar c (nolock)		
	Left Outer Join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey 

	
Where
	c.CalendarKey = @CalendarKey 
	and ca.Entity <> 'Resource' 
	and ca.Entity <> 'Group' 
	and ca.EntityKey = @UserKey
GO
