USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarSetCMFolderForCMP90]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarSetCMFolderForCMP90]
	@CalendarKey int,
	@UserKey int,
	@CompanyKey int,
	@EventLevel int -- 1:Personal, 3:Company
AS

/*
|| When    Who Rel      What
|| 1/8/09  CRG 10.5.0.0 This was created for the calendar pages in CMP90 to set the CMFolderKey for the event.
||                      I named it "ForCMP90" because we can delete this when we're done supporting CMP.
|| 6/30/09 CRG 10.5.0.0 Added new parameter to spCalendarManagerUpdateAttendeeFolders
*/

	IF @EventLevel <> 1 AND @EventLevel <> 3
		RETURN --If it's not Personal or Company, get out
		
	DECLARE	@CMFolderKey int
	
	IF @EventLevel = 1
	BEGIN
		--Personal Event
		
		SELECT	@CMFolderKey = ISNULL(DefaultCMFolderKey, 0)
		FROM	tUser (nolock)
		WHERE	UserKey = @UserKey
		
		IF @CMFolderKey = 0
		BEGIN
			--If the user doesn't have a default calendar, run this SP and try again
			EXEC spCalendarManagerEnsureUserDefaultCalendar @UserKey

			SELECT	@CMFolderKey = ISNULL(DefaultCMFolderKey, 0)
			FROM	tUser (nolock)
			WHERE	UserKey = @UserKey
		END
		
		IF @CMFolderKey = 0
			RETURN
	
		--Run the CalendarManager SP that sets the folders for the event (pass -1 for @UserFolderKey to keep it from updating the folders)
		EXEC spCalendarManagerUpdateAttendeeFolders @CalendarKey, @CMFolderKey, -1, @UserKey
	END
	ELSE
	BEGIN
		--Public Event
		
		--Find the MIN public folder key for the Company
		SELECT	@CMFolderKey = MIN(CMFolderKey)
		FROM	tCMFolder (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		ISNULL(UserKey, 0) = 0
		AND		Entity = 'tCalendar'
		
		--If there isn't one, create one for the company
		--(This uses the same code as spConvertCalendar)
		IF ISNULL(@CMFolderKey, 0) = 0
		BEGIN
			INSERT	tCMFolder (FolderName, ParentFolderKey, UserKey, CompanyKey, Entity)
			VALUES	('Public company meetings', 0, 0, @CompanyKey, 'tCalendar')

			SELECT	@CMFolderKey = @@IDENTITY
			
			--Add a FolderSecurity row for every active SecurityGroup in the Company
			INSERT	tCMFolderSecurity
					(CMFolderKey,
					Entity,
					EntityKey,
					CanView,
					CanAdd)
			SELECT	@CMFolderKey,
					'tSecurityGroup',
					SecurityGroupKey,
					1,
					0
			FROM	tSecurityGroup (nolock)
			WHERE	CompanyKey = @CompanyKey
			AND		Active = 1
		END
		
		IF @CMFolderKey = 0
			RETURN
			
		--Run the CalendarManager SP that sets the folders for the event (pass -1 for @UserFolderKey to keep it from updating the folders)		
		EXEC spCalendarManagerUpdateAttendeeFolders @CalendarKey, @CMFolderKey, -1, @UserKey, 1
	END
GO
