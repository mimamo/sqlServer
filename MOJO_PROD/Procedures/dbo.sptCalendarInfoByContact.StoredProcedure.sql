USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarInfoByContact]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarInfoByContact]
	@UserKey int
AS

/*
|| When     Who Rel     What
|| 06/11/09 MFT 10.500	Created
*/

SELECT
	c.*,
	ct.TypeName,
	p.ProjectNumber + ' ' + p.ProjectName AS ProjectFullName,
	l.Subject AS Opportunity,
	o.FirstName + ' ' + o.LastName AS Organizer
FROM
	tCalendar c (nolock)
	LEFT JOIN tCalendarType ct (nolock)
		ON c.CalendarTypeKey = ct.CalendarTypeKey
	LEFT JOIN tProject p (nolock)
		ON c.ProjectKey = p.ProjectKey
	LEFT JOIN tLead l (nolock)
		ON c.ContactLeadKey = l.LeadKey
	LEFT JOIN tCalendarAttendee ca (nolock)
		ON c.CalendarKey = ca.CalendarKey AND Entity = 'Organizer'
	LEFT JOIN tUser o (nolock)
		ON ca.EntityKey = o.UserKey
WHERE
	c.CalendarKey IN
	(
		SELECT
			CalendarKey
		FROM
			tCalendarAttendee ca (nolock)
		WHERE
			EntityKey = @UserKey AND
			Entity IN ('Organizer', 'Attendee')
	)
GO
