USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTeamList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectTeamList]

	(
		@ProjectKey int,
		@EstimateKey int = NULL
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 12/15/09 GHL 10.515 Added rate for the new estimates in Flex 
|| 11/09/11 GHL 10.459 (125839) Filter out inactive users when EstimateKey =0
|| 06/04/12 GHL 10.556 (144282) Added cost to show on estimates
*/	

declare @GetRateFrom int

select @GetRateFrom = GetRateFrom
from   tProject (nolock)
where  ProjectKey = @ProjectKey

if isnull(@EstimateKey, 0) = 0
	SELECT 
		tUser.UserKey, 
		tCompany.CompanyName, 
		tUser.FirstName, 
		tUser.LastName, 
		tUser.Phone1, 
		tUser.Email,
		tUser.FirstName + ' ' + tUser.LastName as UserName,
		case when @GetRateFrom = 3 then tAssignment.HourlyRate else tUser.HourlyRate end as Rate,
		tUser.HourlyCost as Cost
	FROM tUser (NOLOCK) 
	INNER JOIN tAssignment (NOLOCK) ON 
		tUser.UserKey = tAssignment.UserKey INNER JOIN
		tCompany (NOLOCK) ON tUser.CompanyKey = tCompany.CompanyKey
	WHERE 
		tAssignment.ProjectKey = @ProjectKey
	AND tUser.Active = 1
	Order By tUser.FirstName + ' ' + tUser.LastName
	
ELSE
BEGIN		

	SELECT 
		tUser.UserKey, 
		tCompany.CompanyName, 
		tUser.FirstName, 
		tUser.LastName, 
		tUser.Phone1, 
		tUser.Email,
		tUser.FirstName + ' ' + tUser.LastName as UserName
	FROM tUser (NOLOCK) 
		INNER JOIN tEstimateUser (NOLOCK) ON tUser.UserKey = tEstimateUser.UserKey 
		INNER JOIN tCompany (NOLOCK) ON tUser.CompanyKey = tCompany.CompanyKey
	WHERE 
		tEstimateUser.EstimateKey = @EstimateKey

	UNION

	SELECT 
		tUser.UserKey, 
		tCompany.CompanyName, 
		tUser.FirstName, 
		tUser.LastName, 
		tUser.Phone1, 
		tUser.Email,
		tUser.FirstName + ' ' + tUser.LastName as UserName
	FROM tUser (NOLOCK) 
	INNER JOIN tAssignment (NOLOCK) ON tUser.UserKey = tAssignment.UserKey 
	INNER JOIN tCompany (NOLOCK) ON tUser.CompanyKey = tCompany.CompanyKey
	WHERE 
		tAssignment.ProjectKey = @ProjectKey
	AND tUser.Active = 1
	AND tAssignment.UserKey not in (select UserKey from tEstimateUser (nolock) where EstimateKey = @EstimateKey) 

	Order By tUser.FirstName + ' ' + tUser.LastName
	
END
GO
