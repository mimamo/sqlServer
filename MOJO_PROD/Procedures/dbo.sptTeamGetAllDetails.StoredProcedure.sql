USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTeamGetAllDetails]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTeamGetAllDetails]
	@CompanyKey Int
	
AS -- Encrypt
/*
  || When     Who Rel		What
  || 09/20/09 MAS 10.5.0.9	Created
  || 02/05/10 RLB 10.518    added OwnerCompanyKey = @CompanyKey to the where
  || 12/06/12 RLB 10.563   (161633) added needed fields for update
  || 04/29/13 RLB 10,567   (176345) Order Teams by Team Name
*/


-- Teams
	SELECT *
	FROM tTeam (NOLOCK)
	WHERE CompanyKey = @CompanyKey
	Order By TeamName 

-- Users
	Select tu.TeamKey,
		 u.*
	     ,ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS UserName
		 ,SUBSTRING(ISNULL(u.FirstName, ''),1,1) + SUBSTRING(ISNULL(u.MiddleName, ''),1,1) + SUBSTRING(ISNULL(u.LastName, ''),1,1) AS Initials
		 ,s.Description AS ServiceDescription
	from tTeamUser tu (nolock)
	Join tUser u (nolock) on tu.UserKey = u.UserKey
	left outer join tService s (nolock) on u.DefaultServiceKey = s.ServiceKey
	Where u.CompanyKey = @CompanyKey or u.OwnerCompanyKey = @CompanyKey
	Order by u.FirstName + ' ' + u.LastName
GO
