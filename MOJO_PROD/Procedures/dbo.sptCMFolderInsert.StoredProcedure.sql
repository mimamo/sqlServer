USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderInsert]
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
	@CalendarColor varchar(50),
	@GoogleUserID varchar(100),
	@GooglePassword varchar(50),
	@GoogleSyncFolderKey int,
	@GoogleSyncDirection smallint,
    @GoogleAccessCode varchar(2000) = NULL,
    @GoogleRefreshToken varchar(2000) = NULL,
    @GoogleCalDAVEnabled tinyint = NULL,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel      What
|| 4/22/09   CRG 10.5.0.0 Added SyncDirection
|| 4/24/09   CRG 10.5.0.0 Added IncludeInSync
|| 7/28/09   CRG 10.5.0.4 Added BlockoutAttendees
|| 9/9/09    CRG 10.5.1.0 (61307) Added CalendarColor
|| 1/7/10    QMD 10.5.1.8 Added Google Credentials
|| 7/20/12   QMD 10.5.5.8 Added GoogleAPIVersion, GoogleClientID, GoogleClientSecret, GoogleRedirectURI, GoogleAccessCode, GoogleRefreshToken
|| 11/27/12  QMD 10.5.6.3 Added GoogleCalDAVEnabled
|| 01/10/13  QMD 10.5.6.4 Remove GoogleAPIVersion, GoogleClientID, GoogleClientSecret, GoogleRedirectURI
*/

	INSERT tCMFolder
		(
		FolderName,
		ParentFolderKey,
		UserKey,
		CompanyKey,
		Entity,
		SyncFolderKey,
		BlockoutAttendees,
		CalendarColor, 
		GoogleUserID, 
		GooglePassword,
		GoogleSyncFolderKey,
		GoogleAccessCode, 
		GoogleRefreshToken,
		GoogleCalDAVEnabled
		)

	VALUES
		(
		@FolderName,
		@ParentFolderKey,
		@UserKey,
		@CompanyKey,
		@Entity,
		@SyncFolderKey,
		@BlockoutAttendees,
		@CalendarColor,
		@GoogleUserID,
		@GooglePassword,
		@GoogleSyncFolderKey,		
		@GoogleAccessCode, 
		@GoogleRefreshToken,
		@GoogleCalDAVEnabled
		)
	
	SELECT @oIdentity = @@IDENTITY
	
	IF ISNULL(@SyncFolderKey, 0) > 0
		UPDATE	tSyncFolder
		SET		SyncDirection = @SyncDirection
		WHERE	SyncFolderKey = @SyncFolderKey

	IF ISNULL(@GoogleSyncFolderKey, 0) > 0
		UPDATE	tSyncFolder
		SET		SyncDirection = @GoogleSyncDirection
		WHERE	SyncFolderKey = @GoogleSyncFolderKey

	IF @Entity = 'tCalendar' OR @Entity = 'tUser'
		EXEC sptCMFolderIncludeInSyncUpdate @oIdentity, @LoggedUserKey, @IncludeInSync

	RETURN 1
GO
