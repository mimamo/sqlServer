USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestGetProjectList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestGetProjectList]

	(
		@RequestKey int
	)

AS


Select
	p.*, ps.ProjectStatus
from 
	tProject p (NOLOCK) 
	inner join tProjectStatus ps (NOLOCK) on p.ProjectStatusKey = ps.ProjectStatusKey
Where
	p.RequestKey = @RequestKey
Order By 
	p.ProjectNumber
GO
