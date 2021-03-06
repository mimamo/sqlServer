USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTeamGetByTeamName]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTeamGetByTeamName]
	@CompanyKey Int,
	@TeamName varchar(200)

AS -- Encrypt
/*
  || When     Who Rel		What
  || 04/28/09 MAS 10.5		Created
*/
	SELECT *
	FROM tTeam (NOLOCK)
	WHERE
		CompanyKey = @CompanyKey 
		And ltrim(rtrim(upper(TeamName))) = ltrim(rtrim(upper(@TeamName)))
GO
