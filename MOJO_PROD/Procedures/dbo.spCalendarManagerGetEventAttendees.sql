USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetEventAttendees]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetEventAttendees]
	@CalendarKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 8/13/08   CRG 10.5.0.0 Created for the CalendarManager to get Event attendees
|| 9/2/09    CRG 10.5.0.9 (61586) Removed Group attendee from the union. Removed the restriction on Attendees to now show attendees that were part
||                        of a group.  Also added UserName to the sort.
|| 12/10/12  QMD 10.5.6.3 Added AttendeeCMFolderKey
*/

		SELECT	0 AS SortOrder,
				ca.CalendarAttendeeKey,
				ca.CalendarKey,
				ca.Entity,
				ca.EntityKey,
				ca.Status,
				ca.NoticeSent,
				ca.Comments,
				ca.Optional,
				ca.IsDistributionGroup,
				1 AS DisplaySent,
				u.UserName,
				u.Phone1,
				u.Email,
				ca.CMFolderKey AS AttendeeCMFolderKey
		FROM	tCalendarAttendee ca (NOLOCK)
		LEFT JOIN vUserName u (NOLOCK) ON ca.EntityKey = u.UserKey
		WHERE	ca.CalendarKey = @CalendarKey
		AND		ca.Entity = 'Organizer'
		
		UNION
		
		SELECT	1,
				ca.CalendarAttendeeKey,
				ca.CalendarKey,
				ca.Entity,
				ca.EntityKey,
				ca.Status,
				ca.NoticeSent,
				ca.Comments,
				ca.Optional,
				ca.IsDistributionGroup,
				ca.NoticeSent AS DisplaySent,
				u.UserName,
				u.Phone1,
				u.Email,
				ca.CMFolderKey  AS AttendeeCMFolderKey
		FROM	tCalendarAttendee ca (NOLOCK)
		LEFT JOIN vUserName u (NOLOCK) ON ca.EntityKey = u.UserKey
		WHERE	ca.CalendarKey = @CalendarKey
		AND		ca.Entity = 'Attendee'

		UNION
		
		SELECT	3,
				ca.CalendarAttendeeKey,
				ca.CalendarKey,
				ca.Entity,
				ca.EntityKey,
				ca.Status,
				ca.NoticeSent,
				ca.Comments,
				ca.Optional,
				ca.IsDistributionGroup,
				0 AS DisplaySent,
				cr.ResourceName As UserName,
				NULL,
				NULL,
				ca.CMFolderKey  AS AttendeeCMFolderKey
		FROM	tCalendarAttendee ca (NOLOCK)
		LEFT JOIN tCalendarResource cr (NOLOCK) ON ca.EntityKey = cr.CalendarResourceKey
		WHERE	ca.CalendarKey = @CalendarKey
		AND		ca.Entity = 'Resource'	
		
		ORDER BY SortOrder, UserName
GO
