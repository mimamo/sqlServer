USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetRateList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGetRateList]
	(
		 @ProjectKey int
		,@AllTasks tinyint = 1
		,@UserKey int = null
		,@RestrictCompletedTaskMode int = -1 -- 0:Expenses, 1:Time, -1:For CMP
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 4/11/08   CRG 1.0.0.0  Made AllTasks and UserKey optional so that it doesn't break the CMP85 ItemRateManager
|| 4/11/08   RTC 10.0.0.4 Issue #29753 - Added Tasks to result set that have 'Allow Anyone' set, which allows anyone to enter time against them
|| 4/17/08   RTC 10.0.0.5 Issue #29753 - Altered prior fix to include tasks that were missing 
|| 9/5/08    CRG 10.1.0.0 (33082) Fixed logic if user is assigned to detail task that is not the TrackBudget task.
|| 2/6/09    RTC 10.1.0.7 (45885) Trim TaskID for Item Rate Manager Validations
|| 07/28/09  GWG 10.5.005 (58313) Rolled back the trim of tasks
|| 11/6/09   CRG 10.5.1.3 Added check of new security rights for completed tasks
|| 06/23/14  RLB 10.5.8.1 Add PercComp for New App IRM
|| 11/05/14  RLB 10.5.8.6 Added changes for Abelson Taylor Enhancement AnyoneChargeTime
*/

DECLARE	@SecurityGroupKey int,
		@Administrator tinyint,
		@AllowCompletedTasks tinyint,
		@AnyoneChargeTime tinyint

SELECT	@AllowCompletedTasks = 1

SELECT @AnyoneChargeTime = AnyoneChargeTime FROM tProject (NOLOCK) WHERE ProjectKey = @ProjectKey

IF @RestrictCompletedTaskMode >= 0
BEGIN

	SELECT	@SecurityGroupKey = ISNULL(SecurityGroupKey, 0),
			@Administrator = ISNULL(Administrator, 0)
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey

	IF @Administrator = 0
	BEGIN
		SELECT	@AllowCompletedTasks = 0

		IF @RestrictCompletedTaskMode = 1 --Time
		BEGIN
			IF EXISTS(
					SELECT	1
					FROM	tRight r (nolock)
					INNER JOIN tRightAssigned ra (nolock) ON r.RightKey = ra.RightKey
					WHERE	ra.EntityType = 'Security Group'
					AND		ra.EntityKey = @SecurityGroupKey
					AND		r.RightID = 'prjTimeCompletedTask')
				SELECT @AllowCompletedTasks = 1

			IF @AllowCompletedTasks = 0 AND @AnyoneChargeTime = 1
				SELECT @AllowCompletedTasks = 1

		END
		ELSE --Expense
		BEGIN
			IF EXISTS(
					SELECT	1
					FROM	tRight r (nolock)
					INNER JOIN tRightAssigned ra (nolock) ON r.RightKey = ra.RightKey
					WHERE	ra.EntityType = 'Security Group'
					AND		ra.EntityKey = @SecurityGroupKey
					AND		r.RightID = 'prjExpenseCompletedTask')
				SELECT @AllowCompletedTasks = 1
		END
	END		
END

if @AllTasks = 1
	Select 
		TaskKey,
		TaskID,   -- rolled back ltrim(rtrim(TaskID)) as TaskID,
		TrackBudget,
		ScheduleTask,
		TaskName,
		HourlyRate,
		Markup,
		IOCommission,
		BCCommission,
		PercComp

	from tTask (nolock) 
	Where ProjectKey = @ProjectKey 
	and TrackBudget = 1
	and (@AllowCompletedTasks = 1 OR PercComp < 100)
	Order By ProjectOrder
else
	select 
		TaskKey,
		TaskID,   -- rolled back ltrim(rtrim(TaskID)) as TaskID,
		TrackBudget,
		ScheduleTask,
		TaskName,
		HourlyRate,
		Markup,
		IOCommission,
		BCCommission,
		PercComp
	from tTask (nolock) 
	where ProjectKey = @ProjectKey 
	and TrackBudget = 1
	and (@AllowCompletedTasks = 1 OR PercComp < 100)
	and ((isnull(AllowAnyone, 0) = 1)
		  or (TaskKey in 
			(select distinct t.TaskKey
			from tTask t (nolock) 
			inner join tTask td (nolock) on t.TaskKey = td.BudgetTaskKey
			inner join tTaskUser tu (nolock) on td.TaskKey = tu.TaskKey
			where t.ProjectKey = @ProjectKey 
			and t.TrackBudget = 1
			and tu.UserKey = @UserKey
			)))
	order by ProjectOrder
GO
