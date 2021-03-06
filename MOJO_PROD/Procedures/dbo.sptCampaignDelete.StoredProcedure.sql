USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignDelete]
	@CampaignKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 12/17/09  CRG 10.5.1.5 Added check for campaign segments linked to projects.
||                        Added check for both campaigns and campaign segments linked to media estimates.
||                        Added deletion of campaign segments for the campaign.
|| 1/14/10   CRG 10.5.1.7 Added delete of tWorkTypeCustom
|| 3/23/10  GHL 10.5.2.1  Added deletion of estimates
|| 4/7/10   GWG  10.251   Added null of convert entity on lead
*/

if isnull(@CampaignKey, 0) = 0
	return 1
	
	if exists(Select 1 from tProject (nolock) Where CampaignKey = @CampaignKey)
		Return -1 --A project is linked to this campaign

	IF EXISTS (SELECT 1 FROM tMediaEstimate (nolock) WHERE CampaignKey = @CampaignKey)
		RETURN -2 --A media estimate is linked to this campaign
		
	IF EXISTS 
			(SELECT 1 
			FROM	tProject p (nolock) 
			INNER JOIN tCampaignSegment cs (nolock) ON p.CampaignSegmentKey = cs.CampaignSegmentKey
			INNER JOIN tCampaign c (nolock) ON cs.CampaignKey = c.CampaignKey
			WHERE c.CampaignKey = @CampaignKey)
		RETURN -3 --A project is linked to campaign segments from this campaign

	IF EXISTS 
			(SELECT 1 
			FROM	tMediaEstimate me (nolock) 
			INNER JOIN tCampaignSegment cs (nolock) ON me.CampaignSegmentKey = cs.CampaignSegmentKey
			INNER JOIN tCampaign c (nolock) ON cs.CampaignKey = c.CampaignKey
			WHERE c.CampaignKey = @CampaignKey)
		RETURN -4 --A media estimate is linked to campaign segments from this campaign

	DELETE	tWorkTypeCustom
	WHERE	Entity = 'tCampaign'
	AND		EntityKey = @CampaignKey

	DELETE
	FROM tCampaignBudgetItem
	WHERE
		CampaignBudgetKey in (Select CampaignBudgetKey from tCampaignBudget Where CampaignKey = @CampaignKey) 
		
	DELETE
	FROM tCampaignBudget
	WHERE
		CampaignKey = @CampaignKey 

	DELETE	tCampaignSegment
	WHERE	CampaignKey = @CampaignKey
		

DELETE tEstimateUser FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateUser.EstimateKey AND
	CampaignKey = @CampaignKey

DELETE tEstimateTaskExpense FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateTaskExpense.EstimateKey AND
	CampaignKey = @CampaignKey

DELETE tEstimateTaskAssignmentLabor FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateTaskAssignmentLabor.EstimateKey AND
	CampaignKey = @CampaignKey

DELETE tEstimateTaskLabor FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateTaskLabor.EstimateKey AND
	CampaignKey = @CampaignKey

DELETE tEstimateService FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateService.EstimateKey AND
	CampaignKey = @CampaignKey

DELETE tEstimateTask FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateTask.EstimateKey AND
	CampaignKey = @CampaignKey

DELETE tEstimateNotify FROM tEstimate (NOLOCK) WHERE 
	tEstimate.EstimateKey = tEstimateNotify.EstimateKey AND
	CampaignKey = @CampaignKey

DELETE tEstimate WHERE 	CampaignKey = @CampaignKey

UPDATE tLead
	SET ConvertEntity = NULL, ConvertEntityKey = NULL
WHERE  ConvertEntity = 'tCampaign' and ConvertEntityKey = @CampaignKey
		
		
		
	DELETE
	FROM tCampaign
	WHERE
		CampaignKey = @CampaignKey 

	RETURN 1
GO
