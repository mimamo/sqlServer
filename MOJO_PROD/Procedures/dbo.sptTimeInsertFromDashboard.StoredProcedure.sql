USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeInsertFromDashboard]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeInsertFromDashboard]
	@UserKey int,
	@TaskKey int,
	@TimeSheetKey int,
	@WorkDate smalldatetime,
	@ActualHours decimal(24,4),
	@ServiceKey int,
	@RateLevel int,
	@Comments varchar(2000) = null
AS --Encrypt

/*
|| When     Who Rel     What
|| 11/06/06 RTC 8.4     Added TimeKey parameter needed to return new GUID generated.
|| 12/20/06 RTC 8.4     Added validation to prevent time entries outside the timesheet period.
|| 02/15/07 GHL 8.4     Added project rollup
|| 05/10/07 CRG 8.4.3   (8659) Modified to update the ActStart of the Task and TaskUser if it's NULL.
|| 03/21/08 CRG 1.0.0.0 Added optional Comments parameter for use by sptTimeSaveTimeTracker
|| 10/7/10  CRG 10.5.3.6 Added Verified parameter to sptTimeInsert call.
*/

	DECLARE	@ProjectKey int,
			@BudgetTaskKey int,
			@TimeKey uniqueidentifier,
			@StartDate smalldatetime,
			@EndDate smalldatetime,
			@TaskActStart smalldatetime,
			@TaskUserActStart smalldatetime,
			@RetVal int
	
	select  @StartDate = StartDate
	       ,@EndDate = EndDate
	from	tTimeSheet (nolock)
	where	TimeSheetKey = @TimeSheetKey
	
	if @WorkDate < @StartDate or @WorkDate > @EndDate
		return -10
		
	SELECT	@ProjectKey = ProjectKey,
			@BudgetTaskKey = BudgetTaskKey,
			@TaskActStart = ActStart
	FROM	tTask (NOLOCK)
	WHERE	TaskKey = @TaskKey
	
	SELECT	@TaskUserActStart = ActStart
	FROM	tTaskUser (NOLOCK)
	WHERE	TaskKey = @TaskKey
	AND		UserKey = @UserKey
	
	SELECT @RetVal = 0
	EXEC @RetVal = sptTimeInsert
		@TimeSheetKey,
		@UserKey,
		@ProjectKey,
		@BudgetTaskKey,
		@ServiceKey,
		@WorkDate,
		NULL, --@StartTime
		NULL, --@EndTime
		@ActualHours,
		NULL, --@PauseHours
		@Comments, --@Comments
		@RateLevel,
		@TaskKey,
		1, --@Verified
		@TimeKey output
	
	IF @RetVal < 0
		RETURN @RetVal

	IF @TaskActStart IS NULL
		UPDATE	tTask
		SET		ActStart = @WorkDate
		WHERE	TaskKey = @TaskKey
		
	IF @TaskUserActStart IS NULL
		UPDATE	tTaskUser
		SET		ActStart = @WorkDate
		WHERE	TaskKey = @TaskKey
		AND		UserKey = @UserKey	
	
	-- Rollup to project Labor, base + approved rollup 
	EXEC sptProjectRollupUpdate @ProjectKey, 1, 1, 1, 0, 0 
				
	RETURN 1
GO
