USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarAttendeeGetList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarAttendeeGetList]
	(
		@CalendarKey INT
		,@Entity VARCHAR(50)
	)
AS -- Encrypt

/*
|| When     Who Rel			What
|| 1/11/07  CRG 8.4			Added AttendeeEmail to the Attendee query for use with ICS files.
|| 5/14/07  CRG 8.4.3		(8948) Added Attendee Status to the Attendee query to display on the event detail page.
|| 9/05/13  KMC 10.5.7.1	(189075) Added additional AttendeeName2 to return name without (Will Attend) or
||							(Cannot Attend) suffix for the ICS file.
*/

	SET NOCOUNT ON

	IF @Entity = 'Attendee'
		
		SELECT	ca.*
				,'U'+Cast(ca.EntityKey As Varchar(100) ) As EntityID
				,CASE ca.Status
					WHEN 2 THEN ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') + ' (Will Attend)'
					WHEN 3 THEN ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') + ' (Cannot Attend)'
					ELSE ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '')
				END AS AttendeeName
				,CASE ca.Status
					WHEN 2 THEN ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '')
					WHEN 3 THEN ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '')
					ELSE ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '')
				END AS AttendeeName2
		       ,u.Email as AttendeeEmail
		FROM   tCalendarAttendee ca (NOLOCK)
			LEFT OUTER JOIN tUser u (NOLOCK) ON ca.EntityKey = u.UserKey
		WHERE  ca.CalendarKey = @CalendarKey
		AND    ca.Entity = 'Attendee'
		
	ELSE IF @Entity = 'Group'
		
		SELECT ca.*
		       ,'G'+Cast(ca.EntityKey As Varchar(100) ) As EntityID
		       ,dg.GroupName As AttendeeName  
		FROM   tCalendarAttendee ca (NOLOCK)
			LEFT OUTER JOIN tDistributionGroup dg (NOLOCK) ON ca.EntityKey = dg.DistributionGroupKey
		WHERE  ca.CalendarKey = @CalendarKey
		AND    ca.Entity = 'Group'
			
	ELSE IF @Entity = 'Resource'

		SELECT ca.*
		       ,'R'+Cast(ca.EntityKey As Varchar(100) ) As EntityID
		       ,cr.ResourceName As AttendeeName  
		FROM   tCalendarAttendee ca (NOLOCK)
			LEFT OUTER JOIN tCalendarResource cr (NOLOCK) ON ca.EntityKey = cr.CalendarResourceKey
		WHERE  ca.CalendarKey = @CalendarKey
		AND    ca.Entity = 'Resource'

	IF @Entity = 'Organizer'
		
		SELECT ca.*
		       ,'U'+Cast(ca.EntityKey As Varchar(100) ) As EntityID
		       ,u.FirstName + ' ' + u.LastName as AttendeeName
		FROM   tCalendarAttendee ca (NOLOCK)
			LEFT OUTER JOIN tUser u (NOLOCK) ON ca.EntityKey = u.UserKey
		WHERE  ca.CalendarKey = @CalendarKey
		AND    ca.Entity = 'Organizer'
	
	RETURN 1
GO
