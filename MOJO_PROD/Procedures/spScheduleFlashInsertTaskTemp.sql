CREATE PROCEDURE [dbo].[spScheduleFlashInsertTaskTemp]
	(
	@TaskKey int,
	@ProjectKey int,
	@TaskID varchar(30),
	@TaskName varchar(300),
	@Description varchar(6000),
	@TaskType smallint,
	@SummaryTaskKey int,
	@BudgetTaskKey int,
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
	@PlanStart smalldatetime,
	@PlanComplete smalldatetime,
	@PlanDuration int,
	@ActStart smalldatetime,
	@ActComplete smalldatetime,
	@PercComp int,
	@TaskConstraint smallint,
	@Comments varchar(1000),
	@ScheduleTask tinyint,
	@TrackBudget tinyint,
	@MoneyTask tinyint,
	@HideFromClient tinyint,
	@AllowAnyone tinyint,
	@MasterTaskKey int,
	@ConstraintDate smalldatetime,
	@WorkAnyDay int,
	@PercCompSeparate int,
	@ProjectOrder int,
	@DisplayOrder int,
	@TaskLevel int,
	@TaskAssignmentTypeKey int,
	@Priority smallint,
	@ShowOnCalendar tinyint,
	@EventStart smalldatetime,
	@EventEnd smalldatetime,
	@TimeZoneIndex int,
	@DueBy varchar(200),
	@ReviewedByTraffic tinyint,
	@UserKey int,		
	@PredecessorsComplete tinyint,
	@TaskStatus smallint,
	@ScheduleNote varchar(200),
	@FromTaskKey int = null,
	@TimelineSegmentKey int = null,
	@ConstraintDayOfTheWeek int = null,
	@ExcludeFromStatus tinyint,
	@TimelineSegmentDisplayName varchar(200),
	@AllowAllocatedHours tinyint
	)

