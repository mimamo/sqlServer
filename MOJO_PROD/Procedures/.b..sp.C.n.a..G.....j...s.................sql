USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactGetProjects]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptContactGetProjects]

	(
		@ClientKey int
	)

AS --Encrypt

Select
	p.ProjectKey,
	ISNULL(p.ProjectNumber, '') + ' ' + ISNULL(LEFT(p.ProjectName, 25), '') as ProjectFullName
From
	tProject p (nolock)
Where
	p.ClientKey = @ClientKey
Order By
	p.ProjectNumber
GO
