USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileVersionGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileVersionGetList]

	(
		@FileKey int
	)

AS --Encrypt


Select tDAFileVersion.*,
	tDAFile.FileName,
	tDAFile.CurrentVersionKey,
	tUser.FirstName + ' ' + tUser.LastName as VersionBy
From 
	tDAFileVersion (nolock)
	inner join tDAFile (nolock) on tDAFileVersion.FileKey = tDAFile.FileKey
	inner join tUser (nolock) on tUser.UserKey = tDAFileVersion.VersionByKey
Where
	tDAFileVersion.FileKey = @FileKey and
	tDAFileVersion.FileVersionKey <> tDAFile.CurrentVersionKey
	
Order By VersionNumber
GO
