USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimerUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimerUpdate]
	 @TimerKey int
	,@CompanyKey int
    ,@UserKey int
    ,@ProjectKey int
    ,@TaskKey int
    ,@DetailTaskKey int
	,@TaskUserKey int = NULL
    ,@ServiceKey int
    ,@RateLevel int
    ,@Comments varchar(2000)
    ,@Paused tinyint  = 0 -- 1 to pause, 0 to unpause
    ,@StartTime datetime = null
AS
	/* SET NOCOUNT ON */

/*
|| When      Who Rel      What
|| 8/17/11   GWG 10.546   Brining back Project Details
|| 9/15/11   GMG 10.5.4.6 HF Changed logic for Timer Widget
|| 5/07/14   MAS 10.5.7.9 Make sure to save the TaskUserKey for New timers
|| 7/20/14   GWG 10.5.8.2 Modified to allow start time to be passed in (platinum)
*/

declare @CurKey as int

Select @CurKey = DetailTaskKey from tTimer (nolock) Where TimerKey = @TimerKey



if @DetailTaskKey is null
	Select @DetailTaskKey = TaskKey from tTask (nolock) Where TaskKey = @TaskKey and TaskType = 2

-- if the detail and summary are now different
if @DetailTaskKey <> @TaskKey
	-- if the detail task key is not under the taskkey
	if not exists(Select 1 from tTask (nolock) Where TaskKey = @DetailTaskKey and SummaryTaskKey = @TaskKey)
		if exists(Select 1 from tTask (nolock) Where TaskKey = @TaskKey and TaskType = 2)
			Select @DetailTaskKey = @TaskKey
		else
			Select @DetailTaskKey = NULL

if ISNULL(@CurKey, 0) <> ISNULL(@DetailTaskKey, 0) AND @TimerKey IS NULL
BEGIN
	-- the the detail task key has been switched, blank out the task user key
	Select @TaskUserKey = NULL
END

IF ISNULL(@TimerKey, 0) = 0
BEGIN
	Select @StartTime = ISNULL(@StartTime, GETUTCDATE())
	
	INSERT INTO tTimer
           (CompanyKey
           ,UserKey
           ,ProjectKey
           ,TaskKey
           ,DetailTaskKey
		   ,TaskUserKey
           ,ServiceKey
           ,RateLevel
           ,StartTime
           ,PauseTime
           ,PauseSeconds
           ,Paused
           ,Comments)
     VALUES
           (@CompanyKey
           ,@UserKey
           ,@ProjectKey
           ,@TaskKey
           ,@DetailTaskKey
		   ,@TaskUserKey
           ,@ServiceKey
           ,@RateLevel
           ,@StartTime
           ,NULL
           ,0
           ,0			-- always start timer running
           ,RTRIM(LTRIM(@Comments)))

	Select @TimerKey = @@Identity

END
ELSE
BEGIN

	UPDATE tTimer
	   SET 
			ProjectKey = @ProjectKey,
			TaskKey = @TaskKey,
			DetailTaskKey = @DetailTaskKey,
			ServiceKey = @ServiceKey,
			TaskUserKey = @TaskUserKey,
			Comments = RTRIM(LTRIM(@Comments))
	 WHERE 
		TimerKey = @TimerKey
	
	-- update the paused status
	EXEC sptTimerPause 	@TimerKey, @Paused

END


return @TimerKey
GO
