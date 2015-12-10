USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileSearchFTSetFileKey]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileSearchFTSetFileKey]

	(
		@FileRoot varchar(255)
	)

AS --Encrypt


Update #tFileSearch
Set 
	#tFileSearch.FileKey = tDAFile.FileKey
From 
	#tFileSearch, tDAFile (nolock), tDAFolder (nolock)
Where
	tDAFile.FolderKey = tDAFolder.FolderKey and
	UPPER(#tFileSearch.Path) = UPPER(@FileRoot + tDAFolder.SystemPath + '\' + tDAFile.FileName)
GO
