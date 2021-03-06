USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncFolderGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptSyncFolderGet]
(
	@CompanyKey int,
	@Application varchar(25)
)

As --Encrypt

  /*
  || When     Who Rel       What
  || 06/26/08 QMD 10.5      Modified for initial Release of WMJ
  || 04/21/09 QMD 10.5      Modified for new table structure
  || 05/05/09 QMD 10.5      Added LastSync, SyncFolderKey
  || 09/06/09 QMD 10.5.1.1  Switched inner to left join
  || 10/21/09 QMD 10.5.1.2  Reduce last sync to capture changes made while the process was running
  || 12/21/09 QMD 10.5.1.8  Added Application variable
  || 03/26/10 QMD 10.5.2.0  Added TimeZoneIndex
  || 04/12/10 QMD 10.5.2.1  Added TruthCount and IsFirstSync
  || 07/20/10 QMD 10.5.3.2  Modified TruthCount Logic
  || 11/30/10 QMD 10.5.3.8  Fixed null userid for a google public folder sync.
  || 12/13/10 QMD 10.5.4.0  Added null userid clause
  || 01/25/11 QMD 10.5.4.0  Replaced LastSync With GoogleLastSync
  || 12/08/11 QMD 10.5.5.1  Added Active restriction for Google. For sync tool iteration performance reasons also did that for exchange
  || 03/12/12 QMD 10.5.5.4  Something broke the public folder sync ... fixed google public folder sync.
  || 05/23/12 QMD 10.5.5.6  Added EmailAttempts, EmailLastSent, GoogleLoginAttempts, GoogleLastEmailSent
  || 06/02/12 QMD 10.5.5.7  Fixed join to use U2 alias instead of U for active user. Also added join to company table to look for locked flag.
  || 08/13/12 QMD 10.5.5.9  Modified clause to include OAuth parms for google
  || 12/17/12 KMC 10.5.6.3  Added GoogleCalDAVEnabled and Google SyncApp type of 2 for Google CalDAV
  || 01/11/13 QMD 10.5.6.4  Removed GoogleAPIVersion, GoogleClientID, GoogleClientSecret, GoogleRedirectURI
  || 01/16/13 QMD 10.5.6.4  Added ExchangeOnlineServer
  || 03/15/13 QMD 10.5.6.6  Increased the number of google login attempts
  || 10/16/14 KMC 10.5.8.4H Added new logic for updated Google CalDAV implementation.  Rolled out as part of hotfix
  || 12/17/14 KMC 10.5.8.7  Added GoogleAuthToken for Google return to be used to determine if Google CalDAV is enabled and cleaned
  ||                        up some fields that are no longer needed.
  */


IF (@Application in ('google', 'googlecontacts'))
   BEGIN  
		SELECT	c.UserKey
			  , c.CMFolderKey
			  , s.SyncFolderKey
			  , DateAdd(MINUTE, -5, s.GoogleLastSync) AS LastSync
			  , s.SyncFolderName
			  , s.FolderID
			  , s.Entity
			  , s.SyncDirection
			  , c.GoogleUserID
			  , c.GooglePassword
			  , ISNULL(p.SystemEmail, '') as SystemEmail
			  , c.CompanyKey
			  , s.SyncApp
			  , ISNULL(u.UserID,u2.UserID) as UserID
			  , ISNULL(u.TimeZoneIndex, u2.TimeZoneIndex) AS TimeZoneIndex
			  , ISNULL(u.Email,'') as Email
			  , c.GoogleLoginAttempts
			  , c.GoogleLastEmailSent
			  , ISNULL(u.GoogleAuthToken, '') as GoogleAuthToken
			  , c.GoogleCalDAVPublicUserKey
		 FROM tCMFolder c (NOLOCK) 
			INNER JOIN tPreference p (NOLOCK) ON c.CompanyKey = p.CompanyKey
			LEFT JOIN tUser u (NOLOCK) ON c.UserKey = u.UserKey
			LEFT JOIN tSyncFolder s (NOLOCK) ON c.GoogleSyncFolderKey = s.SyncFolderKey --AND s.SyncApp in (1, 2)
			INNER JOIN tUser u2 (NOLOCK) ON s.UserKey = u2.UserKey					
			INNER JOIN tCompany co (NOLOCK) ON c.CompanyKey = co.CompanyKey
		WHERE c.Entity IN ('tCalendar', 'tUser')
		  AND ( ISNULL(u2.GoogleAuthToken, '') <> '' AND ISNULL(u2.GoogleRefreshToken, '') <> '')  --Google CalDAV
		  AND u2.UserID IS NOT NULL
		  AND u2.Active = 1
		  AND co.Locked = 0
		  AND ISNULL(c.GoogleLoginAttempts,0) <= 30
		
		UNION
		
		SELECT	c.UserKey
			  , c.CMFolderKey
			  , s.SyncFolderKey
			  , DateAdd(MINUTE, -5, s.GoogleLastSync) AS LastSync
			  , s.SyncFolderName
			  , s.FolderID
			  , s.Entity
			  , s.SyncDirection
			  , c.GoogleUserID
			  , c.GooglePassword
			  , ISNULL(p.SystemEmail, '') as SystemEmail
			  , c.CompanyKey
			  , s.SyncApp
			  , ISNULL(u.UserID,u2.UserID) as UserID
			  , ISNULL(u.TimeZoneIndex, u2.TimeZoneIndex) AS TimeZoneIndex
			  , ISNULL(u.Email,'') as Email
			  , c.GoogleLoginAttempts
			  , c.GoogleLastEmailSent
			  , ISNULL(u.GoogleAuthToken, '') as GoogleAuthToken
			  , c.GoogleCalDAVPublicUserKey
		 FROM tCMFolder c (NOLOCK) 
			INNER JOIN tPreference p (NOLOCK) ON c.CompanyKey = p.CompanyKey
			LEFT JOIN tUser u (NOLOCK) ON c.UserKey = u.UserKey
			LEFT JOIN tSyncFolder s (NOLOCK) ON c.GoogleSyncFolderKey = s.SyncFolderKey --AND s.SyncApp in (1, 2)
			INNER JOIN tUser u2 (NOLOCK) ON s.UserKey = u2.UserKey					
		WHERE c.Entity IN ('tCalendar', 'tUser')
		  AND ( ISNULL(u2.GoogleAuthToken, '') <> '' AND ISNULL(u2.GoogleRefreshToken, '') <> '')  --Google CalDAV
		  AND u2.UserID IS NOT NULL
		  AND c.UserKey = 0
	 ORDER BY c.CompanyKey, c.UserKey
   END 
