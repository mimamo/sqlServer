USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTeamGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTeamGet]
	@TeamKey int = null,
	@TeamName varchar(200) = null,
	@CompanyKey  int = null

AS -- Encrypt
  /*
  || When     Who Rel    What
  || 02/15/13 WDF 10.565 (164777) Modified for Team Importing  
  */

	if ISNULL(@TeamKey, 0) = 0
		SELECT *
		  FROM tTeam (nolock)
		 WHERE CompanyKey  = @CompanyKey 
		   AND UPPER(TeamName) = UPPER(@TeamName)
	ELSE		
		SELECT *
		  FROM tTeam (nolock)
		 WHERE TeamKey = @TeamKey

    RETURN 1
GO
