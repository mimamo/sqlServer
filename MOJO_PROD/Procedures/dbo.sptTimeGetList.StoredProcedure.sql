USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeGetList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTimeGetList]

	(
		@TimeSheetKey int
	)

AS --Encrypt

  /*
  || When     Who Rel      What
  || 10/11/06 RTC 8.34     Remove duplicate column RateLevel.
  || 06/20/07 CRG 8.4.3.1  Added DetailTaskKey.
  || 09/30/08 RTC 10.0.0.9 Changed sort order of time entries which will change the order in the grid
  || 8/27/09  GHL 10.5     Added filter on TransferToKey
  || 11/6/09  CRG 10.5.1.3 Added PercComp
  || 10/6/10  CRG 10.5.3.6 Added Verified
  || 06/19/13 WDF 10.569   (181720) Add Campaign ID/Name
  */
  
Select
	t.TimeSheetKey,
	t.TimeKey,
	t.WorkDate,
	t.StartTime,
	t.EndTime,
	t.RateLevel,
	t.ActualHours,
	t.ActualRate,
	t.ServiceKey,
	t.RateLevel,
	t.ActualHours,
	ROUND(t.ActualHours * t.ActualRate, 2) as ActualAmount,
	t.PauseHours,
	t.Comments,
	t.ProjectKey,
	p.ProjectName,
	p.ProjectNumber,
	p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName,
	c.CampaignID,
	c.CampaignName,
	ISNULL(c.CampaignID, '') + '-' + ISNULL(c.CampaignName, '') AS CampaignFullName,
	t.TaskKey,
	ta.TaskID,
	ta.TaskName,
	ta.TaskID + ' ' + ta.TaskName as TaskFullName,
	Case t.RateLevel 
	When 1 then ISNULL(s.Description1, s.Description)
	When 2 then ISNULL(s.Description2, s.Description)
	When 3 then ISNULL(s.Description3, s.Description)
	When 4 then ISNULL(s.Description4, s.Description)
	When 5 then ISNULL(s.Description5, s.Description)
	else s.Description
	END as ServiceDescription,
	s.ServiceCode,
	t.DetailTaskKey,
	ta.PercComp,
	ISNULL(t.Verified, 0) AS Verified
From
	tTime t (nolock)
	Left Outer Join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	Left Outer Join tCampaign c (nolock) ON p.CampaignKey = c.CampaignKey
	Left Outer Join tTask ta (nolock) on t.TaskKey = ta.TaskKey
	Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
Where
	t.TimeSheetKey = @TimeSheetKey
And
    t.TransferToKey Is Null	
Order By 
	p.ProjectNumber, ta.TaskID, ServiceDescription, t.RateLevel
GO
