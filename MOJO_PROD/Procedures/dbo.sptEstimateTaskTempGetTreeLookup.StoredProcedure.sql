USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskTempGetTreeLookup]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptEstimateTaskTempGetTreeLookup]
	 @Entity varchar(50)
    ,@EntityKey int
AS --Encrypt

/*
|| When     Who Rel     What
|| 04/05/10 GHL 10.521  Clone of sptTaskGetTreeLookup for new sptEstimateTaskTemp lookup
|| 04/06/10 GWG 10.521  Modified slightly. all tasks are considered user assigned.
*/
	select
		t.TaskKey
		,t.TaskID
		,t.TaskName
		,t.SummaryTaskKey
		,t.TaskType
		,t.TaskLevel
		,t.AllowAnyone
		,t.ScheduleTask
		,t.TrackBudget
		,t.MoneyTask
		,0 as PercComp -- t.PercComp
		 
		,1 as UserAssigned
			
	  from tEstimateTaskTemp t (nolock)
	 where t.Entity = @Entity
	 and   t.EntityKey = @EntityKey
  order by t.ProjectOrder
	 
	return 1
GO
