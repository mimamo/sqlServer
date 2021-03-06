USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetEvent]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetEvent]
	@CalendarKey int,
	@UID varchar(200) = '',
	@CMFolderKey int = NULL,
	@ParentOnly tinyint = 0,
	@Application varchar(20) = ''
	
AS --Encrypt

/*
|| When      Who Rel      What
|| 8/11/08   CRG 10.5.0.0 Created for the CalendarManager to get Event detail
|| 4/16/09   GWG 10.5     Added the project number and name
|| 7/22/09   CRG 10.5.0.0 Added UID parm that allows CalDAV to get abbreviated data by UID.
|| 8/25/09   CRG 10.5.0.8 (61077) Added @CMFolderKey so that events selected by UID are limited to only the CMFolderKey being retreived
|| 8/26/09   CRG 10.5.0.8 Added @ParentOnly parm. If it's 1, then when an event is selected by UID, only the record with ParentKey = 0 will be retreived
|| 8/28/09   CRG 10.5.0.8 Added ActualFolderKey to the query by UID area
|| 10/8/09   CRG 10.5.1.2 (65027) Modified the UID query to return "parent" recurring meetings regardless of whether the CMFolderKey is on the tCalendar
||                        record, or on an attendee of the parent, if @ParentOnly = 1.  This is because with CalDAV, if a person is an attendee on an
||                        occurrence of a meeting, but not on the original "parent" meeting, we still need to get the meeting back here.
|| 02/09/10  QMD 10.5.1.8 Added if clause for googleuid
|| 08/03/10  QMD 10.5.3.3 Added if clause for exchange2010uid
|| 11/10/10  QMD 10.5.3.7 Modified the ActualFolderKey sub select to limit by calendarkey instead of UID. (Data could contain the same UID more than once)
|| 02/08/11  CRG 10.5.4.1 (102895) Now checking OriginalUID column as well as UID in case the requested UID contains an unusual character like { or }.
|| 09/25/13  KMC 10.5.7.2 (189810) Added the Exchange2010UID to the where clause to handle when events are created
||                        in WMJ and exceptions are then created in Exchange
|| 10/09/13  QMD 10.5.7.3 Added si.CompanyKey and indexes to tSyncItem to help with performance
|| 12/20/13  KMC 10.5.7.5 (197951) Added SELECT specifically for ExchangeSync to exclude the @ParentOnly flag that was being used and 
						  returning multiple events.
|| 04/28/14  CRG 10.5.7.9 Added TaskID and TaskName to regular get query
|| 04/28/14  GWG 10.5.7.9 Added TrackBudget for new UI to determine if a time entry can use that task
*/
	
	DECLARE @CompanyKey INT
	
	SELECT  @CompanyKey = CompanyKey 
	FROM	tCalendar (NOLOCK) 
	WHERE	CalendarKey = @CalendarKey	
	
	IF ISNULL(@UID, '') = ''
		SELECT	c.*,
				CASE
					WHEN c.CMFolderKey IS NOT NULL THEN c.CMFolderKey
					ELSE
						(SELECT MIN(CMFolderKey) --MIN to ensure that it's just one row
						FROM	tCalendarAttendee (nolock)
						WHERE	CalendarKey = @CalendarKey
						AND		Entity = 'Organizer')
				END AS ActualFolderKey,
				(SELECT MIN(CMFolderKey) --MIN to ensure that it's just one row
				FROM	tCalendarAttendee (nolock)
				WHERE	CalendarKey = @CalendarKey
				AND		Entity = 'Organizer') AS UserFolderKey,
				DATEDIFF(mi, c.EventStart, c.EventEnd) AS Duration,
				co.CompanyName,
				co.Phone AS CompanyPhone,
				co.Fax AS CompanyFax,
				co.WebSite AS CompanyWebSite,
				con.UserName AS ContactName,
				con.Phone1,
				con.Cell,
				con.Fax,
				con.Email,
				ca.EntityKey as OrganizerKey,
				ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS OrganizerName,
				u.TimeZoneIndex,
				p.ProjectNumber,
				p.ProjectName,
				ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '') AS ProjectFullName,
				ad.AddressName,
				ad.Address1,
				ad.Address2,
				ad.Address3,
				ad.City,
				ad.State,
				ad.Country,
				ad.PostalCode,
				cad.AddressName AS CompanyAddressName,
				cad.Address1 AS CompanyAddress1,
				cad.Address2 AS CompanyAddress2,
				cad.Address3 AS CompanyAddress3,
				cad.City AS CompanyCity,
				cad.State AS CompanyState,
				cad.Country AS CompanyCountry,
				cad.PostalCode AS CompanyPostalCode,
				cb.UserName AS CreatedByUser,
				l.Subject AS OpportunitySubject,
				t.TaskID,
				t.TaskName,
				t.TrackBudget,
				ct.TypeName
		FROM	tCalendar c (nolock)
		INNER JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey
		LEFT JOIN tCompany co (nolock) ON c.ContactCompanyKey = co.CompanyKey
		LEFT JOIN vUserName con (nolock) ON c.ContactUserKey = con.UserKey
		LEFT JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey
		LEFT JOIN vUserName cb (nolock) ON c.CreatedBy = cb.UserKey
		LEFT JOIN tProject p (nolock) ON c.ProjectKey = p.ProjectKey
		LEFT JOIN tAddress ad (nolock) on ISNULL(con.AddressKey, co.DefaultAddressKey) = ad.AddressKey
		LEFT JOIN tAddress cad (nolock) on co.DefaultAddressKey = cad.AddressKey
		LEFT JOIN tLead l (nolock) ON c.ContactLeadKey = l.LeadKey
		LEFT JOIN tTask t (nolock) ON c.TaskKey = t.TaskKey
		LEFT JOIN tCalendarType ct (nolock) ON c.CalendarTypeKey = ct.CalendarTypeKey
		WHERE	c.CalendarKey = @CalendarKey
		AND		ca.Entity = 'Organizer'
	ELSE
		IF @Application = 'Exchange'
				SELECT DISTINCT	c.*,
						CASE
							WHEN c.CMFolderKey IS NOT NULL THEN c.CMFolderKey
							ELSE
								(SELECT MIN(cca.CMFolderKey) --MIN to ensure that it's just one row
								FROM tCalendarAttendee cca (nolock) 
								WHERE c.CalendarKey = cca.CalendarKey
								AND  cca.Entity = 'Organizer')
						END AS ActualFolderKey,
						DATEDIFF(mi, c.EventStart, c.EventEnd) AS Duration,
						ca.EntityKey as OrganizerKey,
						ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS OrganizerName,
						u.TimeZoneIndex,
						si.UID as tSyncItemUID
				FROM	tCalendar c (nolock)
				INNER JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey
				LEFT JOIN tCalendarAttendee ca2 (nolock) ON c.CalendarKey = ca2.CalendarKey
				LEFT JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey
				LEFT JOIN tSyncItem si (nolock) ON si.CompanyKey = @CompanyKey AND ca.CMFolderKey = si.ApplicationFolderKey and c.CalendarKey = si.ApplicationItemKey
				WHERE	(c.UID = @UID OR c.OriginalUID = @UID or c.Exchange2010UID = @UID or (si.CompanyKey = @CompanyKey and si.UID = @UID))
				AND		ca.Entity = 'Organizer'
				AND		(@CMFolderKey IS NULL
						OR c.CMFolderKey = @CMFolderKey
						OR ca2.CMFolderKey = @CMFolderKey)
				AND		(@ParentOnly = 0 OR c.ParentKey = 0)
		ELSE
		IF EXISTS (SELECT * FROM tCalendar (NOLOCK)
						LEFT JOIN tSyncItem si (nolock) ON si.CompanyKey = @CompanyKey and @CMFolderKey = si.ApplicationFolderKey and CalendarKey = si.ApplicationItemKey
					WHERE tCalendar.UID = @UID OR OriginalUID = @UID OR (si.CompanyKey = @CompanyKey and si.UID = @UID and si.DataStoreDeletion = 0 and si.ApplicationDeletion = 0))
			BEGIN			
				SELECT DISTINCT	c.*,
						CASE
							WHEN c.CMFolderKey IS NOT NULL THEN c.CMFolderKey
							ELSE
								(SELECT MIN(cca.CMFolderKey) --MIN to ensure that it's just one row
								FROM tCalendarAttendee cca (nolock) 
								WHERE c.CalendarKey = cca.CalendarKey
								AND  cca.Entity = 'Organizer')
						END AS ActualFolderKey,
						DATEDIFF(mi, c.EventStart, c.EventEnd) AS Duration,
						ca.EntityKey as OrganizerKey,
						ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS OrganizerName,
						u.TimeZoneIndex,
						si.UID as tSyncItemUID
				FROM	tCalendar c (nolock)
				INNER JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey
				LEFT JOIN tCalendarAttendee ca2 (nolock) ON c.CalendarKey = ca2.CalendarKey
				LEFT JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey
				LEFT JOIN tSyncItem si (nolock) ON si.CompanyKey = @CompanyKey AND ca.CMFolderKey = si.ApplicationFolderKey and c.CalendarKey = si.ApplicationItemKey
				WHERE	(c.UID = @UID OR c.OriginalUID = @UID or c.Exchange2010UID = @UID or (si.CompanyKey = @CompanyKey and si.UID = @UID))
				AND		ca.Entity = 'Organizer'
				AND		(@CMFolderKey IS NULL
						OR c.CMFolderKey = @CMFolderKey
						OR ca2.CMFolderKey = @CMFolderKey
						OR @ParentOnly = 1)
				AND		(@ParentOnly = 0 OR c.ParentKey = 0)
			END
		ELSE IF EXISTS (SELECT * FROM tCalendar (NOLOCK) WHERE GoogleUID = @UID)
			BEGIN				
				SELECT DISTINCT	c.*,
						CASE
							WHEN c.CMFolderKey IS NOT NULL THEN c.CMFolderKey
							ELSE
								(SELECT MIN(cca.CMFolderKey) --MIN to ensure that it's just one row
								FROM tCalendarAttendee cca (nolock) 
								WHERE c.CalendarKey = cca.CalendarKey
								AND  cca.Entity = 'Organizer')
						END AS ActualFolderKey,
						DATEDIFF(mi, c.EventStart, c.EventEnd) AS Duration,
						ca.EntityKey as OrganizerKey,
						ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS OrganizerName,
						u.TimeZoneIndex
				FROM	tCalendar c (nolock)
				INNER JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey
				LEFT JOIN tCalendarAttendee ca2 (nolock) ON c.CalendarKey = ca2.CalendarKey
				LEFT JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey
				WHERE	c.GoogleUID = @UID
				AND		ca.Entity = 'Organizer'
				AND		(@CMFolderKey IS NULL
						OR c.CMFolderKey = @CMFolderKey
						OR ca2.CMFolderKey = @CMFolderKey
						OR @ParentOnly = 1)
				AND		(@ParentOnly = 0 OR c.ParentKey = 0)
			END
		ELSE
			BEGIN				
				SELECT DISTINCT	c.*,
						CASE
							WHEN c.CMFolderKey IS NOT NULL THEN c.CMFolderKey
							ELSE
								(SELECT MIN(cca.CMFolderKey) --MIN to ensure that it's just one row
								FROM tCalendarAttendee cca (nolock) 
								WHERE c.CalendarKey = cca.CalendarKey
								AND  cca.Entity = 'Organizer')
						END AS ActualFolderKey,
						DATEDIFF(mi, c.EventStart, c.EventEnd) AS Duration,
						ca.EntityKey as OrganizerKey,
						ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS OrganizerName,
						u.TimeZoneIndex
				FROM	tCalendar c (nolock)
				INNER JOIN tCalendarAttendee ca (nolock) ON c.CalendarKey = ca.CalendarKey
				LEFT JOIN tCalendarAttendee ca2 (nolock) ON c.CalendarKey = ca2.CalendarKey
				LEFT JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey
				WHERE	c.Exchange2010UID = @UID
				AND		ca.Entity = 'Organizer'
				AND		(@CMFolderKey IS NULL
						OR c.CMFolderKey = @CMFolderKey
						OR ca2.CMFolderKey = @CMFolderKey
						OR @ParentOnly = 1)
				AND		(@ParentOnly = 0 OR c.ParentKey = 0)
			END
GO
