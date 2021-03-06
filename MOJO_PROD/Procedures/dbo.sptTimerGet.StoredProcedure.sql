USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimerGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimerGet]
	(
	@TimerKey int
	)
AS


  /*
  || When     Who Rel      What
  || 4/15/11  GWG 10.542   Changed Service Name to ServiceDescription
  || 8/17/11  GWG 10.546   Fixed some issues
  || 8/23/11  GWG 10.547   Added pause time into the calculation of the end time.
  || 9/15/11   GMG 10.5.4.6 HF Changed logic for Timer Widget
  || 11/1/11  GWG 10.549  Fixed rounding logic when more than 15 min
  */

Declare @Interval as Int
Declare @Paused as Int
Declare @IntervalRounding as Int
Declare @CompanyKey as Int
Declare @ElapsedMinutes as Int
Declare @MinuteDifferential as int
Declare @TimerMinutes as int
Declare @TimerHours as int
Declare @ActualHours as decimal(24,4)
Declare @PauseHours as decimal(24,4)
Declare @ElapsedSeconds as decimal(24,4)

Select	@CompanyKey = CompanyKey, 
		@Paused = ISNULL(Paused,0)
from tTimer (nolock) 
Where TimerKey = @TimerKey


Select	@Interval = ISNULL(TimerInterval,0),			-- default the interval to no rounding
		@IntervalRounding = ISNULL(TimerRounding,0) 	-- default the interval to no round up(0) -  0 up, 1 down
from tPreference (nolock)
Where CompanyKey = @CompanyKey


if @Paused = 0
	begin
		Select	@ElapsedMinutes = CEILING(DATEDIFF(mi, StartTime, GETUTCDATE())- CEILING(ISNULL(PauseSeconds,0)/60)), 
				@ElapsedSeconds = DATEDIFF(ss, StartTime, GETUTCDATE())- ISNULL(PauseSeconds,0),
				@PauseHours = ISNULL(@ElapsedMinutes,0)/60
		From tTimer 
		Where TimerKey = @TimerKey
	end	
Else
	begin
		Select	@ElapsedMinutes = CEILING(DATEDIFF(mi, StartTime, PauseTime)- CEILING(ISNULL(PauseSeconds,0)/60)), 
				@ElapsedSeconds = DATEDIFF(ss, StartTime, PauseTime)- ISNULL(PauseSeconds,0),
				@PauseHours = ISNULL(@ElapsedMinutes,0)/60
		From tTimer 
		Where TimerKey = @TimerKey
	end


Select @TimerMinutes = @ElapsedMinutes	
if ISNULL(@Interval,0) > 0	  -- using rounding
	begin -- Check what type of rounding we're using (up or down)	
		if ISNULL(@IntervalRounding,0) = 0
			begin -- Round up
				if @Interval > @ElapsedMinutes
					Select @TimerMinutes = @Interval  -- Round up to the interval
				else
					if @ElapsedMinutes % @Interval > 0
						Select @TimerMinutes = @ElapsedMinutes + (@Interval - (@ElapsedMinutes % @Interval))
			end
		else 
			Begin -- Round down
				if @ElapsedMinutes % @Interval > 0
					Select @TimerMinutes = @ElapsedMinutes + (@ElapsedMinutes % @Interval * -1)
			End
	End	


If @TimerMinutes <= 0
	Select @TimerHours = 0, @TimerMinutes = 0
else	
	Select @TimerHours = @TimerMinutes / 60
	
If @TimerHours < 0
	Select @TimerHours = 0
	
Select @TimerMinutes = @TimerMinutes - (@TimerHours * 60)

Select @ActualHours = ((ISNULL(@TimerHours,0) * 60) + ISNULL(@TimerMinutes,0)) /60.0 -- this is rounded time

Select t.TimerKey,
	t.CompanyKey,	   
	t.StartTime,
	t.PauseTime,
	t.PauseSeconds,
	t.Paused,
	t.Comments,
	
	t.ProjectKey,  
	ISNULL(p.ProjectName, '') as ProjectName,
	ISNULL(p.ProjectNumber, '') as ProjectNumber,
	RTRIM(LTRIM(ISNULL(p.ProjectNumber,'') + '-' + ISNULL(p.ProjectName, ''))) as ProjectFullName,
	
	t.ServiceKey,
	ISNULL(s.ServiceCode, '') as ServiceCode,
	ISNULL(s.Description, '') as ServiceName,
	ISNULL(s.Description, '') as ServiceDescription,
	t.RateLevel,
	
	@TimerHours as TimerHours,		-- display on the mobile page
	@TimerMinutes as TimerMinutes,	-- display on the mobile page
	@ActualHours as ActualHours,
	ISNULL(PauseSeconds,0) / 60.0 / 60.0  as PauseHours,
	DATEADD(mi, ((ISNULL(@TimerHours,0) * 60) + ISNULL(@TimerMinutes,0) + (ISNULL(PauseSeconds,0) / 60.0)), StartTime)  as EndTime,
	@ElapsedSeconds * 1000 as ElapsedTime,			-- milliseconds for the timer widget
	
	bt.TaskKey as BudgetTaskKey, 
	bt.TaskID as BudgetTaskID, 
	bt.TaskName as BudgetTaskName,
	bt.TaskKey as SummaryTaskKey, 
	bt.TaskID as SummaryTaskID, 
	bt.TaskName as SummaryTaskName,
	
	dt.TaskKey as TaskKey, 
	dt.TaskID as TaskID, 
	dt.TaskName as TaskName,
	
	t.TaskUserKey,
	dt.TaskKey as DetailTaskKey, 
	dt.TaskID as DetailTaskID, 
	dt.TaskName as DetailTaskName,
	ISNULL(ps.TimeActive, 1) as TimeActive,
	(Case When ISNULL(dt.PercCompSeparate, 0) = 1 then tu.PercComp else dt.PercComp end) as UserPercComp,
	(Case When ISNULL(dt.PercCompSeparate, 0) = 1 then tu.ActStart else dt.ActStart end) as UserActStart,
	(Case When ISNULL(dt.PercCompSeparate, 0) = 1 then tu.ActComplete else dt.ActComplete end) as UserActComplete 
	
From tTimer t(nolock)
	Left Outer Join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	Left Outer Join tTask  tsk (nolock) on t.TaskKey = tsk.TaskKey
	Left Outer Join tTask bt (nolock) on tsk.BudgetTaskKey = bt.TaskKey
	Left outer Join tTask dt (nolock) on t.DetailTaskKey = dt.TaskKey
	Left Outer Join tTaskUser tu (nolock) on t.TaskUserKey = tu.TaskUserKey
	Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
	Left Outer Join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
Where TimerKey = @TimerKey
GO
