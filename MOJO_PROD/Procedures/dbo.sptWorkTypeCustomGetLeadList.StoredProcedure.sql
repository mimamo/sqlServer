USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWorkTypeCustomGetLeadList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWorkTypeCustomGetLeadList]
	@CompanyKey int,
	@LeadKey int
AS

/*
|| When      Who Rel      What
|| 3/8/10    CRG 10.5.2.0 Created
*/

	SELECT	'tLead' AS Entity,
			@LeadKey AS EntityKey,
			wt.WorkTypeKey, 
			ISNULL(c.Subject, wt.WorkTypeName) AS Subject,
			ISNULL(c.Description, wt.Description) AS Description
	FROM	tWorkType wt (nolock)
	LEFT JOIN tWorkTypeCustom c (nolock) ON c.Entity = 'tLead' AND c.EntityKey = @LeadKey AND wt.WorkTypeKey = c.WorkTypeKey
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
	INNER JOIN tLead l (nolock) ON cs.LeadKey = l.LeadKey
	LEFT JOIN tWorkTypeCustom c (nolock) ON c.Entity = 'tCampaignSegment' AND cs.CampaignSegmentKey = c.EntityKey AND wt.WorkTypeKey = c.WorkTypeKey
	WHERE	wt.CompanyKey = @CompanyKey
	AND		l.LeadKey = @LeadKey
	AND		wt.Active = 1
GO
