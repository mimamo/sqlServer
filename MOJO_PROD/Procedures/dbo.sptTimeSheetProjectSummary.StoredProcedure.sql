USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetProjectSummary]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTimeSheetProjectSummary]

	(
		@TimeSheetKey int
	)

AS --Encrypt
/*
|| When      Who Rel     What
|| 06/20/13  WDF 10.569  (181720) Add Campaign ID/Name
*/

Select
	p.ProjectNumber,
	p.ProjectName,
	c.CampaignID,
	c.CampaignName,
	ISNULL(Sum(t.ActualHours), 0) as TotalHours
from
	tTime t (nolock)
	Left Outer Join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	Left Outer Join tCampaign c (nolock) ON p.CampaignKey = c.CampaignKey
Where
	t.TimeSheetKey = @TimeSheetKey
Group By
	p.ProjectNumber,
	p.ProjectName,
	c.CampaignID,
	c.CampaignName
Order By 
	p.ProjectNumber
GO
