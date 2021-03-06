USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetManageUsers]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetManageUsers]
	@UserKey int,
	@CalendarKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 8/12/08   CRG 10.5.0.0 Created for new CalendarManager
|| 8/14/09   CRG 10.5.0.7 (60064) Added query to always include the Organizer of the meeting in the list.
||                        Also changed to a temp table from a union so we could check for duplicates when inserting.
*/

	DECLARE	@SecurityGroupKey int
	
	SELECT	@SecurityGroupKey = SecurityGroupKey
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey
	
	SELECT	@UserKey AS UserKey
	INTO	#tManageUser

	INSERT	#tManageUser	
	SELECT	DISTINCT u.UserKey
	FROM	tCMFolder f (nolock)
	INNER JOIN tCMFolderSecurity fs (nolock) ON f.CMFolderKey = fs.CMFolderKey
	INNER JOIN tUser u (nolock) ON f.UserKey = u.UserKey
	WHERE	((fs.Entity = 'tUser' AND fs.EntityKey = @UserKey)
			OR
			(fs.Entity = 'tSecurityGroup' AND fs.EntityKey = @SecurityGroupKey))
	AND		fs.CanAdd = 1
	AND		f.UserKey <> 0
	AND		f.Entity = 'tCalendar'
	AND		u.Active = 1
	AND		f.UserKey <> @UserKey
	
	INSERT	#tManageUser
	SELECT	u.UserKey
	FROM	tCalendarAttendee ca (nolock)
	INNER JOIN tCalendar c (nolock) ON ca.CalendarKey = c.CalendarKey
	INNER JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey AND ca.Entity = 'Organizer'
	WHERE	c.CalendarKey = @CalendarKey
	AND		u.UserKey NOT IN (SELECT UserKey FROM #tManageUser)

	SELECT	v.UserKey, v.UserName
	FROM	vUserName v (nolock)
	INNER JOIN #tManageUser tmp ON tmp.UserKey = v.UserKey
	ORDER BY v.UserName
GO