AS -- Encrypt

  /*
  || When     Who Rel   What
  || 10/19/06 GHL 8.4   Added @ReviewedByKey logic 
  || 12/15/06 GHL 8.4   Added cleanup of Actuals for TaskType = 1
  || 01/22/07 GHL 8.4   Added logic for Completed Time and User
  || 07/10/07 GWG 8.43  Expanded Description to 6000
  || 7/12/10  CRG 10.5.3.2 Added ShowOnTimeline and TaskColor (optional for CMP90 compatibility)
  || 7/27/10  CRG 10.5.3.3 Added FromTaskKey (optional for CMP90 compatibility)
  || 10/19/10 CRG 10.5.3.7 Removed ShowOnTimeline and TaskColor. Added TimelineSegmentKey (optional for CMP90 compatibility)
  || 10/30/12 RLB 10.5.6.1 Kohls enhancement for Constraint Day of the Week 
  || 10/30/12 RLB 10.5.6.2 Kohls enhancement for Exclude From Status 
  || 06/20/13 RLB 10.5.6.9 Added for Enhancement (172776)
  || 03/06/14 RLB 10.5.7.8 (196273) Adding AllowAllocatedHours for enhancement
  */

	SET NOCOUNT ON

	IF @TaskType = 1
		SELECT @ActStart = NULL, @ActComplete = NULL
		 
	DECLARE @Action INT -- 1 Insert, 2 Update, 3 Delete
	IF @TaskKey < 0 
		SELECT @Action = 1
	ELSE
		SELECT @Action = 2
		
	-- What about CustomFieldKey????

	-- clone @ReviewedByKey logic from sptTaskInsert/sptTaskUpdate
	
	DECLARE @ReviewedByDate smalldatetime
		   ,@ReviewedByKey int
		   ,@OldReviewedByTraffic tinyint
		   ,@OldReviewedByDate smalldatetime
		   ,@OldReviewedByKey int
		   ,@OldPercComp int
		   ,@CompletedByDate datetime
		   ,@CompletedByKey int
		   ,@OldCompletedByDate datetime
		   ,@OldCompletedByKey int
		   	
	-- no need to do anything if @PercCompSeparate = 1 
	-- Will be rolled up from tTaskUser, just do cleanup here
	If isnull(@PercCompSeparate,0) = 1
	Begin
		Select @ReviewedByTraffic = 0
		      ,@ReviewedByDate = NULL
		      ,@ReviewedByKey = NULL
	End
	
	If isnull(@PercCompSeparate,0) = 0
	Begin
	
		If @Action = 2
		BEGIN
			-- Update
			Select @OldReviewedByTraffic = ISNULL(ReviewedByTraffic, 0)
				   ,@OldReviewedByDate = ReviewedByDate  
				   ,@OldReviewedByKey = ReviewedByKey
				   ,@OldPercComp = ISNULL(PercComp, 0)
				   ,@OldCompletedByDate = CompletedByDate     
				   ,@OldCompletedByKey = CompletedByKey				   	
			from    tTask (NOLOCK) WHERE TaskKey = @TaskKey
		
			-- Review By traffic flag has changed
			if @OldReviewedByTraffic <> @ReviewedByTraffic
			BEGIN
				if @ReviewedByTraffic = 1
					-- User set task as reviewed, so set review date
					Select @ReviewedByDate = GETUTCDATE()
					       ,@ReviewedByKey = @UserKey
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
					  		
		END
		ELSE
		BEGIN
			-- Insert
			if @ReviewedByTraffic = 1
				-- User set task as reviewed, so set review date
				Select @ReviewedByDate = GETUTCDATE()
				      ,@ReviewedByKey = @UserKey
			else
				-- User reset task as reviewed
				Select @ReviewedByDate = NULL
					    ,@ReviewedByKey = NULL
		
			if @PercComp >= 100
				Select @CompletedByDate = GETUTCDATE()
					  ,@CompletedByKey = @UserKey
			else
				Select @CompletedByDate = NULL
					  ,@CompletedByKey = NULL
			
		END
		
		
		
	End

	INSERT #tTask
	(
	TaskKey,
	ProjectKey,
	TaskID,
	TaskName,
	Description,
	TaskType,
	SummaryTaskKey,
	BudgetTaskKey,
	HourlyRate,
	Markup,
	IOCommission,
	BCCommission,
	ShowDescOnEst,
	ServiceKey,
	Taxable,
	Taxable2,
	WorkTypeKey,
	BaseStart,
	BaseComplete,
	PlanStart,
	PlanComplete,
	PlanDuration,
	ActStart,
	ActComplete,
	PercComp,
	TaskConstraint,
	Comments,
	ScheduleTask,
	TrackBudget,
	MoneyTask,
	HideFromClient,
	AllowAnyone,
	MasterTaskKey,
	ConstraintDate,
	WorkAnyDay,
	PercCompSeparate,
	ProjectOrder,
	DisplayOrder,
	TaskLevel,
	TaskAssignmentTypeKey,
	Priority,
	ShowOnCalendar,
	EventStart,
	EventEnd,
	TimeZoneIndex,
	DueBy,
	ReviewedByTraffic,
	ReviewedByDate,
	ReviewedByKey,
	PredecessorsComplete,
	Action,
	TaskStatus,
	ScheduleNote,
	CompletedByDate,
	CompletedByKey,
	TimelineSegmentKey,
	FromTaskKey,
	ConstraintDayOfTheWeek,
	ExcludeFromStatus,
	TimelineSegmentDisplayName,
	AllowAllocatedHours
	)
	VALUES 
	(	
	@TaskKey,
	@ProjectKey,
	@TaskID,
	@TaskName,
	@Description,
	@TaskType,
	@SummaryTaskKey,
	@BudgetTaskKey,
	@HourlyRate,
	@Markup,
	@IOCommission,
	@BCCommission,
	@ShowDescOnEst,
	@ServiceKey,
	@Taxable,
	@Taxable2,
	@WorkTypeKey,
	@BaseStart,
	@BaseComplete,
	@PlanStart,
	@PlanComplete,
	@PlanDuration,
	@ActStart,
	@ActComplete,
	@PercComp,
	@TaskConstraint,
	@Comments,
	@ScheduleTask,
	@TrackBudget,
	@MoneyTask,
	@HideFromClient,
	@AllowAnyone,
	@MasterTaskKey,
	@ConstraintDate,
	@WorkAnyDay,
	@PercCompSeparate,
	@ProjectOrder,
	@DisplayOrder,
	@TaskLevel,
	@TaskAssignmentTypeKey,
	@Priority,
	@ShowOnCalendar,
	@EventStart,
	@EventEnd,
	@TimeZoneIndex,
	@DueBy,
	@ReviewedByTraffic,
	@ReviewedByDate,
	@ReviewedByKey,
	@PredecessorsComplete,
	@Action,
	@TaskStatus,
	@ScheduleNote,
	@CompletedByDate,
	@CompletedByKey,
	@TimelineSegmentKey,
	@FromTaskKey,
	@ConstraintDayOfTheWeek,
	@ExcludeFromStatus,
	@TimelineSegmentDisplayName,
	@AllowAllocatedHours
	)

	
	RETURN 1 