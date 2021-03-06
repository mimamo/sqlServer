USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetUser]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGetUser]
	@TaskKey int,
	@UserKey int

AS --Encrypt

declare @ActualHours decimal(24,4), @ServiceKey int, @RateLevel int, @IsAssigned tinyint

Select @ServiceKey = DefaultServiceKey, @RateLevel = RateLevel from tUser (nolock) Where UserKey = @UserKey
Select @ActualHours = Sum(ActualHours) from tTime with (index=IX_tTime_1, nolock) Where tTime.UserKey = @UserKey
	and (tTime.TaskKey = @TaskKey or tTime.DetailTaskKey = @TaskKey)
	
select @IsAssigned = 0
IF exists(select 1 from tTaskUser (nolock) Where UserKey = @UserKey and TaskKey = @TaskKey)
BEGIN
	select @IsAssigned = 1
END
ELSE
BEGIN
	if exists(Select 1 from tTask (nolock) Where TaskKey = @TaskKey and AllowAnyone = 1)
		Select @IsAssigned = 1
END


	SELECT 
		t.*
		,t.TaskKey as DetailTaskKey
		,t.TaskID as DetailTaskID
		,t.TaskName as DetailTaskName
		,t.Comments as StatusComments
		, p.ProjectKey, p.ProjectNumber, p.ProjectName
		,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
		,ps.TimeActive
		,bt.TaskID as BudgetTaskID
		,bt.TaskName as BudgetTaskName
		,bt.TrackBudget as BudgetTrackBudget
		,tu.Hours as AllocatedHours
		,tu.Hours as UserHours -- backwards compatibility with CMP85
		,tu.ActStart as UserActStart
		,tu.ActComplete as UserActComplete
		,tu.PercComp as UserPercComp
		,@ActualHours as TotalActualHours
		,ISNULL(tu.ServiceKey, @ServiceKey) as DefaultServiceKey
		,ISNULL(@RateLevel, 1) as RateLevel
		,pc.FirstName + ' ' + pc.LastName as PrimaryContact
		,pc.Phone1
		,pc.Cell
		,pc.Email
		,@IsAssigned as AssignedToTask
	FROM 
		tTask t (nolock)
		inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
		left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
		left outer join tTask bt (nolock) on t.BudgetTaskKey = bt.TaskKey
		left outer join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
		LEFT OUTER JOIN tUser pc (nolock) on p.BillingContact = pc.UserKey
	WHERE
		t.TaskKey = @TaskKey
GO
