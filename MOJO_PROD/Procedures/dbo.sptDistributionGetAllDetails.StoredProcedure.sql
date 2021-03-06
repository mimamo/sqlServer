USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDistributionGetAllDetails]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDistributionGetAllDetails]
	@CompanyKey Int,
	@UserKey Int,
	@Personal Int
	
AS -- Encrypt
/*
  || 09/30/13 RLB 105.7.3 (187730) Created for diary enhancement
*/


-- Distribution Groups
	SELECT *
	FROM   tDistributionGroup (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    (UserKey IS NULL OR UserKey = @UserKey)
	AND    Personal = @Personal

-- Users
SELECT dgu.DistributionGroupKey,
		 u.*
	     ,ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS UserName
		 ,SUBSTRING(ISNULL(u.FirstName, ''),1,1) + SUBSTRING(ISNULL(u.MiddleName, ''),1,1) + SUBSTRING(ISNULL(u.LastName, ''),1,1) AS Initials
		 ,s.Description AS ServiceDescription	      	
	FROM   tDistributionGroupUser dgu (NOLOCK)
		INNER JOIN tUser u (NOLOCK) ON dgu.UserKey = u.UserKey 
		LEFT OUTER JOIN tService s (nolock) on u.DefaultServiceKey = s.ServiceKey		
	Where u.CompanyKey = @CompanyKey or u.OwnerCompanyKey = @CompanyKey
	Order by u.FirstName + ' ' + u.LastName
GO
