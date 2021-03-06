USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderIncludeInSyncGetList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderIncludeInSyncGetList]
	@Entity varchar(50),
	@UserKey int
AS

/*
|| When      Who Rel      What
|| 4/24/09   CRG 10.5.0.0 Created to get a list of CMFolders selected to include in the Sync.
||                        We must use this SP, rather than just doing a direct query of the table because
||                        there may be a scenario where a default folder was not inserted into the IncludeInSync table yet.
*/

	DECLARE	@DefaultCMFolderKey int
	SELECT	@DefaultCMFolderKey = 
				CASE 
					WHEN @Entity = 'tCalendar' THEN DefaultCMFolderKey
					ELSE DefaultContactCMFolderKey
				END
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey
	
	SELECT	CMFolderKey
	FROM	tCMFolder (nolock)
	WHERE	(Entity = @Entity
			AND	CMFolderKey IN
				(SELECT	CMFolderKey
				FROM	tCMFolderIncludeInSync (nolock)
				WHERE	UserKey = @UserKey)
			)
	OR		CMFolderKey = @DefaultCMFolderKey
GO
