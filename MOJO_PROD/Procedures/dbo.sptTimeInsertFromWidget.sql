USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeInsertFromWidget]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeInsertFromWidget]
	@TaskUserKey int,
	@UserKey int,
	@TaskKey int,
	@TimeSheetKey int,
	@WorkDate smalldatetime,
	@ActualHours decimal(24,4),
	@ServiceKey int,
	@RateLevel int,
	@PercComp int,
	@StartTime smalldatetime,
	@EndTime smalldatetime,
	@BillingComments varchar(2000),
	@Comments varchar(4000),
	@TaskUpdated tinyint output, --Set to 1 if the task has been updated
	@ActStart smalldatetime output,
	@ActComplete smalldatetime output
AS --Encrypt

/*
|| When      Who Rel		  What
|| 3/20/08   CRG 1.0.0.0	Created to insert time from the My Tasks widget.
||							The logic is gernerally the same as sptTimeInsertFromDashboard, except this SP updates the percent complete
||							of the task.  It uses sptTaskUpdateActual, which already has all of the logic built in for PercCompSeparate.
|| 5/13/08   CRG 10.0.0.0	Moved ActStart and ActComplete to be output parameters because the Schedule needs this to be sent to it in an event.
|| 9/22/08   GWG 10.009		Added a fix for updating actual start when a task is marked as completed.
|| 10/07/09	 GHL 10.512		(65041) Bubble up the errors from tTimeInsert to the UI
|| 5/14/10   CRG 10.5.2.2 (80409) Now TimeSheetKey may be NULL if only the PercComp was updated and no Hours were entered. 
||                          So, now only validating the time sheet date range if a TimeSheetKey is passed in.
|| 05/15/10  MAS 10.5.2.3	Added Billing Comments, Start and End time
|| 07/19/10  GHL 10.5.3.2 Added TaskUserKey when calling sptTaskUpdateActual to handle cases of user assigned several times to the task 
|| 10/7/10   CRG 10.5.3.6 Added Verified parameter to sptTimeInsert call.
|| 09/23/11  GHL 10.5.4.8 Only perform project rollup if ActualHours <> 0
|| 05/22/13  MFT 10.5.6.8 (174957) Added @Comments to input parameters to be updated from widget
|| 09/03/13  RLB 10.5.7.2 (188603) Add a 0 actual hour time entry if there is a billing comment
*/

	DECLARE	@StartDate smalldatetime,
			@EndDate smalldatetime,
			@OldComments varchar(4000),
			@PercCompSeparate tinyint,
			@TimeKey uniqueidentifier,
			@ProjectKey int,
			@BudgetTaskKey int,
			@OldPercComp int,
			@RetVal int

	SELECT	@TaskUpdated = 0

	IF @TimeSheetKey IS NOT NULL
	BEGIN

		SELECT	@StartDate = StartDate,
				@EndDate = EndDate
		FROM	tTimeSheet (nolock)
		WHERE	TimeSheetKey = @TimeSheetKey

		--Validate that the WorkDate is within the TimeSheet date range
		IF @WorkDate < @StartDate OR @WorkDate > @EndDate
			RETURN -10
	END
		
	--Get task information
	SELECT	@ProjectKey = ProjectKey,
			@PercCompSeparate = PercCompSeparate,
			@ActStart = ActStart,
			@OldComments = Comments,
			@BudgetTaskKey = BudgetTaskKey,
			@OldPercComp = PercComp
	FROM	tTask (nolock)
	WHERE	TaskKey = @TaskKey

	--If hours or perc complete	is not 0, then check for ActStart = null
	IF @ActualHours <> 0 OR @PercComp <> 0
	BEGIN
		--If not tracking Percent Complete separate, see if tTask.ActStart is null.
		--Otherwise, see if tTaskUser.ActStart is null.  Either way, if null, set it to the WorkDate.
		IF @PercCompSeparate = 0
			BEGIN
			IF @ActStart IS NULL
				BEGIN
					SELECT @ActStart = @WorkDate
					SELECT @TaskUpdated = 1
				END
			END
		ELSE
			BEGIN
				SELECT	@ActStart = ActStart,
						@OldPercComp = PercComp
				FROM	tTaskUser (nolock)
				WHERE	TaskUserKey = @TaskUserKey
				
				IF @ActStart IS NULL
				BEGIN
					SELECT @ActStart = @WorkDate
					SELECT @TaskUpdated = 1
				END
			END
	END
	
	IF @PercComp = 100
	BEGIN
		SELECT @ActComplete = @WorkDate
		SELECT @TaskUpdated = 1
	END
	
	IF @PercComp <> @OldPercComp OR @Comments <> @OldComments
		SELECT @TaskUpdated = 1
	
	--Insert the Time record
	SELECT @RetVal = 0
	IF @ActualHours <> 0 Or isnull(@BillingComments, '') <> ''
		EXEC @RetVal = sptTimeInsert
			@TimeSheetKey,
			@UserKey,
			@ProjectKey,
			@BudgetTaskKey,
			@ServiceKey,
			@WorkDate,
			@StartTime,
			@EndTime, 
			@ActualHours,
			NULL, --@PauseHours
			@BillingComments,
			@RateLevel,
			@TaskKey,
			1, --@Verified
			@TimeKey output

	-- now report error
	IF @RetVal < 0
		RETURN @RetVal
			
	--Update the Actual values on the Task
	EXEC sptTaskUpdateActual
		@TaskKey,
		@UserKey,
		@ActStart,
		@ActComplete,
		@PercComp,
		@Comments,
		@TaskUserKey	
	
	-- Rollup to project Labor, base + approved rollup 
	IF @ActualHours <> 0
		EXEC sptProjectRollupUpdate @ProjectKey, 1, 1, 1, 0, 0 
	
	return 1
GO
