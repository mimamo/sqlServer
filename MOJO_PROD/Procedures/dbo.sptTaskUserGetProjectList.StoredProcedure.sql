USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserGetProjectList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserGetProjectList]
	(
		@ProjectKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	SELECT	tu.*
			,u.FirstName + ' ' + u.LastName AS UserName
			,UPPER(LEFT(ISNULL(u.FirstName, ''), 1) 
			     + LEFT(ISNULL(u.MiddleName, ''), 1)
			     + LEFT(ISNULL(u.LastName, ''), 1)) AS Initials
	FROM	tTaskUser  tu (nolock)
			INNER JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey
			INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey
	WHERE	t.ProjectKey = @ProjectKey
	
	RETURN 1
GO
