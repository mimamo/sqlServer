USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTeamUserInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTeamUserInsert]
	(
		@TeamKey INT,
		@UserKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	IF EXISTS (
				SELECT 1
				FROM tTeamUser (NOLOCK)
			   	WHERE TeamKey = @TeamKey
			   	AND	  UserKey = @UserKey
			   )
		RETURN 1
		
	INSERT tTeamUser (TeamKey, UserKey)
	VALUES (@TeamKey, @UserKey)	
				
	RETURN 1
GO
