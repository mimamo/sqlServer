USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavServerGetList]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavServerGetList]
	@CompanyKey int
AS

/*
|| When      Who Rel      What
|| 9/20/11   CRG 10.5.4.8 Created for WebDAV setup screen
|| 3/1/12    CRG 10.5.5.4 Added ClientFolderData, ProjectFolderDdata, and ISNULL for Type
|| 3/8/12    CRG 10.5.5.4 Added Name, PreTokenKey, AuthToken
|| 3/9/12    CRG 10.5.5.4 Now we're storing NULL for the URL when the Type is not WMJ. We're returning a space here so that the admin screen does not show an error.
|| 4/18/12   CRG 10.5.5.5 Added RootPath
|| 12/11/12  CRG 10.5.6.3 Added Type = 3 in URL case
|| 12/18/12  CRG 10.5.6.3 Modified AuthToken to default to 'basic' if Type=3
||                        Added UserID
|| 3/18/13   CRG 10.5.6.5 Added Icon and IconTooltip colukmns
|| 11/20/13  CRG 10.5.7.4 Modified the Link Icon logic for new Box token process
|| 4/25/14   CRG 10.5.7.9 Now returning the URL for Amazon type servers
*/

	--Type "Constants"
	DECLARE	@SERVER_TYPE_WMJ smallint SELECT @SERVER_TYPE_WMJ = 0
	DECLARE	@SERVER_TYPE_BOX_NET smallint SELECT @SERVER_TYPE_BOX_NET = 1
	DECLARE	@SERVER_TYPE_DROPBOX smallint SELECT @SERVER_TYPE_DROPBOX = 2
	DECLARE	@SERVER_TYPE_MAC smallint SELECT @SERVER_TYPE_MAC = 3
	DECLARE	@SERVER_TYPE_AMAZON smallint SELECT @SERVER_TYPE_AMAZON = 4

	SELECT	wd.WebDavServerKey,
			wd.CompanyKey,
			CASE
				WHEN ISNULL(wd.Type, 0) IN (@SERVER_TYPE_WMJ, @SERVER_TYPE_MAC, @SERVER_TYPE_AMAZON) THEN wd.URL
				ELSE ' ' --to keep the FieldValidator happy on the screen
			END AS URL,
			wd.ClientFolder,
			wd.ClientSep,
			CASE
				WHEN ISNULL(wd.ClientFolder, 0) = 2 THEN CAST(ISNULL(wd.ClientFolder, 0) as varchar) + '|' + ISNULL(wd.ClientSep, '')
				ELSE CAST(ISNULL(wd.ClientFolder, 0) as varchar)
			END AS ClientFolderData,
			wd.ProjectFolder,
			wd.ProjectSep,
			CASE
				WHEN ISNULL(wd.ProjectFolder, 0) = 1 THEN CAST(ISNULL(wd.ProjectFolder, 0) as varchar) + '|' + ISNULL(wd.ProjectSep, '')
				ELSE CAST(ISNULL(wd.ProjectFolder, 0) as varchar)
			END AS ProjectFolderData,
			ISNULL(wd.Type, 0) AS Type,
			CASE
				WHEN p.WebDavServerKey IS NOT NULL THEN 1
				ELSE 0
			END AS DefaultServer,
			'Loading server version...' AS ServerVersion,
			Name,
			PreTokenKey,
			CASE
				WHEN ISNULL(wd.Type, 0) = @SERVER_TYPE_MAC THEN ISNULL(AuthToken, 'basic')
				ELSE AuthToken
			END AS AuthToken,
			RootPath,
			UserID,
			CASE
				WHEN ISNULL(wd.Type, 0) = @SERVER_TYPE_WMJ THEN 'actionsLink'
				WHEN ISNULL(wd.Type, 0) = @SERVER_TYPE_AMAZON THEN
					CASE 
						WHEN AuthToken IS NOT NULL OR PreTokenKey IS NOT NULL THEN 'actionsUnlink'
						ELSE 'actionsLink'
					END
				WHEN ISNULL(wd.Type, 0) = @SERVER_TYPE_BOX_NET THEN
					CASE 
						WHEN RefreshToken IS NOT NULL THEN 
							CASE
								WHEN DATEDIFF(DAY,RefreshTokenDate, GETUTCDATE()) < 59 THEN 'actionsUnlink' --If the RefreshToken is less than 59 days old, it's still good
								ELSE 'actionLink' --RefreshToken is expired (or about to expire)
							END
						ELSE 'actionsLink'
					END				
				WHEN ISNULL(wd.Type, 0) = @SERVER_TYPE_MAC THEN 'actionsLink'
			END AS Icon,
			CASE
				WHEN ISNULL(wd.Type, 0) = @SERVER_TYPE_WMJ THEN 'Test server connection / Get options'
				WHEN ISNULL(wd.Type, 0) = @SERVER_TYPE_AMAZON THEN
					CASE 
						WHEN AuthToken IS NOT NULL OR PreTokenKey IS NOT NULL THEN 'Clear authentication'
						ELSE 'Enter Amazon authentication keys'
					END
				WHEN ISNULL(wd.Type, 0) = @SERVER_TYPE_BOX_NET THEN
					CASE 
						WHEN RefreshToken IS NOT NULL THEN 
							CASE
								WHEN DATEDIFF(DAY,RefreshTokenDate, GETUTCDATE()) < 59 THEN 'Clear authentication'
								ELSE 'Enter Box authentication to link Workamajig to account'
							END
						ELSE 'Enter Box authentication to link Workamajig to account'
					END						
				WHEN ISNULL(wd.Type, 0) = @SERVER_TYPE_MAC THEN 'Test server connection'
			END AS IconToolTip				
	FROM	tWebDavServer wd (nolock)
	LEFT JOIN tPreference p (nolock) ON wd.CompanyKey = p.CompanyKey AND wd.WebDavServerKey = p.WebDavServerKey
	WHERE	wd.CompanyKey = @CompanyKey
GO
