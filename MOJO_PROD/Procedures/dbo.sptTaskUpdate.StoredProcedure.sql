USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUpdate]
	@TaskKey int,
	@ProjectKey int,
	@TaskID varchar(30),
	@TaskName varchar(300),
	@Description varchar(6000),
	@HourlyRate	money,
	@Markup decimal(24,4),
	@IOCommission decimal(24,4),
	@BCCommission decimal(24,4),
	@ShowDescOnEst tinyint,
	@ServiceKey int,
	@Taxable tinyint,
	@Taxable2 tinyint,
	@WorkTypeKey int,
	@BaseStart smalldatetime,
	@BaseComplete smalldatetime,
	@PlanDuration int,
	@ActStart smalldatetime,
	@ActComplete smalldatetime,
	@PercComp int,
	@TaskConstraint smallint,
	@Comments varchar(4000),
	@HideFromClient tinyint,
	@AllowAnyone tinyint,
	@MasterTaskKey int,
	@ConstraintDate smalldatetime,
	@WorkAnyDay int,
	@PercCompSeparate int,
	@TaskAssignmentTypeKey int,
	@Priority smallint,
	@ShowOnCalendar tinyint,
	@EventStart smalldatetime,
	@EventEnd smalldatetime,
	@TimeZoneIndex int,
	@DueBy varchar(200),
	@ReviewedByTraffic tinyint,
	@UserKey int 

AS --Encrypt

  /*
  || When     Who Rel   What
  || 12/04/06 GHL 8.4   Updated Comments to 4000 chars for conversion of task assignments
  || 12/15/06 GHL 8.4   Added cleanup of Actuals when TaskType =1 
  || 01/19/07 GHL 8.4   Added Time Completed logic
  */
  
	IF EXISTS(SELECT 1 FROM tTask (NOLOCK) WHERE TaskID = @TaskID AND ProjectKey = @ProjectKey AND TaskKey <> @TaskKey)
		RETURN -1

	-- only allow show on calendar if duration is less than or equal to 1
	if @PlanDuration > 1 
		begin
			select @ShowOnCalendar = 0
			select @EventStart = null
			select @EventEnd = null
		end 
			  
	Declare @ReviewedByDate smalldatetime
			,@ReviewedByKey int
			,@OldReviewedByDate smalldatetime
			,@OldReviewedByTraffic tinyint
			,@OldReviewedByKey int
			,@CompletedByDate datetime
			,@OldCompletedByDate datetime
			,@CompletedByKey int
			,@OldCompletedByKey int
			,@OldPercComp int

	Select @OldReviewedByTraffic = ISNULL(ReviewedByTraffic, 0)
	      ,@OldReviewedByDate = ReviewedByDate
	      ,@OldReviewedByKey = ReviewedByKey
		  ,@OldCompletedByDate = CompletedByDate
	      ,@OldCompletedByKey = CompletedByKey
	      ,@OldPercComp = ISNULL(PercComp, 0)       
	from   tTask (NOLOCK) 
	Where  TaskKey = @TaskKey
			
	-- Update the traffic stuff only if percent complete separate
	If isnull(@PercCompSeparate,0) = 0
	Begin
	
		if @OldReviewedByTraffic <> @ReviewedByTraffic
		BEGIN
			-- Review By traffic flag has changed
			if @ReviewedByTraffic = 1
				-- User set task as reviewed, so set review date
				Select @ReviewedByDate = GETUTCDATE()
				      ,@ReviewedByKey = @UserKey
			else
				-- User said task was not reviewed
				Select @ReviewedByDate = NULL
			          ,@ReviewedByKey = NULL
		END		
		ELSE
			-- Review By traffic flag has not changed, keep old settings
			SELECT @ReviewedByDate = @OldReviewedByDate   
			       ,@ReviewedByKey = @OldReviewedByKey 
			       
		-- Check old and new PercComp
		If @OldPercComp <> @PercComp 
		BEGIN
			IF @PercComp >= 100
				SELECT @CompletedByDate = GETUTCDATE()
					 ,@CompletedByKey = @UserKey
			ELSE
				-- The task is not complete
				SELECT @CompletedByDate = NULL
					 ,@CompletedByKey = NULL
		END 
		ELSE
			-- Perc Comp have not changed, keep old settings
			SELECT @CompletedByDate = @OldCompletedByDate
				  ,@CompletedByKey = @OldCompletedByKey
					
	End
	ELSE
		-- do not change a thing, this should be rolled up from tTaskUser
		SELECT @ReviewedByTraffic = @OldReviewedByTraffic
			  ,@ReviewedByDate = @OldReviewedByDate
	          ,@ReviewedByKey = @OldReviewedByKey
		      ,@CompletedByDate = @OldCompletedByDate
	          ,@CompletedByKey = @OldCompletedByKey
	      	  		 		  
	UPDATE
		tTask
	SET
		ProjectKey = @ProjectKey,
		TaskID = @TaskID,
		TaskName = @TaskName,
		Description = @Description,
		HourlyRate = @HourlyRate,
		Markup = @Markup,
		IOCommission = @IOCommission,
		BCCommission = @BCCommission,
		ShowDescOnEst = @ShowDescOnEst,
		ServiceKey = @ServiceKey,
		Taxable = @Taxable,
		Taxable2 = @Taxable2,
		WorkTypeKey = @WorkTypeKey,
		BaseStart = @BaseStart,
		BaseComplete = @BaseComplete,
		PlanDuration = @PlanDuration,
		ActStart = CASE WHEN TaskType = 1 THEN NULL
				        ELSE @ActStart END,
		ActComplete = CASE WHEN TaskType = 1 THEN NULL 
					   ELSE @ActComplete END,
		PercComp = @PercComp,
		TaskConstraint = @TaskConstraint,
		Comments = @Comments,
		HideFromClient = @HideFromClient,
		AllowAnyone = @AllowAnyone,
		MasterTaskKey =	@MasterTaskKey,
		ConstraintDate = @ConstraintDate,
		WorkAnyDay = @WorkAnyDay,
		PercCompSeparate = @PercCompSeparate,
		TaskAssignmentTypeKey = @TaskAssignmentTypeKey,
		Priority = @Priority,
		ShowOnCalendar = @ShowOnCalendar,
		EventStart = @EventStart,
		EventEnd = @EventEnd,
		TimeZoneIndex = @TimeZoneIndex,
		DueBy = @DueBy,
		ReviewedByTraffic = @ReviewedByTraffic,
		ReviewedByDate = @ReviewedByDate,
	    ReviewedByKey = @ReviewedByKey,
		CompletedByDate = @CompletedByDate,
	    CompletedByKey = @CompletedByKey
	      	  	
	WHERE
		TaskKey = @TaskKey 
	
	RETURN 1
GO
