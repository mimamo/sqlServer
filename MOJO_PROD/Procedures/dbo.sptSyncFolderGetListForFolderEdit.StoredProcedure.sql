USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncFolderGetListForFolderEdit]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSyncFolderGetListForFolderEdit]
	@CompanyKey int,
	@Entity varchar(50),
	@UserKey int,
	@SyncFolderKey int
AS

/*
|| When      Who Rel      What
|| 4/21/09   CRG 10.5.0.0 Created for the Contact and Calendar folder edit screens
|| 12/23/09  QMD 10.5.1.8 Added SyncApp to the select statement
*/

	SELECT	SyncFolderKey, 
			SyncFolderName,
			ISNULL(SyncApp,0) AS SyncApp
	FROM	tSyncFolder (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	AND		Entity = @Entity
	AND		ISNULL(UserKey, 0) = ISNULL(@UserKey, 0)
	AND		((SyncFolderKey = @SyncFolderKey)
		OR	(SyncFolderKey NOT IN (SELECT SyncFolderKey FROM tCMFolder (nolock) WHERE SyncFolderKey IS NOT NULL)))
GO
