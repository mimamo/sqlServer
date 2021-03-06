USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncActivityUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSyncActivityUpdate]
(
	@userKey INT,
	@companyKey INT,
	@sessionID VARCHAR(500),
	@sourceURI VARCHAR(1000),
	@folderKey INT,
	@data TEXT
)

AS --Encrypt

  /*
  || When     Who Rel       What
  || 04/29/09 QMD 10.5.0.0  Initial Release
  || 08/11/09 QMD 10.5.0.6	Added folderKey to handle syncing contacts and calendar events at the same time
  */


IF EXISTS (SELECT 1 FROM tSyncActivity WHERE UserKey = @userKey AND CompanyKey = @companyKey AND SessionID = @sessionID AND SourceURI = @sourceURI AND CMFolderKey = @folderKey)
  BEGIN
	-- this update statement will update the last modified date
    UPDATE	tSyncActivity
    SET		ToDeviceData = @data
    WHERE	UserKey = @userKey
			AND CompanyKey = @companyKey
			AND SourceURI = @sourceURI
			AND SessionID = @sessionID
			AND CMFolderKey = @folderKey
  END
ELSE
  BEGIN
    INSERT INTO tSyncActivity (UserKey, CompanyKey, SessionID, SourceURI, ToDeviceData, LastSync, CMFolderKey)
	VALUES (@userKey, @companyKey, @sessionID, @sourceURI, @data, GETUTCDATE(), @folderKey)
  END
GO
