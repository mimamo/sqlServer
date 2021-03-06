USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncItemUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSyncItemUpdate]
(
	@companyKey INT,
	@applicationItemKey INT,
	@applicationFolderKey INT,
	@dataStoreItemID VARCHAR(2500),
	@dataStoreFolderID VARCHAR(2500),
	@dataStoreDeletion TINYINT,
	@applicationDeletion TINYINT,
	@lastSync DATETIME,
	@uid VARCHAR(200) = ''	
)

AS --Encrypt

  /*
  || When     Who Rel          What
  || 11/11/08 QMD WMJ 1.5      Initial Release
  || 01/26/11 QMD WMJ 1.5.4.0  Modified If Exists and add DataStoreItemID clause
  || 06/15/11 QMD WMJ 10.5.4.4 Increased size of @dataStoreItemID and @dataStoreFolderID
  || 05/09/13 KMC WMJ 10.5.6.7 Added UID column to update
  */


IF EXISTS (SELECT 1 FROM tSyncItem WHERE ApplicationFolderKey = @applicationFolderKey AND ApplicationItemKey = @applicationItemKey AND DataStoreItemID = @dataStoreItemID AND CompanyKey = @companyKey)
  BEGIN
	-- this update statement will update the last modified date
    UPDATE	tSyncItem
    SET		LastSync = @lastSync
    WHERE	ApplicationFolderKey = @applicationFolderKey
			AND ApplicationItemKey = @applicationItemKey
			AND DataStoreItemID = @dataStoreItemID
			AND CompanyKey = @companyKey
  END
ELSE
  BEGIN
    INSERT INTO tSyncItem (CompanyKey, ApplicationItemKey, ApplicationFolderKey, DataStoreItemID, DataStoreFolderID, DataStoreDeletion, ApplicationDeletion, LastSync, UID)
	VALUES (@companyKey, @applicationItemKey, @applicationFolderKey, @dataStoreItemID, @dataStoreFolderID, @dataStoreDeletion, @applicationDeletion, CONVERT(SMALLDATETIME,@lastSync), @uid)
  END
GO
