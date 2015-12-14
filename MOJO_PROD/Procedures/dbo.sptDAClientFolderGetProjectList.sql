USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAClientFolderGetProjectList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAClientFolderGetProjectList]

	(
		@ProjectKey int
	)

AS --Encrypt


Select 
	tDAClientFolder.*
	from tDAClientFolder (nolock) 
	Where ProjectKey = @ProjectKey
GO
