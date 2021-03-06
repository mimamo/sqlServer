USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskCanUnschedule]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskCanUnschedule]
	@TaskKey int

AS --Encrypt

		SELECT (select count(*) 
						from tTaskPredecessor tp (nolock) 
						where tp.TaskKey = t.TaskKey) as HasPredecessorCount
		       ,(select count(*) 
						from tTaskPredecessor tp (nolock) 
						where tp.PredecessorKey = t.TaskKey) as IsPredecessorCount
			  ,(select count(*) from tTask (nolock) 
				where tTask.SummaryTaskKey = t.TaskKey
				and isnull(tTask.ScheduleTask,0) = 1) as ScheduledChildCount
		      ,(select count(*) from tTaskUser (nolock) 
				where tTaskUser.TaskKey = t.TaskKey) as AssignmentCount
		from tTask t (nolock)
		where t.TaskKey = @TaskKey

	return 1
GO
