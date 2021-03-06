USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignSegmentDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignSegmentDelete]
	@CampaignSegmentKey int
AS

/*
|| When      Who Rel      What
|| 12/15/09  CRG 10.5.1.5 Created
|| 1/14/10   CRG 10.5.1.7 Added delete of tWorkTypeCustom
|| 2/2/10    CRG 10.5.1.8 Added check of tEstimateTaskExpense and tEstimateTaskLabor before delete
|| 8/19/10   CRG 10.5.3.3 Per Greg, we are now clearing out the CampaignKey and CampaignSegmentKey from projects that were linked to this segment, rather than stopping the delete with an error.
*/

	IF EXISTS (SELECT 1 FROM tMediaEstimate (nolock) WHERE CampaignSegmentKey = @CampaignSegmentKey)
		RETURN -2
		
	IF EXISTS (SELECT 1 FROM tEstimateTaskExpense (nolock) WHERE CampaignSegmentKey = @CampaignSegmentKey)
		RETURN -3

	IF EXISTS (SELECT 1 FROM tEstimateTaskLabor (nolock) WHERE CampaignSegmentKey = @CampaignSegmentKey)
		RETURN -3

	IF EXISTS (SELECT 1 FROM tProject (nolock) WHERE CampaignSegmentKey = @CampaignSegmentKey)
		UPDATE	tProject 
		SET		CampaignKey = NULL,
				CampaignSegmentKey = NULL
		WHERE	CampaignSegmentKey = @CampaignSegmentKey

	DELETE	tWorkTypeCustom
	WHERE	Entity = 'tCampaignSegment'
	AND		EntityKey = @CampaignSegmentKey
		
	DELETE	tCampaignSegment
	WHERE	CampaignSegmentKey = @CampaignSegmentKey
GO
