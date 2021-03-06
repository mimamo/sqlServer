USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignBudgetGetBudgets]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignBudgetGetBudgets]
	@CampaignKey int

AS --Encrypt

		SELECT p.ProjectKey, ProjectNumber, ProjectName, CampaignBudgetKey, c.CustomerID as ClientID, c.CompanyName, p.ProjectNumber + ' - ' + p.ProjectName as DisplayName, pr.*
		FROM tProject p (nolock)
			inner join tProjectRollup pr (nolock) on p.ProjectKey = pr.ProjectKey
			left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		WHERE
			p.CampaignKey = @CampaignKey

	RETURN 1
GO
