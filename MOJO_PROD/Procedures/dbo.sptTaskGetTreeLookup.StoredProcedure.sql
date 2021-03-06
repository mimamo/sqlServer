USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetTreeLookup]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskGetTreeLookup]
	 @ProjectKey int
    ,@UserKey int	
AS --Encrypt

/*
|| When     Who Rel     What
|| 07/10/07 GHL 10.504  Limited number of fields pulled to those used in the Lookup  
||                      All fields should be present in IX_tTask_3
||                      Also added TaskName to IX_tTask_8 (now TaskKey, TaskID, TaskName) for summary task
||                      This sp is called anytime the user types a character in the task lookup
|| 07/22/09 RLB 10.504  Added SummaryTaskKey
|| 08/10/09 GWG 10.506  Removed the summary task info as we now show the tree.
|| 04/20/10 GWG 10.543  Changed the loop into user assigned so we don't have to loop down for it on summary tasks
|| 11/05/14  RLB 10.5.8.6 Added changes for Abelson Taylor Enhancement AnyoneChargeTime
*/

Declare @AnyoneChargeTime tinyint

SELECT @AnyoneChargeTime = AnyoneChargeTime from tProject (nolock) where ProjectKey = @ProjectKey

	select
		t.TaskKey
		,t.TaskID
		,t.TaskName
		,t.SummaryTaskKey
		--,summ.TaskID AS SummaryTaskID
		--,summ.TaskName AS SummaryTaskName
		--,isnull(summ.TaskID + ' - ', '') + summ.TaskName AS SummaryFullTaskName
		,t.TaskType
		,t.TaskLevel
		,t.AllowAnyone
		,t.ScheduleTask
		,t.TrackBudget
		,t.MoneyTask
		,t.PercComp
		,@AnyoneChargeTime as AnyoneChargeTime
		,ISNULL((Select Min(1) from tTaskUser tu (nolock) 
			inner join tTask tt (nolock) on tu.TaskKey = tt.TaskKey
			Where tt.BudgetTaskKey = t.TaskKey and tu.UserKey = @UserKey), 0) as UserAssigned
			
	  from tTask t (nolock)
	   --left outer join tTask summ (nolock) on t.SummaryTaskKey = summ.TaskKey  
	 where t.ProjectKey = @ProjectKey
  order by t.ProjectOrder
	 
	return 1
GO
