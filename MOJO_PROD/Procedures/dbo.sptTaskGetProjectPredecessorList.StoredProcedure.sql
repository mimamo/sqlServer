USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetProjectPredecessorList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskGetProjectPredecessorList]

	(
		@ProjectKey int
	)

AS --Encrypt

Select
	tp.TaskPredecessorKey
	,tp.TaskKey
	,tp.PredecessorKey
	,tp.Lag
	,t.PlanDuration
	,tpt.TaskID
	,tpt.PlanDuration As PredecessorPlanDuration
	,tpt.ProjectOrder AS PredecessorProjectOrder
from
	tTask t (nolock),
	tTask tpt (nolock),
	tTaskPredecessor tp (nolock)
Where
	t.ProjectKey = @ProjectKey and
	t.TaskKey = tp.TaskKey and
	tp.PredecessorKey = tpt.TaskKey
GO
