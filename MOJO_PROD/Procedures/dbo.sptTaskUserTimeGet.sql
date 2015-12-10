USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserTimeGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptTaskUserTimeGet]

	 @ProjectKey int
	,@BudgetTaskKey int
	,@UserKey int
	
	
as --Encrypt
                
	select t.*
		  ,tu.UserKey
	      ,tu.PercComp as UserPercComp
	      ,tu.ActStart as UserActStart
	      ,tu.ActComplete as UserActComplete
	      ,p.StartDate as ProjectStartDate
	      ,p.CompleteDate as ProjectCompleteDate
	      ,p.ScheduleDirection
	from tTask t (nolock) 
		 inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey 
		 inner join tTaskUser tu (nolock) on tu.TaskKey = t.TaskKey
	where p.ProjectKey = @ProjectKey
	and t.BudgetTaskKey = @BudgetTaskKey
	and t.TaskType = 2
	and t.ScheduleTask = 1
	and tu.UserKey = @UserKey
	and ((isnull(t.PercCompSeparate,0) = 0 and isnull(t.PercComp,0) < 100) or (isnull(t.PercCompSeparate,0) = 1 and isnull(tu.PercComp,0) < 100))
	return 1
GO
