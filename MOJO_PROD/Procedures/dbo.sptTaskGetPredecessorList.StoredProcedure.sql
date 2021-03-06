USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetPredecessorList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskGetPredecessorList]

	(
		@TaskKey int
	)

AS --Encrypt

Declare @ProjectKey int

Select @ProjectKey = ProjectKey from tTask (nolock) Where TaskKey = @TaskKey


Select
	tp.TaskKey, tp.PredecessorKey, t.TaskID, t2.TaskID as PredecessorTaskID
from
	tTaskPredecessor tp (nolock)
	inner join tTask t (nolock) on tp.TaskKey = t.TaskKey
	inner join tTask t2 (nolock) on tp.PredecessorKey = t2.TaskKey
Where
	t.ProjectKey = @ProjectKey and
	t.TaskType = 2
GO
