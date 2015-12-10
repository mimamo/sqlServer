USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignSegmentUpdate]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignSegmentUpdate]
	@CampaignSegmentKey int,
	@CampaignKey int,
	@SegmentName varchar(500),
	@SegmentDescription text,
	@DisplayOrder int,
	@PlanStart smalldatetime,
	@PlanComplete smalldatetime,
	@ProjectTypeKey int,
	@LeadKey int
AS

/*
|| When      Who Rel      What
|| 12/15/09  CRG 10.5.1.5 Created
|| 3/5/10    CRG 10.5.1.9 Added @ProjectTypeKey
|| 3/9/10    CRG 10.5.2.0 Added @LeadKey
*/

	IF @CampaignSegmentKey > 0
	BEGIN
		UPDATE	tCampaignSegment
		SET		CampaignKey = @CampaignKey,
				SegmentName = @SegmentName,
				SegmentDescription = @SegmentDescription,
				DisplayOrder = @DisplayOrder,
				PlanStart = @PlanStart,
				PlanComplete = @PlanComplete,
				ProjectTypeKey = @ProjectTypeKey,
				LeadKey = @LeadKey
		WHERE	CampaignSegmentKey = @CampaignSegmentKey
		
		RETURN @CampaignSegmentKey
	END
	ELSE
	BEGIN
		INSERT	tCampaignSegment
				(CampaignKey,
				SegmentName,
				SegmentDescription,
				DisplayOrder,
				PlanStart,
				PlanComplete,
				ProjectTypeKey,
				LeadKey)
		VALUES	(@CampaignKey,
				@SegmentName,
				@SegmentDescription,
				@DisplayOrder,
				@PlanStart,
				@PlanComplete,
				@ProjectTypeKey,
				@LeadKey)
				
		RETURN @@IDENTITY
	END
GO
