USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeLoadGrid]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTimeLoadGrid]

	(
		@TimeSheetKey int
	)

AS --Encrypt

-- GHL Fixed Ambiguous RateLavel field

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
	t.Comments,
	p.ProjectName,
	p.ProjectNumber,
	p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName,
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
	s.ServiceCode

From
	tTime t (nolock)
	Left Outer Join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	Left Outer Join tTask ta (nolock) on t.TaskKey = ta.TaskKey
	Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
Where
	t.TimeSheetKey = @TimeSheetKey
	
Order By 
	ProjectNumber, TaskID, ServiceCode, t.RateLevel, WorkDate
GO
