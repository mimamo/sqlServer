USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetAttendees]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetAttendees]

	(
		@CalendarKey int,
		@Basic tinyint = 0 --Used by TaskManager to get the attendees for a meeting
	)

AS --Encrypt

/*
|| When       Who Rel      What
|| 06/03/08   CRG 10.0.0.0 (27405) Added OrganizerTimeZoneIndex
|| 08/19/09   CRG 10.5.0.7 (60429) Added optional @Basic parameter to just get the list of attendees for a meeting with no left joins
|| 11/29/12   QMD 10.5.6.2 Added AttendeeCMFolderKey
|| 05/16/13   MFT 10.5.6.8 (178488) Added u.OwnerCompanyKey, u.UserID, u.ClientVendorLogin to filter for staff only in the result set
*/

IF @Basic = 1
	SELECT	ca.*, u.FirstName, u.LastName,
		u.OwnerCompanyKey, u.UserID, u.ClientVendorLogin
	FROM	tCalendarAttendee ca (nolock)
	INNER JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey
	WHERE	ca.CalendarKey = @CalendarKey
	AND		ca.Entity <> 'Resource'
	AND		ca.Entity <> 'Group'
	AND		ca.Status <> 3
	ORDER BY ca.Entity DESC, u.FirstName, u.LastName
ELSE
	Select c.*,
		ca.CalendarAttendeeKey,	
		ca.Entity,
		ca.EntityKey,
		ca.Status,
		ca.Comments,
		ca.Optional,	
		ca.NoticeSent,
		u.UserKey,
		u.FirstName + ' ' + u.LastName as ContactName,
		u.Email,
		u.TimeZoneIndex,
		u.OwnerCompanyKey,
		u.UserID,
		u.ClientVendorLogin,
		org.TimeZoneIndex AS OrganizerTimeZoneIndex,
		ca.CMFolderKey as AttendeeCMFolderKey
	From
		tCalendar c (nolock)		
		Left Outer Join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey 
		Left Outer Join tUser u (nolock) on ca.EntityKey = u.UserKey	
		Left Outer Join tCalendarAttendee caorg (nolock) on c.CalendarKey = caorg.CalendarKey and caorg.Entity = 'Organizer'
		Left Outer Join tUser org (nolock) on caorg.EntityKey = org.UserKey
	Where
		c.CalendarKey = @CalendarKey and ca.Entity <> 'Resource' and ca.Entity <> 'Group'
	Order by ca.Entity desc, u.FirstName, u.LastName
GO
