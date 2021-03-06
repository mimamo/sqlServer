USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetEvents]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetEvents]
	@UserKey int,
	@CompanyKey int,
	@CMFolderKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@Resources tinyint = 0,
	@KeysOnly tinyint = 0,
	@LastModified datetime = null,
	@IncludeAddresses tinyint = 0,
	@CheckTime smalldatetime = null, --Added for the auto refresh (similar to LastModified (for sync) but didn't want to change the logic for that)
	@BlockOutOnly tinyint = 0,
	@AllowPartialDayBlockouts tinyint = 0 --Only used when BlockOutOnly = 1, and only on personal meetings
AS --Encrypt

/*
|| When      Who Rel      What
|| 6/27/08   CRG 10.5.0.0 Created for CalendarManager to get events for folders and resources
|| 2/5/09    CRG 10.5.0.0 Removed query for attendees because the data is not being used.
||                        Also, deleted events need to be queried, then filtered out client side in case 
||                        they were deleted instances of a recurring event.
|| 05/05/09  QMD 10.5.0.0 Added LastModified
|| 5/8/09    CRG 10.5.0.0 Added optional KeysOnly parameter for QMD's Sync Process
|| 6/30/09   CRG 10.5.0.0 Now we're not showing events where the user has marked them as "Cannot Attend"
|| 8/12/09	 QMD 10.5.0.6 Added optional LastModified to handle syncing events prior to todays date
|| 8/20/09   CRG 10.5.0.7 (59655) Removed the restriction that the Organizer must be an Active employee
|| 8/27/09   CRG 10.5.0.8 (58075) Modified queries to include meetings where the OriginalStart is within the date range
|| 9/9/09    GWG 10.5.0.9 Reversing the prior restriction. Only active organizers will show
|| 9/9/09    CRG 10.5.0.9 (62773) Removed attendee status restrictions on public calendars
|| 11/17/09  CRG 10.5.1.3 (68424) Removed attendee status restrictions on personal calendars because modified occurences were not being retreived
||                        which caused the original recurring day to show even if it had been modified.  Now in flex, I will account for the modified
||                        occurrence, but not show it on their calendar.
|| 1/29/10   CRG 10.5.1.7 (73515) Now returning a modified occurrence in which the attendee has been deleted, but marking it as "Deleted" to keep
||                        it off their calendar. Otherwise, if an attendee is removed from a modified occurrence, the "regular" recurring
||                        time was showing up on their calendar because we didn't know that the meeting had been modified (and that they were no longer
||                        part of the modified meeting).
|| 2/12/10   QMD 10.5.1.8 Added GoogleUID and OriginalEnd to the select statement
|| 8/25/10   QMD 10.5.3.4 Added Exchange2010UID
|| 3/3/11    CRG 10.5.4.2 Added IncludeAddresses parm which will return the company and contact addresses for the mobile site.
|| 2/28/12   QMD 10.5.5.3 Keys only logic ... changed the select to included Deleted and attendeestatus.
|| 7/20/12   CRG 10.5.5.8 Modified to only return recent updates if a CheckTime is passed in
|| 12/26/12  CRG 10.5.6.3 Added @BlockOutOnly for use with the new Blockout Day logic
|| 1/11/13   CRG 10.5.6.4 Added ClientKey and GLCompanyKey for filtering in the Staff Schedule blockout days
||                        Added @AllowPartialDayBlockouts for used by the Staff Schedule for partial day personal meetings
|| 1/23/13   CRG 10.5.6.4 Now returning IsVacation for meetings in vacation calendars (used by the Staff Schedule). 
||                        For efficiency, this is only run when @BlockOutOnly = 1 (i.e. by the Staff Schedule, not by the regular Calendar Manager)
|| 9/16/13   QMD 10.5.7.2 Added tSyncItem subquery left join and ss.uid
|| 10/09/13  QMD 10.5.7.3 Added s.Company to join to aid in speed
|| 12/20/13  KMC 10.5.7.5 Added UID to JOIN to only bring back values from tSyncItem that have a UID to avoid duplicates from coming back.
|| 03/17/15  KMC 10.5.9.0 (248983) Updated to get exceptions back when viewing resource calendars
*/

	CREATE TABLE #tCalendarKeys	(CalendarKey int NULL,	
								EntityKey int NULL,		
								ProjectKey int NULL,
								ProjectNumber varchar(50) NULL,
								ProjectName varchar(100) NULL,
								ClientKey int NULL,
								GLCompanyKey int NULL,
								ContactCompanyKey int NULL,
								ContactCompanyName varchar(200) NULL,
								ContactUserKey int NULL,
								ContactUserName varchar(300) NULL,
								ContactPhone1 varchar(50) NULL,
								ContactCell varchar(50) NULL,
								ContactEmail varchar(100) NULL,
								CalendarTypeKey int NULL,
								TypeColor varchar(50) NULL,
								AttendeeRemoved tinyint NULL,
								CompanyAddressName varchar(200) NULL,
								CompanyAddress1 varchar(100) NULL,
								CompanyAddress2 varchar(100) NULL,
								CompanyAddress3 varchar(100) NULL,
								CompanyCity varchar(100) NULL,
								CompanyState varchar(50) NULL,
								CompanyCountry varchar(50) NULL,
								CompanyPostalCode varchar(20) NULL,
								ContactAddressName varchar(200) NULL,
								ContactAddress1 varchar(100) NULL,
								ContactAddress2 varchar(100) NULL,
								ContactAddress3 varchar(100) NULL,
								ContactCity varchar(100) NULL,
								ContactState varchar(50) NULL,
								ContactCountry varchar(50) NULL,
								ContactPostalCode varchar(20) NULL,
								DeletedSinceRefresh tinyint NULL,
								IsVacation tinyint NULL
								)
	
	DECLARE	@CanView tinyint,
			@CanEdit tinyint,
			@DefaultCalendarColor varchar(50),
			@FolderIsPublic tinyint,
			@UserKeyOfFolder int

	EXEC spCalendarManagerGetCalendarRights	@CMFolderKey, @UserKey,	@CanView output, @CanEdit output, @DefaultCalendarColor output, @FolderIsPublic output
	
	CREATE TABLE #recentUpdates (CalendarKey int NULL)

	IF @CheckTime IS NOT NULL
	BEGIN
		--get the recent updates
		INSERT	#recentUpdates (CalendarKey)
		EXEC spCalendarManagerGetRecentUpdates @CompanyKey, @CheckTime

		INSERT	#recentUpdates (CalendarKey)
		SELECT 	CalendarKey
		FROM	tCalendar (nolock)
		WHERE	ParentKey IN (SELECT CalendarKey FROM #recentUpdates)
		AND		CalendarKey NOT IN (SELECT CalendarKey FROM #recentUpdates)
	END

	IF @Resources = 1
	BEGIN
		INSERT	#tCalendarKeys (CalendarKey)
		SELECT	ca.CalendarKey
		FROM	tCalendarAttendee ca (nolock) 
		INNER JOIN tCalendar c (nolock) on c.CalendarKey = ca.CalendarKey
		INNER JOIN tCalendarAttendee ca2 (nolock) on c.CalendarKey = ca2.CalendarKey AND ca2.Entity = 'Organizer'	
		INNER JOIN tUser auth (nolock) on ca2.EntityKey = auth.UserKey
		WHERE	ca.Entity = 'Resource' 
		AND		ca.EntityKey = @CMFolderKey
		AND     ((c.EventEnd >= @StartDate AND c.EventStart <= @EndDate) 
				OR (c.Recurring = 1)
				OR (c.OriginalStart BETWEEN @StartDate AND @EndDate))
		AND		c.CompanyKey = @CompanyKey 
		AND		auth.Active = 1
		AND		(@CheckTime IS NULL OR ca.CalendarKey IN (SELECT CalendarKey FROM #recentUpdates))
		
		INSERT	#tCalendarKeys (CalendarKey, AttendeeRemoved)
		SELECT	DISTINCT c.CalendarKey, 1
		FROM	tCalendar c (nolock)
		INNER JOIN tCalendar p (nolock) ON c.ParentKey = p.CalendarKey
		INNER JOIN tCalendarAttendee pa (nolock) ON p.CalendarKey = pa.CalendarKey AND pa.Entity = 'Organizer'
		INNER JOIN tUser auth (nolock) ON pa.EntityKey = auth.UserKey 
		LEFT JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey AND ca.CMFolderKey = @CMFolderKey
		WHERE	ca.EntityKey IS NULL --User is not attendee on the modified occurrence
		AND     ((c.EventEnd >= @StartDate AND c.EventStart <= @EndDate)
				OR (c.OriginalStart BETWEEN @StartDate AND @EndDate))
		AND		c.CompanyKey = @CompanyKey 
		AND		auth.Active = 1
		AND		(@CheckTime IS NULL OR c.CalendarKey IN (SELECT CalendarKey FROM #recentUpdates))
		AND		(ISNULL(@BlockOutOnly, 0) = 0 OR
				(c.BlockOutOnSchedule = 1 AND (@AllowPartialDayBlockouts = 1 OR c.AllDayEvent = 1)))
		AND     c.CalendarKey NOT IN (SELECT CalendarKey from #tCalendarKeys)
	END
	ELSE
	BEGIN
		IF @FolderIsPublic = 1
		BEGIN
			INSERT	#tCalendarKeys (CalendarKey)
			SELECT	c.CalendarKey
			FROM	tCalendar c (nolock)
			INNER JOIN tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey AND ca.Entity = 'Organizer'	
			INNER JOIN tUser auth (nolock) on ca.EntityKey = auth.UserKey
			INNER JOIN tCMFolder f (nolock) ON c.CMFolderKey = f.CMFolderKey
			WHERE	c.CMFolderKey = @CMFolderKey
			AND     ((c.EventEnd >= @StartDate AND c.EventStart <= @EndDate)
			        OR (c.Recurring = 1)
			        OR (c.OriginalStart BETWEEN @StartDate AND @EndDate))
			AND		c.CompanyKey = @CompanyKey
			AND		auth.Active = 1
			AND		(@CheckTime IS NULL OR c.CalendarKey IN (SELECT CalendarKey FROM #recentUpdates))
			AND		(ISNULL(@BlockOutOnly, 0) = 0 OR
					(c.BlockOutOnSchedule = 1 AND c.AllDayEvent = 1))
		END
		ELSE
		BEGIN
			SELECT	@UserKeyOfFolder = UserKey
			FROM	tCMFolder (nolock)
			WHERE	CMFolderKey = @CMFolderKey
			
			INSERT	#tCalendarKeys (CalendarKey)
			SELECT	DISTINCT ca.CalendarKey
			FROM	tCalendarAttendee ca (nolock)
			INNER JOIN tCalendar c (nolock) on c.CalendarKey = ca.CalendarKey
			INNER JOIN tCalendarAttendee ca2 (nolock) on c.CalendarKey = ca2.CalendarKey AND ca2.Entity = 'Organizer'	
			INNER JOIN tUser auth (nolock) on ca2.EntityKey = auth.UserKey
			WHERE	ca.CMFolderKey = @CMFolderKey
			AND     ((c.EventEnd >= @StartDate AND c.EventStart <= @EndDate)
			        OR (c.Recurring = 1)
			        OR (c.OriginalStart BETWEEN @StartDate AND @EndDate))
			AND		c.CompanyKey = @CompanyKey 
			AND		auth.Active = 1
			AND		(@CheckTime IS NULL OR ca.CalendarKey IN (SELECT CalendarKey FROM #recentUpdates))
			AND		(ISNULL(@BlockOutOnly, 0) = 0 OR
					(c.BlockOutOnSchedule = 1 AND (@AllowPartialDayBlockouts = 1 OR c.AllDayEvent = 1)))
			
			INSERT	#tCalendarKeys (CalendarKey, AttendeeRemoved)
			SELECT	DISTINCT c.CalendarKey, 1
			FROM	tCalendar c (nolock)
			INNER JOIN tCalendar p (nolock) ON c.ParentKey = p.CalendarKey
			INNER JOIN tCalendarAttendee pa (nolock) ON p.CalendarKey = pa.CalendarKey AND pa.CMFolderKey = @CMFolderKey --Parent meeting is in this folder
			INNER JOIN tCalendarAttendee pa2 (nolock) ON p.CalendarKey = pa2.CalendarKey AND pa2.Entity = 'Organizer'
			INNER JOIN tUser auth (nolock) ON pa2.EntityKey = auth.UserKey
			LEFT JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey AND ca.Entity IN ('Organizer', 'Attendee') AND ca.CMFolderKey = @CMFolderKey
			WHERE	ca.EntityKey IS NULL --User is not attendee on the modified occurrence
			AND     ((c.EventEnd >= @StartDate AND c.EventStart <= @EndDate)
			        OR (c.OriginalStart BETWEEN @StartDate AND @EndDate))
			AND		c.CompanyKey = @CompanyKey 
			AND		auth.Active = 1
			AND		(@CheckTime IS NULL OR c.CalendarKey IN (SELECT CalendarKey FROM #recentUpdates))
			AND		(ISNULL(@BlockOutOnly, 0) = 0 OR
					(c.BlockOutOnSchedule = 1 AND (@AllowPartialDayBlockouts = 1 OR c.AllDayEvent = 1)))
		END	
	END

	-- added to handle sync changes prior to todays date
	if @LastModified IS NOT NULL
		DELETE  ck
		FROM	tCalendar c, #tCalendarKeys ck
		WHERE	c.CalendarKey = ck.CalendarKey
				AND c.DateUpdated <= @LastModified


	-- tmp table updates to eliminate left outer joins
	update #tCalendarKeys
	set  ProjectKey = c.ProjectKey
		,ContactCompanyKey = c.ContactCompanyKey
		,CalendarTypeKey = c.CalendarTypeKey
		,ContactUserKey = c.ContactUserKey
	from tCalendar c (nolock)
	where #tCalendarKeys.CalendarKey = c.CalendarKey

	update #tCalendarKeys
	set  EntityKey = att.EntityKey
	from tCalendarAttendee att (nolock)
	where #tCalendarKeys.CalendarKey = att.CalendarKey
	and att.Entity = 'Attendee' 
	and att.EntityKey = @UserKey

	update #tCalendarKeys
	set  ProjectNumber = p.ProjectNumber
		,ProjectName = p.ProjectName
		,ClientKey = p.ClientKey
		,GLCompanyKey = p.GLCompanyKey
	from tProject p (nolock)
	where #tCalendarKeys.ProjectKey = p.ProjectKey

	update #tCalendarKeys
	set  ContactCompanyName = c.CompanyName
	from tCompany c (nolock)
	where ContactCompanyKey = c.CompanyKey 
	
	UPDATE	#tCalendarKeys
	SET		ContactUserName = u.UserName,
			ContactPhone1 = u.Phone1,
			ContactCell = u.Cell,
			ContactEmail = u.Email
	FROM	vUserName u (nolock)
	WHERE	#tCalendarKeys.ContactUserKey = u.UserKey

	update #tCalendarKeys
	set  TypeColor = ct.TypeColor
	from tCalendarType ct (nolock)
	where #tCalendarKeys.CalendarTypeKey = ct.CalendarTypeKey

	IF @IncludeAddresses = 1
	BEGIN
		UPDATE	#tCalendarKeys
		SET		CompanyAddressName = ad.AddressName,
				CompanyAddress1 = ad.Address1,
				CompanyAddress2 = ad.Address2,
				CompanyAddress3 = ad.Address3,
				CompanyCity = ad.City,
				CompanyState = ad.State,
				CompanyCountry = ad.Country,
				CompanyPostalCode = ad.PostalCode
		FROM	#tCalendarKeys c
		INNER JOIN tCompany co (nolock) ON c.ContactCompanyKey = co.CompanyKey
		INNER JOIN tAddress ad (nolock) ON co.DefaultAddressKey = ad.AddressKey

		UPDATE	#tCalendarKeys
		SET		ContactAddressName = ad.AddressName,
				ContactAddress1 = ad.Address1,
				ContactAddress2 = ad.Address2,
				ContactAddress3 = ad.Address3,
				ContactCity = ad.City,
				ContactState = ad.State,
				ContactCountry = ad.Country,
				ContactPostalCode = ad.PostalCode
		FROM	#tCalendarKeys c
		INNER JOIN tUser con (nolock) ON c.ContactUserKey = con.UserKey
		LEFT JOIN tCompany co (nolock) ON c.ContactCompanyKey = co.CompanyKey
		INNER JOIN tAddress ad (nolock) ON ISNULL(con.AddressKey, co.DefaultAddressKey) = ad.AddressKey
	END

	IF @BlockOutOnly = 1
		UPDATE	#tCalendarKeys
		SET		IsVacation = 1
		FROM	#tCalendarKeys (nolock)	
		INNER JOIN tCalendar c ON #tCalendarKeys.CalendarKey = c.CalendarKey
		INNER JOIN tCMFolder f ON c.CMFolderKey = f.CMFolderKey
		WHERE	f.BlockoutAttendees = 1

	IF @KeysOnly = 1
		SELECT  c.CalendarKey,
				c.LastModified,
				c.Deleted,
				ISNULL(ca2.Status, 1) AS AttendeeStatus,
				c.ParentKey
		FROM	tCalendar c (nolock)
		INNER JOIN #tCalendarKeys tmp ON c.CalendarKey = tmp.CalendarKey
		LEFT JOIN tCalendarAttendee ca2 (nolock) on c.CalendarKey = ca2.CalendarKey AND ca2.EntityKey = @UserKeyOfFolder AND ca2.Entity IN ('Organizer', 'Attendee')
	ELSE
		SELECT 	#tCalendarKeys.CalendarKey,
				c.Subject,
				c.Location,
				c.[Description],
				c.ProjectKey,
				c.CompanyKey,
				c.Visibility,
				ISNULL(c.Recurring, 0) AS Recurring,
				c.RecurringCount,
				c.ReminderTime,
				c.ContactCompanyKey,
				c.ContactUserKey,
				c.ContactLeadKey,
				c.CalendarTypeKey,
				c.ReminderSent,
				c.EventLevel,
				c.EventStart,
				c.EventEnd,
				c.ShowTimeAs,
				c.RecurringSettings,
				c.RecurringEndType,
				c.RecurringEndDate,
				c.OriginalStart,
				ISNULL(c.ParentKey, 0) AS ParentKey,
				c.Pattern,
				CASE #tCalendarKeys.AttendeeRemoved
					WHEN 1 THEN 1
					ELSE c.Deleted
				END AS Deleted,
				ISNULL(c.AllDayEvent,0) AS AllDayEvent,
				c.BlockOutOnSchedule,
				c.DateUpdated,
				c.DateCreated,
				c.[Sequence],
				auth.UserKey AS OrganizerKey,
				auth.FirstName + ' ' + auth.LastName as AuthorName,
				auth.Email as AuthorEmail,
				auth.TimeZoneIndex,
				#tCalendarKeys.ProjectNumber as ProjectNumber,
				#tCalendarKeys.ProjectName as ProjectName,
				#tCalendarKeys.ClientKey,
				#tCalendarKeys.GLCompanyKey,
				c.Freq,
				c.Interval,
				c.BySetPos,
				c.ByMonthDay,
				c.ByMonth,
				c.Su,
				c.Mo,
				c.Tu,
				c.We,
				c.Th,
				c.Fr,
				c.Sa,
				ISNULL(@CanView, 0) AS CanView,
				CASE
					WHEN ca.CMFolderKey <> @CMFolderKey THEN 0 --@CMFolderKey is not the organizer's folder, so @CanEdit does not apply here
					ELSE ISNULL(@CanEdit, 0)
				END AS CanEdit,
				CASE
					WHEN #tCalendarKeys.EntityKey IS NOT NULL THEN 1
					ELSE 0
				END AS IsAttendee,
				#tCalendarKeys.ContactCompanyName AS ContactCompanyName,
				c.Private,
				#tCalendarKeys.TypeColor as TypeColor,
				@DefaultCalendarColor as DefaultCalendarColor,
				#tCalendarKeys.ContactUserName,
				#tCalendarKeys.ContactPhone1,
				#tCalendarKeys.ContactCell,
				#tCalendarKeys.ContactEmail,
				c.UID,
				CASE
					WHEN ISNULL(c.CMFolderKey, 0) > 0 THEN c.CMFolderKey
					ELSE ca.CMFolderKey
				END AS CMFolderKey,
				CASE
					WHEN ISNULL(c.CMFolderKey, 0) > 0 THEN 1
					ELSE 0
				END AS IsPublicEvent,
				c.LastModified,
				ISNULL(ca2.Status, 1) AS AttendeeStatus,
				c.GoogleUID,
				c.OriginalEnd,
				c.Exchange2010UID,
				ss.[UID] AS tSyncItemUID,
				#tCalendarKeys.CompanyAddressName,
				#tCalendarKeys.CompanyAddress1,
				#tCalendarKeys.CompanyAddress2,
				#tCalendarKeys.CompanyAddress3,
				#tCalendarKeys.CompanyCity,
				#tCalendarKeys.CompanyState,
				#tCalendarKeys.CompanyCountry,
				#tCalendarKeys.CompanyPostalCode,
				#tCalendarKeys.ContactAddressName,
				#tCalendarKeys.ContactAddress1,
				#tCalendarKeys.ContactAddress2,
				#tCalendarKeys.ContactAddress3,
				#tCalendarKeys.ContactCity,
				#tCalendarKeys.ContactState,
				#tCalendarKeys.ContactCountry,
				#tCalendarKeys.ContactPostalCode,
				#tCalendarKeys.DeletedSinceRefresh,
				#tCalendarKeys.IsVacation
		FROM	#tCalendarKeys (nolock)	
		LEFT JOIN tCalendar c on #tCalendarKeys.CalendarKey = c.CalendarKey		
		LEFT JOIN tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey AND ca.Entity = 'Organizer'	
		LEFT JOIN tUser auth (nolock) on ca.EntityKey = auth.UserKey
		LEFT JOIN tCalendarAttendee ca2 (nolock) on c.CalendarKey = ca2.CalendarKey AND ca2.EntityKey = @UserKeyOfFolder AND ca2.Entity IN ('Organizer', 'Attendee')
		LEFT JOIN (
					SELECT	s.*
					FROM	tCMFolder cm INNER JOIN tSyncItem s On s.CompanyKey = @CompanyKey and cm.CMFolderKey = s.ApplicationFolderKey		
								INNER JOIN tSyncFolder sf ON cm.SyncFolderKey = sf.SyncFolderKey
					WHERE	CMFolderKey = @CMFolderKey
							AND sf.SyncApp = 0 -- ( Any Exchange Server )
				  ) ss ON #tCalendarKeys.CalendarKey = ss.ApplicationItemKey AND ss.ApplicationFolderKey = @CMFolderKey AND ISNULL(ss.UID, '') > ''
				  
	DROP TABLE #tCalendarKeys
GO
