USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTeamUserGetList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTeamUserGetList]
	(
		@TeamKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	SELECT  tu.TeamKey
			,u.UserKey
			,u.FirstName
			,u.LastName
			,u.MiddleName
	FROM	tTeamUser tu (NOLOCK)
		INNER JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey
	WHERE	tu.TeamKey = @TeamKey
	
	
	RETURN 1
GO
