USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderSecurityUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderSecurityUpdate]
	@CMFolderKey int,
	@Entity varchar(50),
	@EntityKey int,
	@CanView tinyint,
	@CanAdd tinyint
AS --Encrypt

if exists(Select 1 from tCMFolderSecurity (nolock) Where CMFolderKey = @CMFolderKey and Entity = @Entity and EntityKey = @EntityKey)

	UPDATE
		tCMFolderSecurity
	SET
		CanView = @CanView,
		CanAdd = @CanAdd
	WHERE
		CMFolderKey = @CMFolderKey 
		AND Entity = @Entity 
		AND EntityKey = @EntityKey 

else

	INSERT tCMFolderSecurity
		(
		CMFolderKey,
		Entity,
		EntityKey,
		CanView,
		CanAdd
		)

	VALUES
		(
		@CMFolderKey,
		@Entity,
		@EntityKey,
		@CanView,
		@CanAdd
		)

	RETURN 1
GO
