USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectCreativeBriefGetDefaults]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectCreativeBriefGetDefaults]

	(
		@ProjectKey int
	)

AS --Encrypt

Select
	pt.*
From
	tProjectType pt (nolock)
	Inner Join tProject p (nolock) on pt.ProjectTypeKey = p.ProjectTypeKey
Where
	p.ProjectKey = @ProjectKey
GO
