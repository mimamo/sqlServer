USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetAttendingResources]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarGetAttendingResources]

	(
		@CalendarKey int
	)

AS --Encrypt


Select c.*,
	ca.CalendarAttendeeKey,	
	cr.CalendarResourceKey * -1 as CalendarResourceKey,
	ca.Entity,
	ca.EntityKey,
	ca.Status,	
	ca.Optional,
	cr.ResourceName as ResourceName

From
	tCalendar c (nolock)		
	Left Outer Join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey 
	Left Outer Join tCalendarResource cr (nolock) on ca.EntityKey = cr.CalendarResourceKey	
	
Where
	c.CalendarKey = @CalendarKey 
	and ca.Entity = 'Resource' 



Order by ca.Entity desc
GO