ELSE
   BEGIN 
		
		SELECT	c.UserKey
			  , c.CMFolderKey
			  , s.SyncFolderKey
			  , DateAdd(MINUTE, -5, s.LastSync) AS LastSync
			  , s.SyncFolderName
			  , s.FolderID
			  , s.Entity
			  , s.SyncDirection
			  , ISNULL(u.EmailMailBox,'') AS EmailMailBox
			  , u.EmailUserID
			  , u.EmailPassword
			  , ISNULL(p.SystemEmail, '') as SystemEmail
			  , s.SyncApp
			  , u.EmailAttempts
			  , u.EmailLastSent
			  , u.ExchangeOnlineServer
			  , CASE 
					WHEN x.FolderCount > 0 THEN 0
					ELSE 1
				END AS IsFirstSync
			  , y.TruthCount
		  FROM tCMFolder c (NOLOCK) 
			INNER JOIN tPreference p (NOLOCK) ON c.CompanyKey = p.CompanyKey
			INNER JOIN tUserPreference u (NOLOCK) ON c.UserKey = u.UserKey
			INNER JOIN tUser us (NOLOCK) ON u.UserKey = us.UserKey
			LEFT JOIN tSyncFolder s (NOLOCK) ON c.SyncFolderKey = s.SyncFolderKey AND ISNULL(s.SyncApp,0) = 0
			LEFT JOIN (	SELECT	UserKey, CompanyKey, COUNT(*) AS FolderCount
						  FROM	tSyncFolder (NOLOCK)
						GROUP BY UserKey, CompanyKey) x ON x.CompanyKey = @CompanyKey AND x.UserKey = c.UserKey
			LEFT JOIN (SELECT ApplicationFolderKey, COUNT(*) AS TruthCount FROM tSyncItem si (NOLOCK) WHERE ApplicationDeletion = 0 AND DataStoreDeletion = 0  GROUP BY ApplicationFolderKey) y ON y.ApplicationFolderKey = c.CMFolderKey
		WHERE	c.CompanyKey = @CompanyKey
		  AND c.Entity IN ('tCalendar', 'tUser')
		  AND ISNULL(u.EmailUserID, '') <> ''
		  AND ISNULL(u.EmailPassword, '') <> ''
		  AND us.Active = 1
		  
		UNION 

		SELECT	c.UserKey
			  , c.CMFolderKey
			  , s.SyncFolderKey
			  , s.LastSync
			  , s.SyncFolderName
			  , s.FolderID
			  , s.Entity
			  , s.SyncDirection
			  , EmailMailBox = 'public'
			  , EmailUserID = ''
			  , EmailPassword = ''
			  , SystemEmail = ''
			  , s.SyncApp
			  , EmailAttempts = 0
			  , EmailLastSent = ''
			  , ExchangeOnlineServer = ''
			  ,	CASE 
					WHEN x.FolderCount > 0 THEN 0
					ELSE 1
				END AS IsFirstSync
			  , y.TruthCount
		FROM	tCMFolder c (NOLOCK) 
			LEFT JOIN tSyncFolder s (NOLOCK) ON c.SyncFolderKey = s.SyncFolderKey AND ISNULL(s.SyncApp,0) = 0
			LEFT JOIN (	SELECT	UserKey, CompanyKey, COUNT(*) AS FolderCount
						  FROM	tSyncFolder (NOLOCK)
						GROUP BY UserKey, CompanyKey) x ON x.CompanyKey = @CompanyKey AND x.UserKey = 0								
			LEFT JOIN (SELECT ApplicationFolderKey, COUNT(*) AS TruthCount FROM tSyncItem si (NOLOCK) WHERE ApplicationDeletion = 0 AND DataStoreDeletion = 0 GROUP BY ApplicationFolderKey) y ON y.ApplicationFolderKey = c.CMFolderKey
		WHERE c.CompanyKey = @CompanyKey
		  AND c.Entity IN ('tCalendar', 'tUser')
		  AND c.UserKey = 0				
		ORDER BY c.UserKey
		
   END
GO
