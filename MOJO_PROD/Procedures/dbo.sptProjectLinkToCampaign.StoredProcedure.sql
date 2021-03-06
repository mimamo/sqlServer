USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectLinkToCampaign]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectLinkToCampaign]
	@ProjectKey int,
	@CampaignKey int,
	@CampaignSegmentKey int
AS

/*
|| When      Who Rel      What
|| 6/7/10    CRG 10.5.3.1 Created
|| 8/18/10   CRG 10.5.3.3 Now setting CampaignOrder
*/

	DECLARE	@CampaignOrder int
	SELECT	@CampaignOrder = MAX(CampaignOrder)
	FROM	tProject (nolock)
	WHERE	CampaignKey = @CampaignKey

	SELECT	@CampaignOrder = ISNULL(@CampaignOrder, -1) + 1

	UPDATE	tProject
	SET		CampaignKey = @CampaignKey,
			CampaignSegmentKey = @CampaignSegmentKey,
			CampaignOrder = @CampaignOrder
	WHERE	ProjectKey = @ProjectKey
GO
