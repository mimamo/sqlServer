USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignBudgetGetProjectTypes]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignBudgetGetProjectTypes]
	@CompanyKey int,
	@CampaignKey int,
	@CampaignBudgetKey int
AS

/*
|| When      Who Rel     What
|| 5/22/07   CRG 8.4.3   (9293) Created to load the Project Type lists on the Campaign Budget screen.
*/

	IF @CampaignBudgetKey = 0
		SELECT	pt.ProjectTypeKey AS EntityKey,
				'ProjectType' AS Entity,
				pt.ProjectTypeName AS ItemName
		FROM	tProjectType pt (nolock)
		WHERE	pt.CompanyKey = @CompanyKey
		AND		pt.ProjectTypeKey NOT IN (Select EntityKey from tCampaignBudgetItem (nolock) Where CampaignKey = @CampaignKey and Entity = 'ProjectType')
		ORDER BY ProjectTypeName
	ELSE
		SELECT	pt.ProjectTypeKey AS EntityKey,
				'ProjectType' AS Entity,
				pt.ProjectTypeName AS ItemName
		FROM	tProjectType pt (nolock)
		INNER JOIN tCampaignBudgetItem cbi (nolock) ON pt.ProjectTypeKey = cbi.EntityKey AND Entity = 'ProjectType'
		WHERE	cbi.CampaignBudgetKey = @CampaignBudgetKey
		ORDER BY ProjectTypeName
GO
