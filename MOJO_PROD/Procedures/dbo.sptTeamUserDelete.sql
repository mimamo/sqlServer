USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTeamUserDelete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTeamUserDelete]
	(
		@TeamKey INT
		,@UserKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON 
	
	DELETE tTeamUser
	WHERE  TeamKey = @TeamKey
	AND	   UserKey = @UserKey
	
	
	RETURN 1
GO
