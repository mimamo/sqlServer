USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderUpdateGoogle]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sptCMFolderUpdateGoogle]
	@UserKey int,
	@CompanyKey int
AS

/*
|| When      Who Rel        What
|| 9/9/14    CRG 10.5.8.4   Created
|| 10/22/14  KMC 10.5.8.4H  Added SyncDirection
|| 1/14/15   KMC 10.5.8.8   Added GoogleLoginAttempts to update of tCMFolder to reset to zero
*/

--Assume Created in VB
/*
	CREATE TABLE #Folders
		(CMFolderKey int NULL,
		IsPublic tinyint NULL,
		FolderID varchar(2500) NULL,
		SyncDirection tinyint NULL)
*/

	DECLARE	@CMFolderKey int
	SELECT	@CMFolderKey = -1
	
	DECLARE	@IsPublic tinyint,
			@FolderID varchar(2500),
			@GoogleSyncFolderKey int,
			@FolderName varchar(200),
			@GoogleCalDAVPublicUserKey int,
			@SyncDirection tinyint
	
	WHILE(1=1)
	BEGIN
		SELECT	@CMFolderKey = MIN(CMFolderKey)
		FROM	#Folders
		WHERE	CMFolderKey > @CMFolderKey
		
		IF @CMFolderKey IS NULL
			BREAK
		
		SELECT	@IsPublic = IsPublic,
				@FolderID = ISNULL(FolderID, ''),
				@SyncDirection = SyncDirection
		FROM	#Folders
		WHERE	CMFolderKey = @CMFolderKey
		
		SELECT	@GoogleSyncFolderKey = GoogleSyncFolderKey,
				@FolderName = FolderName,
				@GoogleCalDAVPublicUserKey = GoogleCalDAVPublicUserKey
		FROM	tCMFolder (nolock)
		WHERE	CMFolderKey = @CMFolderKey
		
		IF @IsPublic = 0
		BEGIN
			--It's a personal calendar
		
			IF @FolderID <> ''
			BEGIN
				IF ISNULL(@GoogleSyncFolderKey, 0) > 0
					UPDATE	tSyncFolder
					SET		FolderID = @FolderID,
							SyncFolderName = @FolderName,
							SyncDirection = @SyncDirection
					WHERE	SyncFolderKey = @GoogleSyncFolderKey
				ELSE
				BEGIN
					INSERT	tSyncFolder
							(SyncFolderName,
							FolderID,
							UserKey,
							CompanyKey,
							Entity,
							SyncDirection)
					VALUES	(@FolderName,
							@FolderID,
							@UserKey,
							@CompanyKey,
							'tCalendar',
							@SyncDirection) --Both
							
					SELECT	@GoogleSyncFolderKey = @@IDENTITY
					
					UPDATE	tCMFolder
					SET		GoogleSyncFolderKey = @GoogleSyncFolderKey, GoogleLoginAttempts = 0
					WHERE	CMFolderKey = @CMFolderKey
				END
			END
			ELSE
			BEGIN
				IF ISNULL(@GoogleSyncFolderKey, 0) > 0
				BEGIN
					DELETE	tSyncFolder
					WHERE	SyncFolderKey = @GoogleSyncFolderKey
					
					UPDATE	tCMFolder
					SET		GoogleSyncFolderKey = NULL,
							GoogleCalDAVPublicUserKey = NULL --This should have already been NULL since it's a personal calendar, but it doesn't hurt to set it
					WHERE	CMFolderKey = @CMFolderKey
				END
			END
		END
		ELSE
		BEGIN
			--It's a public calendar
			
			IF @GoogleCalDAVPublicUserKey IS NULL OR @GoogleCalDAVPublicUserKey = @UserKey
			BEGIN
				IF @FolderID <> ''
				BEGIN
					IF ISNULL(@GoogleSyncFolderKey, 0) > 0
						UPDATE	tSyncFolder
						SET		FolderID = @FolderID,
								SyncFolderName = @FolderName,
								SyncDirection = @SyncDirection
						WHERE	SyncFolderKey = @GoogleSyncFolderKey
					ELSE
					BEGIN
						INSERT	tSyncFolder
								(SyncFolderName,
								FolderID,
								UserKey,
								CompanyKey,
								Entity,
								SyncDirection)
						VALUES	(@FolderName,
								@FolderID,
								@UserKey,
								@CompanyKey,
								'tCalendar',
								@SyncDirection) --Both
								
						SELECT	@GoogleSyncFolderKey = @@IDENTITY
								
						UPDATE	tCMFolder
						SET		GoogleSyncFolderKey = @GoogleSyncFolderKey,
								GoogleCalDAVPublicUserKey = @UserKey,
								GoogleLoginAttempts = 0
						WHERE	CMFolderKey = @CMFolderKey
					END
				END
				ELSE
				BEGIN
					IF ISNULL(@GoogleSyncFolderKey, 0) > 0
					BEGIN
						DELETE	tSyncFolder
						WHERE	SyncFolderKey = @GoogleSyncFolderKey
					
						UPDATE	tCMFolder
						SET		GoogleSyncFolderKey = NULL,
								GoogleCalDAVPublicUserKey = NULL
						WHERE	CMFolderKey = @CMFolderKey
					END
				END
			END
		END
	END
GO
