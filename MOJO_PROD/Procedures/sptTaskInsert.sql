
alter PROCEDURE [dbo].[sptTaskInsert]
	@ProjectKey int,
	@TaskID varchar(30),
	@TaskName varchar(300),
	@Description varchar(6000),
	@TaskType smallint,
	@SummaryTaskKey int,
	@HourlyRate money,
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
	@Comments varchar(4000),
	@ScheduleTask tinyint,
	@TrackBudget tinyint,
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
	@DueBy varchar(300),
	@UserKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

  /*
  || When     Who Rel   What
  || 10/24/06 GHL 8.4   Since master tasks are inserted without the help of the scheduling component  
  ||                    Added a change of the task type of the summary task key
  || 12/04/06 GHL 8.4   Updated Comments to 4000 chars for conversion of task assignments
  || 01/19/07 GHL 8.4   Added Time Completed logic
  || 07/31/13 RLB 10570 (179533) added some checks for new task constraint
  */
  
declare @GetRateFrom int
declare @NewDisplayOrder int, @RequireMasterTask tinyint, @CompanyKey int, @Error int
declare @CompletedByDate datetime, @CompletedByKey int
	
	IF EXISTS(SELECT 1 FROM tTask (NOLOCK) WHERE TaskID = @TaskID AND ProjectKey = @ProjectKey)
		RETURN -1
	-- adding some checks for new constraint Duration Of Project
	IF ISNULL(@SummaryTaskKey, 0) > 0
	BEGIN
		IF EXISTS(SELECT 1 FROM tTask (NOLOCK) WHERE TaskKey =  @SummaryTaskKey AND TaskConstraint = 7)
			RETURN -3
	END
	IF @TaskConstraint = 7
		BEGIN
			IF ISNULL(@TaskType, 0) = 1
				RETURN -4
			IF ISNULL(@SummaryTaskKey, 0) > 0 
				RETURN - 5
		END

	Select @RequireMasterTask = ISNULL(RequireMasterTask, 0), @CompanyKey = p.CompanyKey
	From tProject p (nolock) inner join tPreference pr (nolock) on p.CompanyKey = pr.CompanyKey
	Where p.ProjectKey = @ProjectKey
	 
                   
	select @NewDisplayOrder = (select count(*)+1
	from tTask (nolock)
	where ProjectKey = @ProjectKey
	and ISNULL(SummaryTaskKey, 0) = ISNULL(@SummaryTaskKey, 0))
	    
	-- only allow show on calendar if duration is less than or equal to 1
	if @PlanDuration > 1 
		begin
			select @ShowOnCalendar = 0
			select @EventStart = null
			select @EventEnd = null
		end 

	IF @PercComp >= 100
		SELECT @CompletedByDate = GETUTCDATE()
		      ,@CompletedByKey = @UserKey
						                             
	INSERT tTask WITH (ROWLOCK)
		(
		ProjectKey,
		TaskID,
		TaskName,
		Description,
		TaskType,
		SummaryTaskKey,
		HourlyRate,
		Markup,
		IOCommission,
		BCCommission,
		ShowDescOnEst,
		ServiceKey,
		DisplayOrder,
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
		TaskLevel,
		TaskAssignmentTypeKey,
		Priority,
		ShowOnCalendar,
		EventStart,
		EventEnd,
		TimeZoneIndex,
		DueBy,
		CompletedByDate,
		CompletedByKey
		)

	VALUES
		(
		@ProjectKey,
		@TaskID,
		@TaskName,
		@Description,
		@TaskType,
		isnull(@SummaryTaskKey,0),
		@HourlyRate,
		@Markup,
		@IOCommission,
		@BCCommission,
		@ShowDescOnEst,
		@ServiceKey,
		@NewDisplayOrder,
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
		@TrackBudget,  -- for this task MoneyTask will always be the same as TrackBudget for new rows
		@HideFromClient,
		@AllowAnyone,
		@MasterTaskKey,
		@ConstraintDate,
		@WorkAnyDay,
		@PercCompSeparate,
		@ProjectOrder,
		@TaskLevel,
		@TaskAssignmentTypeKey,
		@Priority,
		@ShowOnCalendar,
		@EventStart,
		@EventEnd,
		@TimeZoneIndex,
		@DueBy,
		@CompletedByDate,
		@CompletedByKey
		) 
	
	SELECT @Error = @@ERROR, @oIdentity = @@IDENTITY

	-- This is to handle the master tasks which are inserted without the Scheduling component  
	IF ISNULL(@SummaryTaskKey, 0) > 0 And ISNULL(@MasterTaskKey, 0) > 0 And @Error = 0 
		UPDATE tTask SET TaskType = 1 WHERE TaskKey = @SummaryTaskKey 
	 
	RETURN 1
	
