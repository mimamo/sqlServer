USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderGetByName]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderGetByName]
	@CompanyKey int,
	@UserKey int,
	@Entity varchar(50),
	@FolderName varchar(200)

AS

/*
|| When      Who Rel      What
|| 3/16/09   CRG 10.5.0.0 Created for the Web to Lead process
*/

	SELECT	*
	FROM	tCMFolder (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		ISNULL(UserKey, 0) = @UserKey
	AND		Entity = @Entity
	AND		UPPER(FolderName) = UPPER(@FolderName)
GO
