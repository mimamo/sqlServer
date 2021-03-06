USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserRollup]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserRollup]

	@TaskKey int
	,@TrafficOnly int = 0
		
AS --Encrypt

	-- Rollup from tTaskUser to tTask
	-- Case when tTask.PercCompSeparate = 1

  /*
  || When     Who Rel   What
  || 10/10/06 GHL 8.4   Corrected @ActComplete, was intitially:
  ||                    select @ActComplete = max(ActComplete) from tTaskUser (nolock) where TaskKey = @TaskKey
  ||                    Problem is as soon as a user had completed, the task was complete
  ||                    Also reviewed calculation of PercComp
  || 10/19/06 GHL 8.4   Added TrafficOnly to support Flash, Actuals are rolled up in the Flash module 
  || 01/04/07 GHL 8.4   Added protection against NULL PercComp
  || 01/19/07 GHL 8.4   Added Time Completed logic  
  */
  
declare @TotalHours decimal(24, 4)
declare @TotalHoursComp decimal(24, 4)
declare @PercComp int
declare @ActStart as smalldatetime
declare @ActComplete as smalldatetime
declare @UserCount int
declare @ActCompleteCount int

	SELECT @UserCount = COUNT(*) FROM tTaskUser (NOLOCK) WHERE TaskKey = @TaskKey
	-- If nothing to rollup, exit
	IF @UserCount = 0
		RETURN 1

	-- rollup Reviewed By to task level 
	DECLARE @ReviewedByTraffic tinyint
			,@ReviewedByKey int
			,@ReviewedByDate smalldatetime
			,@CompletedByKey int
			,@CompletedByDate datetime
							
	IF (SELECT COUNT(*) FROM tTaskUser (NOLOCK) 
		WHERE TaskKey = @TaskKey
		AND   ISNULL(ReviewedByTraffic, 0) = 1) = @UserCount
		BEGIN
			-- All have been reviewed
			SELECT @ReviewedByTraffic = 1
			
			SELECT @ReviewedByDate = MAX(ReviewedByDate)
			FROM   tTaskUser (NOLOCK)
			WHERE  TaskKey = @TaskKey 		
		
			SELECT @ReviewedByKey = ReviewedByKey -- Last reviewer wins
			FROM   tTaskUser (NOLOCK)
			WHERE  TaskKey = @TaskKey 		
			AND    ReviewedByDate = @ReviewedByDate
			
		END					
		ELSE
			SELECT @ReviewedByTraffic = 0 -- Date and Key will be null

	IF (SELECT COUNT(*) FROM tTaskUser (NOLOCK) 
		WHERE TaskKey = @TaskKey
		AND   CompletedByKey IS NOT NULL) = @UserCount
		BEGIN
			SELECT @CompletedByDate = MAX(CompletedByDate)
			FROM   tTaskUser (NOLOCK)
			WHERE  TaskKey = @TaskKey 		
		
			SELECT @CompletedByKey = CompletedByKey -- Last completed
			FROM   tTaskUser (NOLOCK)
			WHERE  TaskKey = @TaskKey 		
			AND    CompletedByDate = @CompletedByDate
		
		END
		
	UPDATE tTask
	SET		ReviewedByTraffic = @ReviewedByTraffic
			,ReviewedByDate = @ReviewedByDate
			,ReviewedByKey = @ReviewedByKey
			,CompletedByDate = @CompletedByDate
			,CompletedByKey = @CompletedByKey
	WHERE	TaskKey = @TaskKey

	IF @TrafficOnly = 1
		RETURN 1

	select @ActStart = min(ActStart)
	from tTaskUser (nolock)
	where TaskKey = @TaskKey
	and ActStart is not null
		
	select @TotalHours = (select sum(case when Hours is null then 1
										  when Hours = 0 then 1
										  else Hours
									 end ) 
								from tTaskUser (nolock)
								where TaskKey = @TaskKey)
	if @TotalHours = 0 or @TotalHours is null 
		select @TotalHours = 1

	select @TotalHoursComp = isnull((select sum((isnull(PercComp,0))*
									 case when Hours is null then 1
										  when Hours = 0 then 1
										  else Hours
									 end)
							from tTaskUser (nolock)
							where TaskKey = @TaskKey),0)
	
	select @PercComp = @TotalHoursComp/@TotalHours
	
	
	if @PercComp < 0 
		select @PercComp = 0
	if @PercComp > 100
		select @PercComp = 100

	select @ActCompleteCount = count(*)
	from   tTaskUser (nolock)
	where  TaskKey = @TaskKey
	and    ActComplete is not null

	-- if PercComp or all have finished
	if (@PercComp = 100 or @ActCompleteCount = @UserCount) 
		select @ActComplete = max(ActComplete)
		from tTaskUser (nolock)
		where  TaskKey = @TaskKey

	-- cannot leave PercComp <> 100 if we have ActComplete
	if @ActComplete is not null
		select @PercComp = 100
			 		
	-- rollup Actuals to task level	
	update tTask
	set	PercComp = ISNULL(@PercComp, 0)
		,ActStart = @ActStart
		,ActComplete = @ActComplete
	where TaskKey = @TaskKey
	 
			
	return 1
GO
