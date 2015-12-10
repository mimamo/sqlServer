USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetCalendarRights]    Script Date: 12/10/2015 10:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetCalendarRights]
	@CMFolderKey int,
	@UserKey int,
	@CanView tinyint output,
	@CanEdit tinyint output,
	@DefaultCalendarColor varchar(50) output,
	@FolderIsPublic tinyint output
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/26/08   CRG 10.5.0.0 Created for new CalendarManager.  This gets the CanView and CanEdit rights for the folder.
|| 6/29/09   CRG 10.5.0.0 Now Administrators can edit all Public folders
|| 7/30/09   CRG 10.5.0.5 (58707) Modified to get the DefaultCalendarColor from the folder user, not the logged in user
|| 9/9/09    CRG 10.5.1.0 (61307) Added calendar color for public calendars
*/

	DECLARE	@FolderUserKey int,
			@SecurityGroupKey int,
			@Administrator tinyint,
			@CalendarColor varchar(50)
	
	SELECT	@FolderUserKey = UserKey,
			@CalendarColor = ISNULL(CalendarColor, '')
	FROM	tCMFolder (nolock)
	WHERE	CMFolderKey = @CMFolderKey
	
	IF ISNULL(@FolderUserKey, 0) = 0
		SELECT @FolderIsPublic = 1
	ELSE
		SELECT @FolderIsPublic = 0

	SELECT	@SecurityGroupKey = SecurityGroupKey,
			@Administrator = Administrator
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey
	
	IF @FolderIsPublic = 1 AND @CalendarColor <> ''
		SELECT	@DefaultCalendarColor = @CalendarColor
	ELSE
		SELECT	@DefaultCalendarColor = DefaultCalendarColor
		FROM	tUser (nolock)
		WHERE	UserKey = @FolderUserKey
	
	IF @FolderUserKey = @UserKey
	BEGIN
		SELECT	@CanView = 1,
				@CanEdit = 1
		RETURN
	END
	ELSE
	BEGIN
		--If the User is not the Folder's owner, and it's public, check to see if the user is an administrator
		IF @FolderIsPublic = 1 AND @Administrator = 1
		BEGIN
			SELECT	@CanView = 1,
					@CanEdit = 1
			RETURN
		END		
	END	


	SELECT	@CanView = MAX(CanView),
			@CanEdit = MAX(CanAdd)
	FROM	tCMFolderSecurity (nolock)
	WHERE	((Entity = 'tUser' AND EntityKey = @UserKey)
			OR
			(Entity = 'tSecurityGroup' AND EntityKey = @SecurityGroupKey))
	AND		CMFolderKey = @CMFolderKey --This is either a public folder or the organizer's folder (in case the user can view/edit the organizer's events)
GO
