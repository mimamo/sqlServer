USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetInfo]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGetInfo]
	@TaskKey int

AS --Encrypt

		SELECT t.*
		      ,p.GetRateFrom
		      ,p.ProjectStatusKey
		      ,p.ScheduleDirection
		      ,p.StartDate
		      ,p.CompleteDate
		      ,ts.TaskID as SummaryTaskID
		      ,ISNULL((Select Sum(AssignmentPercent) from tTaskAssignment (NOLOCK) Where TaskKey = @TaskKey), 0) as AssignmentPercent
			  ,ISNULL((SELECT MAX(WorkOrder) FROM  tTaskAssignment (NOLOCK) WHERE TaskKey = @TaskKey), 0) AS MaxWorkOrder
		FROM tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tTask ts (nolock) on t.SummaryTaskKey = ts.TaskKey
		WHERE
			t.TaskKey = @TaskKey

	RETURN 1
GO
