USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGet]
	@TaskKey int

AS --Encrypt

		SELECT t.*
		      ,p.GetRateFrom
		      ,p.ProjectStatusKey
		      ,p.ProjectNumber
		      ,p.ProjectName
		      ,ts.TaskID as SummaryTaskID
		      ,case 
				when ts.TaskID is null then ts.TaskName
				else ts.TaskID + ' ' + ts.TaskName
				end as SummaryTaskFullName
		      ,tb.TaskID as BudgetTaskID
		      ,case 
				when tb.TaskID is null then tb.TaskName
				else tb.TaskID + ' ' + tb.TaskName
				end as BudgetTaskFullName
		      ,wt.WorkTypeName
		      ,isnull((select count(*) 
						from tTaskPredecessor tp (nolock) 
						where tp.TaskKey = t.TaskKey),0)
		       + isnull((select count(*) 
						from tTaskPredecessor tp (nolock) 
						where tp.PredecessorKey = t.TaskKey),0) as PredecessorRelCount
			  ,(select count(*) from tTask (nolock) 
				where tTask.SummaryTaskKey = t.TaskKey
				and isnull(tTask.ScheduleTask,0) = 1) as ScheduledChildCount
		      ,(Select Count(*) from tTaskUser (nolock) Where tTaskUser.TaskKey = t.TaskKey) as AssignmentCount
		      ,tat.TaskAssignmentType
		FROM tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tTask ts (nolock) on t.SummaryTaskKey = ts.TaskKey
			left outer join tTask tb (nolock) on t.BudgetTaskKey = tb.TaskKey
			left outer join tMasterTask mt (nolock) on t.MasterTaskKey = mt.MasterTaskKey
			left outer join tWorkType wt (nolock) on mt.WorkTypeKey = wt.WorkTypeKey	
			left outer join tTaskAssignmentType tat (nolock) on t.TaskAssignmentTypeKey = tat.TaskAssignmentTypeKey
		WHERE
			t.TaskKey = @TaskKey

	RETURN 1
GO
