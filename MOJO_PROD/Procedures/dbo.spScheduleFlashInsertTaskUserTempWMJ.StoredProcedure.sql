USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spScheduleFlashInsertTaskUserTempWMJ]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spScheduleFlashInsertTaskUserTempWMJ]
	(
	@UserKey int,
	@TaskKey int,
	@Hours decimal(24, 4),
	@PercComp int,
	@ActStart smalldatetime,
	@ActComplete smalldatetime,
	@ReviewedByTraffic smallint, 
	@LoggedUserKey int,
	@TaskUserKey int,
	@ServiceKey int,
	@Subject varchar(500),
	@Description text,
	@Comments varchar(4000),
	@DeliverableKey int = NULL
	)

AS -- Encrypt

  /*
  || When     Who Rel   What
  || 10/19/06 GHL 8.4   Added @ReviewedByKey logic 
  || 01/22/07 GHL 8.4   Added @CompletedByKey logic 
  || 05/09/08 RTC 8.5.1 Added TaskUserKey and Action Logic for handling inderts and updates
  || 6/8/09   CRG 10.5.0.0 Added ServiceKey, Subject, Description, Comments
  || 5/19/10  CRG 10.5.3.0 Modified to use TaskUserKey rather than joining on TaskKey, UserKey because UserKey can be NULL now.
  || 7/11/10  GWG 10.5.4.6 Do not insert the row if the user key and service key are blank.
  || 04/16/15 GWG 10.5.9.1 Added DeliverableKey
  */
  
	SET NOCOUNT ON

	if @UserKey is null and @ServiceKey is null
		return 1 
	
	DECLARE @Action INT -- 1 Insert, 2 Update
	IF @TaskUserKey < 0
		SELECT @Action = 1
	ELSE
		SELECT @Action = 2
			
	-- Last validation, this is entered on a grid in Flash, may not be validated correctly
	IF @Hours < 0
		SELECT @Hours = 0
		
	IF @ActStart IS NOT NULL AND @ActComplete IS NOT NULL 
	BEGIN
		IF @ActStart > @ActComplete
			SELECT @ActStart = @ActComplete
	END
	
	
	-- clone @ReviewedByKey logic from sptTaskUserInsert
	
	DECLARE @PercCompSeparate int
			,@ReviewedByDate smalldatetime
			,@ReviewedByKey int
			,@OldReviewedByTraffic int  
			,@OldReviewedByDate smalldatetime
			,@OldReviewedByKey int
			,@RecordExists int 
			,@OldPercComp int 
			,@OldCompletedByDate datetime
			,@OldCompletedByKey int
			,@CompletedByDate datetime
			,@CompletedByKey int
					
	SELECT @PercCompSeparate = ISNULL(PercCompSeparate, 0)
	FROM   #tTask (NOLOCK)			-- Do not check tTask
	WHERE  TaskKey = @TaskKey		-- Task should be in temp table, flag could have been modified
	
	-- in case it is missing in temp table
	SELECT @PercCompSeparate = ISNULL(@PercCompSeparate, 0)
	
	SELECT	@OldReviewedByTraffic = ISNULL(ReviewedByTraffic, 0)
			,@OldReviewedByDate = ReviewedByDate 
			,@OldReviewedByKey = ReviewedByKey
	        ,@OldPercComp = ISNULL(PercComp, 0)
	        ,@OldCompletedByDate = CompletedByDate
	        ,@OldCompletedByKey = CompletedByKey			
	FROM	tTaskUser (NOLOCK)
	WHERE	TaskUserKey = @TaskUserKey
	
	IF @@ROWCOUNT > 0
		SELECT @RecordExists = 1
	ELSE
		SELECT @RecordExists = 0
	
	-- no need to do anything if @PercCompSeparate = 0 
	-- Will be rolled down from tTask
	
	IF @PercCompSeparate = 1
	BEGIN
		IF @RecordExists = 1
		BEGIN
			-- Check old and new PercComp
			If @OldPercComp <> @PercComp 
			BEGIN
				IF @PercComp >= 100
					SELECT @CompletedByDate = GETUTCDATE()
		    			   ,@CompletedByKey = @LoggedUserKey
				ELSE
					-- The task is not complete
					SELECT @CompletedByDate = NULL
					      ,@CompletedByKey = NULL
			END 
			ELSE
				-- Perc Comp has not changed, keep old settings
				SELECT @CompletedByDate = @OldCompletedByDate
					   ,@CompletedByKey = @OldCompletedByKey


			IF @ReviewedByTraffic <> @OldReviewedByTraffic
			BEGIN
				-- Review By traffic flag has changed
				
				if @ReviewedByTraffic = 1
					-- User set task as reviewed, so set review date
					Select @ReviewedByDate = GETUTCDATE()
						  ,@ReviewedByKey = @LoggedUserKey
				else
					-- User reset task as reviewed
					Select @ReviewedByDate = NULL
						  ,@ReviewedByKey = NULL 
			END
			ELSE
			BEGIN
				-- Review By traffic flag has NOT changed
				Select @ReviewedByDate = @OldReviewedByDate
					  ,@ReviewedByKey = @OldReviewedByKey
			END
			
			
			
		END
		ELSE
		BEGIN
			-- Record does not exist
			IF @PercComp >= 100
				SELECT @CompletedByDate = GETUTCDATE()
				      ,@CompletedByKey = @LoggedUserKey

			-- Record was not found before
			if @ReviewedByTraffic = 1
				-- User set task as reviewed, so set review date
				Select @ReviewedByDate = GETUTCDATE()
				      ,@ReviewedByKey = @LoggedUserKey
			else
				-- User reset task as reviewed
				Select @ReviewedByDate = NULL
						,@ReviewedByKey = NULL
		
		END
	END
	
	
	INSERT #tTaskUser
		(
		UserKey,
		TaskKey,
		Hours,
		PercComp,
		ActStart,
		ActComplete,
		ReviewedByTraffic,
		ReviewedByDate,
		ReviewedByKey,
		CompletedByDate,
		CompletedByKey,
		Action,
		TaskUserKey,
		ServiceKey,
		Subject,
		Description,
		Comments,
		DeliverableKey
		)

	VALUES
		(
		@UserKey,
		@TaskKey,
		@Hours,
		@PercComp,
		@ActStart,
		@ActComplete,
		@ReviewedByTraffic,
		@ReviewedByDate,
		@ReviewedByKey,
		@CompletedByDate,
		@CompletedByKey,
		@Action,
		@TaskUserKey,
		@ServiceKey,
		@Subject,
		@Description,
		@Comments,
		@DeliverableKey
		)

	RETURN 1
GO
