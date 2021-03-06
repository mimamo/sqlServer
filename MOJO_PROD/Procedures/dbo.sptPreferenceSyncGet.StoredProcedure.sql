USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceSyncGet]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptPreferenceSyncGet]
(
	@userKey INT
)

As --Encrypt

  /*
  || When     Who Rel       What
  || 07/08/08 QMD 10.5      Created for initial Release of 10.5
  */

-- Get the folders and items for the userkey 
SELECT	u.UserKey, c.CompanyKey, ISNULL(SyncDeletesContacts,0) AS SyncDeletesContacts, ISNULL(SyncDeleteEvents,0) AS SyncDeleteEvents
FROM	tUser u (NOLOCK) INNER JOIN tCompany c (NOLOCK) ON u.CompanyKey = c.CompanyKey
						 INNER JOIN tPreference p (NOLOCK) ON c.CompanyKey = p.CompanyKey
WHERE	u.UserKey = @userKey
GO
