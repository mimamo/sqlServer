USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetSimpleList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGetSimpleList]
	@CompanyKey int,
	@ProjectNumber varchar(50)
AS --Encrypt

/*
|| When      Who Rel     What
|| 8/29/07   CRG 8.5     Created to get a simple list of Tasks for the Project without any extra sub-queries.
*/

	SELECT	t.*
	FROM	tTask t (nolock)
	INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey	
	WHERE	UPPER(p.ProjectNumber) = UPPER(@ProjectNumber)
	AND		p.CompanyKey = @CompanyKey
GO
