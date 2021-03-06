USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetByName]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGetByName]
	@TaskName VARCHAR(2500),
	@ProjectNumber VARCHAR(500),
	@CompanyKey INT
AS

/*
|| When       Who Rel      What
|| 04/30/14   QMD 10.5.7.9 Created for API 
*/

	SELECT	t.*
	FROM	tTask t (NOLOCK) INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
	WHERE	UPPER(LTRIM(RTRIM(TaskName))) = UPPER(LTRIM(RTRIM(@TaskName)))
			AND p.ProjectNumber = @ProjectNumber
			AND p.CompanyKey = @CompanyKey
			AND t.ActComplete IS NULL 
			AND t.PercComp <> 100
	
Return 1
GO
