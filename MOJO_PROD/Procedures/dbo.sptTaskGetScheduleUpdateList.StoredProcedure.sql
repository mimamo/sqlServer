USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetScheduleUpdateList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGetScheduleUpdateList]
	(
	@ProjectKey int
	)
AS

/*
|| When      Who Rel      What
|| 7/23/10   CRG 10.5.3.2 Added SEventStart and SEventEnd
*/

SELECT
    t.TaskKey, t.PlanStart, t.PlanComplete, t.PercComp, t.PlanDuration, t.ActStart, t.ActComplete, t.AssignedNames, t.TaskStatus, t.ScheduleNote,
    t2.TaskKey as STaskKey,t2.PlanStart as SPlanStart, t2.PlanComplete as SPlanComplete, t2.PercComp as SPercComp, t2.PlanDuration as SPlanDuration,
	t2.EventStart AS SEventStart, t2.EventEnd AS SEventEnd,
    p.StartDate as ProjectStartDate, p.CompleteDate as ProjectCompleteDate, p.PercComp as ProjectPercComp
    FROM 
    tTask t (nolock)
    INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
    LEFT OUTER JOIN tTask t2 (nolock) ON t.SummaryTaskKey = t2.TaskKey
    Where t.ProjectKey = @ProjectKey and t.TaskType = 2
GO
