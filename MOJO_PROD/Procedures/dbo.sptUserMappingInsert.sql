USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserMappingInsert]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserMappingInsert]
	@OwnerUserKey INT,
	@CMFolderKey INT, 
	@UserKey INT,
	@Uid VARCHAR(2500)

AS

/*
|| When      Who Rel      What
|| 10/01/13  QMD 10.5.7.3 Created to keep track of the uid from each client in carddav.  
*/

	IF NOT EXISTS(SELECT * FROM tUserMapping WHERE OwnerUserKey = @OwnerUserKey AND UserKey = @UserKey AND CMFolderKey = @CMFolderKey and Uid = @Uid)
		INSERT INTO tUserMapping VALUES ( @OwnerUserKey, @UserKey, @CMFolderKey, @Uid )
GO
