USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncActivityGet]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSyncActivityGet]
(
	@userKey INT,
	@companyKey INT,
	@sessionID VARCHAR(500),
	@sourceURI VARCHAR(1000),
	@folderKey INT
)

AS --Encrypt

  /*
  || When     Who Rel       What
  || 04/29/09 QMD 10.5.0.0  Initial Release
  || 08/11/09 QMD 10.5.0.6	Added CMFolderKey to handle syncing calendar and contacts at the same time
  */

	IF EXISTS (SELECT * FROM tSyncActivity WHERE UserKey = @userKey AND CompanyKey = @companyKey AND SessionID = @sessionID AND SourceURI = @sourceURI
				AND CMFolderKey = @folderKey )
		SELECT	*
		FROM	tSyncActivity 
		WHERE	UserKey = @userKey 
				AND CompanyKey = @companyKey 
				AND SessionID = @sessionID 
				AND SourceURI = @sourceURI
				AND CMFolderKey = @folderKey
	ELSE
		SELECT	*
		FROM	tSyncActivity 
		WHERE	UserKey = @userKey 
				AND CompanyKey = @companyKey 
				AND SessionID = @sessionID 
				AND SourceURI = @sourceURI
GO
