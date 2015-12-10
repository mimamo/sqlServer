USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimerGetList]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimerGetList]
    @UserKey int
AS
	/* SET NOCOUNT ON */
/*
|| When      Who Rel      What
|| 9/15/11   GMG 10.5.4.6 HF Changed logic for Timer Widget
|| 11/10/14  RLB 10.5.8.6 Added UserKey for Platinum
|| 12/11/14  CRG 10.5.8.7 Added ProjectFullName (even though it's essentially the same as FormattedProjectName)
||                        and TaskFullName to match the columns from other stored procedures that are loading the Time Entry grid in Platinum.
*/


Select t.TimerKey,
	t.UserKey,
	t.CompanyKey,
	t.StartTime,
	t.PauseTime,
	t.PauseSeconds,
	t.Paused,
	t.Comments,

	t.ProjectKey, 
	LTRIM(RTRIM(ISNULL(p.ProjectNumber,'') + '-' + ISNULL(p.ProjectName,''))) as FormattedProjectName,
	ISNULL(p.ProjectNumber,'') As ProjectNumber,
	ISNULL(p.ProjectName,'') As ProjectName,

	t.ServiceKey,
	ISNULL(svc.ServiceCode, '') as ServiceCode,
	ISNULL(svc.Description, '') as ServiceName,
	t.RateLevel,   

	case ISNULL(t.Paused, 0)
		when 0 then 'Running'
		else 'Paused'
	end as Status,

	case ISNULL(t.Paused, 0)
		when 0 then (DATEDIFF(ss, t.StartTime, GETUTCDATE())- ISNULL(t.PauseSeconds,0)) * 1000.0
		else (DATEDIFF(ss, t.StartTime, t.PauseTime)- ISNULL(t.PauseSeconds,0)) * 1000.0
	end as ElapsedTime,			-- milliseconds for the timer widget

	bt.TaskKey as BudgetTaskKey, 
	bt.TaskID as BudgetTaskID, 
	bt.TaskName as BudgetTaskName,
	bt.TaskKey as SummaryTaskKey, 
	bt.TaskID as SummaryTaskID, 
	bt.TaskName as SummaryTaskName,

	dt.TaskKey as TaskKey, 
	dt.TaskID as TaskID, 
	dt.TaskName as TaskName,	
	dt.TaskKey as DetailTaskKey, 
	dt.TaskID as DetailTaskID, 
	dt.TaskName as DetailTaskName,
	t.TaskUserKey,
	ISNULL(ps.TimeActive, 1) as TimeActive,
	(Case When ISNULL(dt.PercCompSeparate, 0) = 1 then tu.PercComp else dt.PercComp end) as UserPercComp,
	(Case When ISNULL(dt.PercCompSeparate, 0) = 1 then tu.ActStart else dt.ActStart end) as UserActStart,
	(Case When ISNULL(dt.PercCompSeparate, 0) = 1 then tu.ActComplete else dt.ActComplete end) as UserActComplete,
	ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '') AS ProjectFullName,
	ISNULL(tsk.TaskID, '') + '-' + ISNULL(tsk.TaskName, '') AS TaskFullName
From tTimer t (nolock)
Left Outer Join tProject p (nolock) on t.ProjectKey = p.ProjectKey
Left Outer Join tTask tsk (nolock) on t.TaskKey = tsk.TaskKey
Left outer join tTask bt (nolock) on tsk.BudgetTaskKey = bt.TaskKey
Left outer join tTask dt (nolock) on t.DetailTaskKey = dt.TaskKey
	Left Outer Join tTaskUser tu (nolock) on t.TaskUserKey = tu.TaskUserKey
Left Outer Join tService svc (nolock) on t.ServiceKey = svc.ServiceKey
left outer join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
Where t.UserKey = @UserKey
GO
