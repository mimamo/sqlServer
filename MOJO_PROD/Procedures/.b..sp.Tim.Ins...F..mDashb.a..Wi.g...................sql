USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeInsertFromDashboardWidget]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeInsertFromDashboardWidget]
	@UserKey int,
	@ProjectKey int,
	@BudgetTaskKey int,
	@DetailTaskKey int,
	@TimeSheetKey int,
	@WorkDate smalldatetime,
	@ActualHours decimal(24,4),
	@PauseHours decimal(24,4),
	@ServiceKey int,
	@RateLevel int,
	@Comments varchar(2000) = null,
	@StartTime smalldatetime,
	@EndTime smalldatetime,
	@Verified tinyint,
	@TimeKey uniqueidentifier output
	
AS --Encrypt

/*
|| When     Who Rel     What
|| 4/07/08  CRG 1.0.0.0 Created because logic is now slightly different than sptTimeInsertFromDashboard because it's used by the Time Entry Widget.
||                      I did not want to affect users who are still using CMP85.
|| 4/29/08  CRG 1.0.0.0 Added PauseHours
|| 5/20/08  GWG 1.0.0.0 Added Start Time and End Time
|| 10/07/09 GHL 10.512  (65041) Bubble up the errors from tTimeInsert to the UI
|| 01/12/10 GHL 10.516  (72043) Added patch to fix StartTime on wrong date
|| 8/11/10  CRG 10.5.3.3 Now always setting verified to 1 on the new time record because this is only called from sptTimeSaveTimeTracker which is always updated by the user themselves.
|| 8/13/10  CRG 10.5.3.3 Added @TimeKey as an output parm
|| 9/24/10  CRG 10.5.3.5 Added @Verified parameter because we are now also adding unverified time entries from sptTimeSaveTimeTracker.
|| 10/7/10  CRG 10.5.3.6 Moved @Verified parameter to sptTimeInsert call.
|| 09/23/11 GHL 10.5.4.8 Only perform project rollup if ActualHours <> 0
*/

	DECLARE @StartDate smalldatetime,
			@EndDate smalldatetime,
			@TaskActStart smalldatetime,
			@TaskUserActStart smalldatetime,
			@RetVal int
	
-- patch to make sure that WorkDate and Start/End Times are on the same day
-- If not reliable, sorts on StartTime would be wrong
declare @NumDaysDiff int
if @StartTime is not null
begin
	select @NumDaysDiff = datediff(d, @StartTime, @WorkDate)
	select @StartTime = dateadd(d, @NumDaysDiff, @StartTime )
end
if @EndTime is not null
begin
	select @NumDaysDiff = datediff(d, @EndTime, @WorkDate)
	select @EndTime = dateadd(d, @NumDaysDiff, @EndTime )
end

	select  @StartDate = StartDate
	       ,@EndDate = EndDate
	from	tTimeSheet (nolock)
	where	TimeSheetKey = @TimeSheetKey
	
	if @WorkDate < @StartDate or @WorkDate > @EndDate
		return -10
	
	IF @DetailTaskKey IS NOT NULL
		SELECT	@ProjectKey = ProjectKey,
				@BudgetTaskKey = ISNULL(@BudgetTaskKey, BudgetTaskKey), --Only reset the BudgetTaskKey if it's currently NULL
				@TaskActStart = ActStart
		FROM	tTask (NOLOCK)
		WHERE	TaskKey = @DetailTaskKey

	SELECT	@TaskUserActStart = ActStart
	FROM	tTaskUser (NOLOCK)
	WHERE	TaskKey = @DetailTaskKey
	AND		UserKey = @UserKey
	
	SELECT @RetVal = 0
	EXEC @RetVal = sptTimeInsert
		@TimeSheetKey,
		@UserKey,
		@ProjectKey,
		@BudgetTaskKey,
		@ServiceKey,
		@WorkDate,
		@StartTime, --@StartTime
		@EndTime, --@EndTime
		@ActualHours,
		@PauseHours,
		@Comments, --@Comments
		@RateLevel,
		@DetailTaskKey,
		@Verified,
		@TimeKey output

	IF @RetVal < 0
		RETURN @RetVal
		
	IF @TaskActStart IS NULL
		UPDATE	tTask
		SET		ActStart = @WorkDate
		WHERE	TaskKey = @DetailTaskKey
		
	IF @TaskUserActStart IS NULL
		UPDATE	tTaskUser
		SET		ActStart = @WorkDate
		WHERE	TaskKey = @DetailTaskKey
		AND		UserKey = @UserKey	
	
	-- Rollup to project Labor, base + approved rollup 
	If @ActualHours <> 0
		EXEC sptProjectRollupUpdate @ProjectKey, 1, 1, 1, 0, 0 
	
	
	RETURN 1
GO
