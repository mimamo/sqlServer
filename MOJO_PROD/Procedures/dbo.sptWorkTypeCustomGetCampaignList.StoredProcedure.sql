USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWorkTypeCustomGetCampaignList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWorkTypeCustomGetCampaignList]
	@CompanyKey int,
	@CampaignKey int
AS

/*
|| When      Who Rel      What
|| 1/12/10   CRG 10.5.1.6 Created
|| 1/14/10   CRG 10.5.1.7 Added CompanyKey parameter in case @CampaignKey is 0 (in addMode)
*/

	SELECT	'tCampaign' AS Entity,
			@CampaignKey AS EntityKey,
			wt.WorkTypeKey, 
			ISNULL(c.Subject, wt.WorkTypeName) AS Subject,
			ISNULL(c.Description, wt.Description) AS Description
	FROM	tWorkType wt (nolock)
	LEFT JOIN tWorkTypeCustom c (nolock) ON c.Entity = 'tCampaign' AND c.EntityKey = @CampaignKey AND wt.WorkTypeKey = c.WorkTypeKey
	WHERE	wt.CompanyKey = @CompanyKey
	AND		wt.Active = 1
	
	UNION ALL

	SELECT	'tCampaignSegment',
			cs.CampaignSegmentKey,
			wt.WorkTypeKey,
			ISNULL(c.Subject, wt.WorkTypeName) AS Subject,
			ISNULL(c.Description, wt.Description) AS Description
	FROM	tCampaignSegment cs (nolock)
	INNER JOIN tWorkType wt (nolock) ON 1=1 --Create cartesian product of tCampaignSegment and tWorkType
	INNER JOIN tCampaign camp (nolock) ON cs.CampaignKey = camp.CampaignKey
	LEFT JOIN tWorkTypeCustom c (nolock) ON c.Entity = 'tCampaignSegment' AND cs.CampaignSegmentKey = c.EntityKey AND wt.WorkTypeKey = c.WorkTypeKey
	WHERE	wt.CompanyKey = @CompanyKey
	AND		camp.CampaignKey = @CampaignKey
	AND		wt.Active = 1
GO
