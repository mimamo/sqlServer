USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTeamDelete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTeamDelete]
	@TeamKey int
	,@SetActive tinyint

AS -- Encrypt

	IF @SetActive IS NULL
	BEGIN
	
		DELETE
		FROM tTeamUser
		WHERE
			TeamKey = @TeamKey 
	
		DELETE
		FROM tTeam
		WHERE
			TeamKey = @TeamKey 

	END
	ELSE

		UPDATE tTeam
		SET		Active = @SetActive
		WHERE
			TeamKey = @TeamKey 


	RETURN 1
GO
