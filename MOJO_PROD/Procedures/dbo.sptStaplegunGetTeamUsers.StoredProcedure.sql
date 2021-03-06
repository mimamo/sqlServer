USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStaplegunGetTeamUsers]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStaplegunGetTeamUsers]
	@CompanyKey Int
	,@TeamName varchar(200)
	
AS -- Encrypt
/*
  || When     Who Rel	  What
  || 10/09/13 WDF 10.573  (183959) Created for Staplegun API
*/

	SELECT tu.TeamKey
		  ,u.*
		  ,s.Description AS ServiceDescription
	FROM tTeam t (NOLOCK) LEFT JOIN tTeamUser tu (nolock) ON (t.TeamKey = tu.TeamKey)
	                      LEFT JOIN tUser u (nolock) on tu.UserKey = u.UserKey
	                      LEFT JOIN tService s (nolock) on u.DefaultServiceKey = s.ServiceKey
	WHERE (u.CompanyKey = @CompanyKey 
	   OR  u.OwnerCompanyKey = @CompanyKey)
	  And ltrim(rtrim(upper(TeamName))) = ltrim(rtrim(upper(@TeamName)))
	Order by u.FirstName + ' ' + u.LastName 

	RETURN 1
GO
