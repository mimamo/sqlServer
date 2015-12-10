USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectRollupSchedule]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectRollupSchedule]
	@ProjectKey int,
	@PercComp int,
	@Duration int
AS --Encrypt

  /*
  || When     Who Rel      What
  || 08/09/10 GHL 10.533   Removed update of tTask.TotalActualHours
  || 11/18/10 CRG 10.5.3.8 Modified to call sptTaskRollupAssignedNames
  */
-- reset everything else to 0
Update tTask Set TotalAllocatedHours = 0, AssignedNames = NULL Where ProjectKey = @ProjectKey

-- Roll up the allocated hours
Update tTask Set TotalAllocatedHours = ISNULL(
	(select SUM(tu.Hours)
	from tTaskUser tu (nolock)
	where tu.TaskKey = tTask.TaskKey), 0)
Where tTask.ProjectKey = @ProjectKey and tTask.TaskType = 2

Declare @TaskKey int, @TaskUserKey int, @Names varchar(2000), @UserName varchar(100), @UserKey int, @ServiceKey int, @Hours decimal(24,4)

Select @TaskKey = -1
While 1=1
BEGIN
	Select @TaskKey = MIN(TaskKey) from tTask (nolock) Where ProjectKey = @ProjectKey and TaskType = 2 and TaskKey > @TaskKey
	if @TaskKey is null
		break

	EXEC sptTaskRollupAssignedNames @TaskKey
END

-- Update the Project Percent Complete
Update tProject Set PercComp = @PercComp, Duration = @Duration Where ProjectKey = @ProjectKey

/*
Declare @TotalDur as Int, @CompletedDur Decimal(24,4), @ProjectPercComp decimal(24,4)

Select @TotalDur = Sum(PlanDuration), @CompletedDur = Sum(PlanDuration * (PercComp / 100.00)) 
From tTask (nolock) 
Where ProjectKey = @ProjectKey and TaskType = 2

if ISNULL(@TotalDur, 0) = 0 
	select @ProjectPercComp = 0
else
	select @ProjectPercComp = (@CompletedDur / @TotalDur) * 100.0

Update tProject Set PercComp = @ProjectPercComp Where ProjectKey = @ProjectKey



-- Roll up the min/max plan start complete (actually, this is not needed as its done on the schedule

declare @MinStart smalldatetime, @MaxComplete smalldatetime, @CurOrder int, @CurLevel int,  @TaskStart smalldatetime, @TaskComplete smalldatetime, @TaskType int


Select @CurLevel = ISNULL(Max(TaskLevel), 0) from tTask (nolock) Where ProjectKey = @ProjectKey
While 1=1
BEGIN
	-- if there is only one level or no tasks, then bail
	if @CurLevel < 1
		Break

	-- drop the level now as we are looking to roll up to the level above
	Select @CurLevel = @CurLevel -1

	Update tTask
	Set PlanStart = MinPlanStart, PlanComplete = MaxPlanComplete, 
		TotalActualHours = ISNULL(TotalActualHours, 0) + ISNULL(SumActualHours, 0), 
		TotalAllocatedHours = ISNULL(TotalAllocatedHours, 0) + ISNULL(SumAllocatedHours, 0),
		PercComp = Case When TotalDuration = 0 then 0 else Round(CompletedDuration / TotalDuration, 3) end
	From 
		(Select SummaryTaskKey, Min(PlanStart) as MinPlanStart, Max(PlanComplete) as MaxPlanComplete, Sum(TotalActualHours) as SumActualHours, Sum(TotalAllocatedHours) as SumAllocatedHours,
			Sum(ISNULL(PlanDuration, 0)) as TotalDuration, Sum(ISNULL(PlanDuration, 0) * ISNULL(PercComp, 0)) as CompletedDuration
			From tTask t (nolock) Where ProjectKey = @ProjectKey and TaskLevel = @CurLevel + 1
			Group By SummaryTaskKey) as tbl
	Where tTask.TaskKey = tbl.SummaryTaskKey and tTask.TaskType = 1 and TaskLevel = @CurLevel

END

*/
GO
