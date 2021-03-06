USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderUpdate]
	@CMFolderKey int,
	@FolderName varchar(200),
	@ParentFolderKey int,
	@UserKey int,
	@CompanyKey int,
	@Entity varchar(50),
	@SyncFolderKey int,
	@SyncDirection smallint,
	@IncludeInSync tinyint,
	@LoggedUserKey int, --This is the logged user key, not the UserKey for the CMFolder
	@BlockoutAttendees tinyint,
	@CalendarColor varchar(50)
AS --Encrypt

/*
|| When      Who Rel      What
|| 4/22/09   CRG 10.5.0.0 Added SyncDirection
|| 4/24/09   CRG 10.5.0.0 Added IncludeInSync
|| 7/28/09   CRG 10.5.0.4 Added BlockoutAttendees
|| 9/9/09    CRG 10.5.1.0 (61307) Added CalendarColor
|| 1/7/10    QMD 10.5.1.8 Added Google Credentials
|| 1/6/12    QMD 10.5.5.2 Increased the size of the google password
|| 5/24/12   QMD 10.5.5.6 Added update to GoogleLoginAttempts, GoogleLastEmailSent
|| 7/20/12   QMD 10.5.5.8 Added GoogleAPIVersion, GoogleClientID, GoogleClientSecret, GoogleRedirectURI, GoogleAccessCode, GoogleRefreshToken
|| 11/27/12  QMD 10.5.6.2 Added GoogleCalDAVEnabled
|| 01/10/13  QMD 10.5.6.4 Removed GoogleAPIVersion, GoogleClientID, GoogleClientSecret, GoogleRedirectURI
|| 11/14/14  CRG 10.5.8.6 Removed the Google fields because they are obsolete with the new Google CalDAV
*/

	UPDATE
		tCMFolder
	SET
		FolderName = @FolderName,
		ParentFolderKey = @ParentFolderKey,
		UserKey = @UserKey,
		CompanyKey = @CompanyKey,
		Entity = @Entity,
		SyncFolderKey = @SyncFolderKey,
		BlockoutAttendees = @BlockoutAttendees,
		CalendarColor = @CalendarColor
	WHERE
		CMFolderKey = @CMFolderKey 

	IF ISNULL(@SyncFolderKey, 0) > 0
		UPDATE	tSyncFolder
		SET		SyncDirection = @SyncDirection
		WHERE	SyncFolderKey = @SyncFolderKey
	
	IF @Entity = 'tCalendar' OR @Entity = 'tUser'
		EXEC sptCMFolderIncludeInSyncUpdate @CMFolderKey, @LoggedUserKey, @IncludeInSync
		
	RETURN 1
GO
