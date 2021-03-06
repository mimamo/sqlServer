USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderValid]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderValid]
	@CompanyKey int,
	@FolderName varchar(200),
	@Entity varchar(50),
	@UserKey int = 0
AS

DECLARE @CMFolderKey int

SELECT
	@CMFolderKey = CMFolderKey
FROM
	tCMFolder
WHERE
	CompanyKey = @CompanyKey AND
	Entity = @Entity AND
	UserKey = @UserKey AND
	FolderName = @FolderName
		
RETURN ISNULL(@CMFolderKey, 0)
GO
