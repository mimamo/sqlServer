USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAClientFolderGetProjectListByFolder]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAClientFolderGetProjectListByFolder]

	(
		@FolderKey int
	)

AS --Encrypt

Declare @ProjectKey int

Select @ProjectKey = ProjectKey from tDAClientFolder (nolock) Where ClientFolderKey = @FolderKey

Select 
	tDAClientFolder.*
	from tDAClientFolder  (nolock)
	Where ProjectKey = @ProjectKey
GO
