USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetAvailableCalendars]    Script Date: 12/10/2015 10:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetAvailableCalendars]
	@UserKey int,
	@IncludeOtherUserCalendars tinyint, --If 1, this will include other users' calendars as well as resources.
	@IncludePersonalCalendars tinyint,
	@IncludePublicCalendars tinyint,
	@IncludePublicBlockoutAttendeeCalendars tinyint,
	@SelectData tinyint = 1, --This is set to 0 when it's called from spCalendarManagerGetGroupCalendar
	@GroupBy smallint = 0 --0:None, 1:Department, 2:Office
AS --Encrypt

/*
|| When      Who Rel      What
|| 7/29/08   CRG 10.5.0.0 Created for new CalendarManager
|| 4/23/09   CRG 10.5.0.0 Added Columns for Sync properties
|| 5/12/09   CRG 10.5.0.0 Added GroupBy parameter to handle grouping of "Other People's" calendars
|| 6/29/09   CRG 10.5.0.0 Now using a common SP to get the list of public calendars that the user can view
|| 6/30/09   CRG 10.5.0.0 Added @IncludePersonalCalendars and @IncludePublicCalendars
|| 7/7/09    CRG 10.5.0.2 (56557) Fixed problem with "Other People's Calendars" where you could get duplicate rows if their 
||                        UserKey and SecurityGroupKey both had access to a calendar
|| 7/28/09   CRG 10.5.0.5 Added BlockoutAttendees to temp table
|| 7/28/09   CRG 10.5.0.5 Added @IncludePublicBlockoutAttendeeCalendars which allows things like the CompanyCalendar widget to not
||                        include public folders where BlockoutAttendees is set to 1
|| 9/9/09    CRG 10.5.1.0 (61307) Added calendar color from public calendars and resources
|| 10/5/09   CRG 10.5.1.1 Added protection against a blank UserName for "Other People"
|| 12/30/09  QMD 10.5.1.8 Added Google Credentials
|| 03/30/10  QMD 10.5.2.0 Added GoogleSyncFolderName
|| 10/8/10   CRG 10.5.3.6 (90309) Fixed problem where the rights for other peoples' calendars were not correct if someone gave the user Edit but not View rights.
|| 07/18/12  QMD 10.5.5.8 Added GoogleAPIVersion
|| 07/19/12  QMD 10.5.5.8 Added GoogleClientID, GoogleClientSecret, GoogleAccessCode, GoogleRefreshToken, FolderID
|| 10/08/12  QMD 10.5.6.0 Added GoogleLastSync
|| 11/28/12  QMD 10.5.6.2 Added GoogleCalDAVEnabled
|| 01/11/13  QMD 10.5.6.4 Removed GoogleAPIVersion, GoogleClientID, GoogleClientSecret, GoogleRedirectURI
*/

	/* Assume created in VB
	CREATE TABLE #tAvailableCalendars
		(Section varchar(50) NULL,
		UserName varchar(200) NULL,
		CMFolderKey int NULL,
		FolderName varchar(200) NULL,
		UserKey int NULL,
		UserID varchar(100) NULL,
		Color varchar(50) NULL,
		SyncFolderKey int NULL,
		SyncDirection smallint NULL,
		IsDefault tinyint NULL,
		IncludeInSync tinyint NULL,
		CanAdd tinyint NULL,
		GroupKey int NULL,
		GroupName varchar(200) NULL,
		BlockoutAttendees tinyint NULL,
		GoogleUserID varchar(100) NULL,
		GooglePassword varchar(250) NULL,
		GoogleSyncDirection smallint NULL,
		GoogleSyncFolderKey int NULL,
		GoogleSyncFolderName varchar(50) NULL,
		GoogleAccessCode varchar(2000) NULL,
		GoogleRefreshToken varchar(2000) NULL,
		FolderID varchar(6000) NULL,
		GoogleLastSync datetime,
		GoogleCalDAVEnabled tinyint
		)
	*/
	
	DECLARE	@SecurityGroupKey int,
			@CompanyKey int,
			@DefaultCalendarColor varchar(50),
			@DefaultCMFolderKey int
	
	SELECT	@SecurityGroupKey = SecurityGroupKey,
			@CompanyKey = CompanyKey,
			@DefaultCalendarColor = DefaultCalendarColor,
			@DefaultCMFolderKey = DefaultCMFolderKey
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey
	
	--My Calendars
	IF @IncludePersonalCalendars = 1
	BEGIN
		INSERT	#tAvailableCalendars
		SELECT	'My Calendars',
				NULL,
				f.CMFolderKey,
				f.FolderName,
				f.UserKey,
				u.UserID,
				@DefaultCalendarColor,
				ISNULL(f.SyncFolderKey, 0),
				ISNULL(sf.SyncDirection, 1),
				CASE
					WHEN f.CMFolderKey = @DefaultCMFolderKey THEN 1
					ELSE 0
				END,
				CASE
					WHEN iis.CMFolderKey IS NOT NULL THEN 1
					ELSE 0
				END,
				1,
				NULL,
				NULL,
				NULL, --BlockoutAttendees does not apply
				f.GoogleUserID,
				f.GooglePassword,
				ISNULL(sfg.SyncDirection, 1) AS GoogleSyncDirection,
				ISNULL(f.GoogleSyncFolderKey, 0) AS GoogleSyncFolderKey,
				ISNULL(sfg.SyncFolderName,'DO NOT SYNC') AS GoogleSyncFolderName,
				f.GoogleAccessCode,
				f.GoogleRefreshToken,
				sfg.FolderID,
				sfg.GoogleLastSync,
				f.GoogleCalDAVEnabled		
		FROM	tCMFolder f (nolock)
		INNER JOIN tUser u (nolock) ON f.UserKey = u.UserKey
		LEFT JOIN tSyncFolder sf (nolock) ON f.SyncFolderKey = sf.SyncFolderKey
		LEFT JOIN tSyncFolder sfg (nolock) ON f.GoogleSyncFolderKey = sfg.SyncFolderKey
		LEFT JOIN tCMFolderIncludeInSync iis (nolock) ON f.CMFolderKey = iis.CMFolderKey AND iis.UserKey = @UserKey
		WHERE	f.UserKey = @UserKey
		AND		f.Entity = 'tCalendar'
		
		IF @IncludeOtherUserCalendars = 1
		BEGIN
			--Other Peoples' Calendars
			INSERT	#tAvailableCalendars
			SELECT	'Other People',
					u.UserName,
					f.CMFolderKey,
					f.FolderName,
					f.UserKey,
					u.UserID,
					u.DefaultCalendarColor,
					NULL,
					NULL,
					0,
					0,
					MAX(fs.CanAdd),
					CASE
						WHEN @GroupBy = 1 THEN ISNULL(u.DepartmentKey, -1)
						WHEN @GroupBy = 2 THEN ISNULL(u.OfficeKey, -1)
						ELSE NULL
					END,
					CASE
						WHEN @GroupBy = 1 THEN ISNULL(d.DepartmentName, '(No Department)')
						WHEN @GroupBy = 2 THEN ISNULL(o.OfficeName, '(No Office)')
						ELSE NULL
					END,
					NULL, --BlockoutAttendees does not apply
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL, --GoogleAccessCode
					NULL, --GoogleRefreshToken			
					NULL,
					NULL, --GoogleLastSync
					NULL  --GoogleCalDAVEnabled
			FROM	tCMFolder f (nolock)
			INNER JOIN tCMFolderSecurity fs (nolock) ON f.CMFolderKey = fs.CMFolderKey
			INNER JOIN vUserName u (nolock) ON f.UserKey = u.UserKey
			LEFT JOIN tDepartment d (nolock) ON u.DepartmentKey = d.DepartmentKey
			LEFT JOIN tOffice o (nolock) ON u.OfficeKey = o.OfficeKey
			WHERE	((fs.Entity = 'tUser' AND fs.EntityKey = @UserKey)
					OR
					(fs.Entity = 'tSecurityGroup' AND fs.EntityKey = @SecurityGroupKey))
			AND		(fs.CanView = 1 OR fs.CanAdd = 1)
			AND		f.UserKey <> 0
			AND		f.UserKey <> @UserKey
			AND		f.Entity = 'tCalendar'
			AND		u.Active = 1
			AND		ISNULL(u.UserName, '') <> ''
			GROUP BY u.UserName, f.CMFolderKey, f.FolderName, f.UserKey, u.UserID, u.DefaultCalendarColor, 
						u.DepartmentKey, u.OfficeKey, d.DepartmentName, o.OfficeName
						
			--Resources
			INSERT	#tAvailableCalendars
			SELECT	'Resources',
					NULL,
					CalendarResourceKey * -1,
					ResourceName,
					NULL,
					NULL,
					CalendarColor,
					NULL,
					NULL,
					0,
					0,
					NULL,
					NULL,
					NULL,
					NULL, --BlockoutAttendees does not apply
					NULL,
					NULL,
					NULL,
					NULL,
					NULL,
					NULL, --GoogleAccessCode
					NULL, --GoogleRefreshToken
					NULL,
					NULL, --GoogleLastSync		
					NULL  --GoogleCalDAVEnabled
			FROM	tCalendarResource (nolock)
			WHERE	CompanyKey = @CompanyKey
		END
	END

	IF @IncludePublicCalendars = 1
	BEGIN
		--Load the Public folder list
		CREATE TABLE #tPublicCalList (CMFolderKey int NULL, CanAdd tinyint NULL)
		EXEC spCalendarManagerGetPublicCalendars @UserKey
		
		--Public Folders
		INSERT	#tAvailableCalendars
		SELECT	DISTINCT 'Public Calendars',
				NULL,
				f.CMFolderKey,
				f.FolderName,
				NULL,
				'public', --Used when generating the CalDAV url
				f.CalendarColor,
				ISNULL(f.SyncFolderKey, 0),
				ISNULL(sf.SyncDirection, 1),
				0,
				CASE
					WHEN iis.CMFolderKey IS NOT NULL THEN 1
					ELSE 0
				END,
				tmp.CanAdd,
				NULL,
				NULL,
				ISNULL(f.BlockoutAttendees, 0),
				f.GoogleUserID,
				f.GooglePassword,
				ISNULL(sfg.SyncDirection, 1) AS GoogleSyncDirection,
				ISNULL(f.GoogleSyncFolderKey, 0) AS GoogleSyncFolderKey,
				ISNULL(sfg.SyncFolderName,'DO NOT SYNC') AS GoogleSyncFolderName,
				f.GoogleAccessCode,
				f.GoogleRefreshToken,
				sfg.FolderID,
				sfg.GoogleLastSync,
				f.GoogleCalDAVEnabled
		FROM	tCMFolder f (nolock)
		INNER JOIN #tPublicCalList tmp (nolock) ON f.CMFolderKey = tmp.CMFolderKey
		LEFT JOIN tSyncFolder sf (nolock) ON f.SyncFolderKey = sf.SyncFolderKey
		LEFT JOIN tSyncFolder sfg (nolock) ON f.GoogleSyncFolderKey = sfg.SyncFolderKey
		LEFT JOIN tCMFolderIncludeInSync iis (nolock) ON f.CMFolderKey = iis.CMFolderKey AND iis.UserKey = @UserKey
		WHERE	(f.BlockoutAttendees = @IncludePublicBlockoutAttendeeCalendars OR @IncludePublicBlockoutAttendeeCalendars = 1)

		DROP TABLE #tPublicCalList
	END
		
	IF @SelectData = 1	
		SELECT	*
		FROM	#tAvailableCalendars
		ORDER BY GroupName, UserName, FolderName
GO
