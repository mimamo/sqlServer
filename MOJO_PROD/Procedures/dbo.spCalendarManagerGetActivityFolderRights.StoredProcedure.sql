USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetActivityFolderRights]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetActivityFolderRights]
	@UserKey int,
	@FolderUserKey int,
	@CanView tinyint output,
	@CanEdit tinyint output
AS

/*
|| When      Who Rel      What
|| 6/17/09   CRG 10.5.0.0 Created for CalDAV to allow for Activity folders to be synced.
||                        The logic here is to determine if the user has rights to view any of the 
||                        FolderUserKey's personal folders.  If so, then UserKey can view that user's 
||                        Activities (provided that they also have the "viewOtherActivities" right).  
||                        This logic matches the Calendar folder logic in WMJ.
*/
	
	IF @FolderUserKey = @UserKey
	BEGIN
		SELECT	@CanView = 1,
				@CanEdit = 1
		RETURN
	END		

	DECLARE	@SecurityGroupKey int

	SELECT	@SecurityGroupKey = SecurityGroupKey
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey	

	SELECT	@CanView = MAX(fs.CanView),
			@CanEdit = MAX(fs.CanAdd)
	FROM	tCMFolderSecurity fs (nolock)
	INNER JOIN tCMFolder f (NOLOCK) ON fs.CMFolderKey = f.CMFolderKey AND f.UserKey = @FolderUserKey
	WHERE	((fs.Entity = 'tUser' AND fs.EntityKey = @UserKey)
			OR
			(fs.Entity = 'tSecurityGroup' AND fs.EntityKey = @SecurityGroupKey))
GO
