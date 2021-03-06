USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vCMFolderUserName]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vCMFolderUserName]
AS

/*
|| When      Who Rel      What
|| 5/4/09    CRG 10.5.0.0 Created to add the user name or "Public" in () after the FolderName
*/

	SELECT	f.*, 
			CASE
				WHEN ISNULL(f.UserKey, 0) = 0 THEN ISNULL(f.FolderName, '') + ' (Public)'
				ELSE ISNULL(f.FolderName, '') + ' (' + u.UserName + ')'
			END AS FolderUserName
	FROM	tCMFolder f (nolock)
	LEFT JOIN vUserName u (nolock) ON f.UserKey = u.UserKey
GO
