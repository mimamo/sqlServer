USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignSegmentGetList]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignSegmentGetList]
	@CampaignKey int = null,
	@LeadKey int = null
AS

/*
|| When      Who Rel      What
|| 12/17/09  CRG 10.5.1.5 Created
|| 3/9/10    CRG 10.5.2.0 Added @LeadKey and made both parms optional.
|| 8/19/10   CRG 10.5.3.3 Added sort by DisplayOrder
*/

	SELECT	*
	FROM	tCampaignSegment (nolock)
	WHERE	(CampaignKey = @CampaignKey OR @CampaignKey IS NULL)
	AND		(LeadKey = @LeadKey OR @LeadKey IS NULL)
	ORDER BY DisplayOrder
GO
