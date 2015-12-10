USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLoadStandardTask]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoadStandardTask]
	@CompanyKey int,
	@ProjectNumber varchar(50),
	@TaskID varchar(30),
	@SummaryTaskID varchar(30),
	@BudgetTaskID varchar(30),
	@WorkTypeID varchar(100),	
	@TaskName varchar(300),
	@Description varchar(1000),
	@TaskType smallint,
	@HourlyRate money,
	@Markup decimal(24,4),
	@ShowDescOnEst tinyint,
	@Taxable tinyint,
	@Taxable2 tinyint,
	@BaseStart smalldatetime,
	@BaseComplete smalldatetime,
	@PlanStart smalldatetime,
	@PlanComplete smalldatetime,
	@PlanDuration int,
	@ActStart smalldatetime,
	@ActComplete smalldatetime,
	@TaskConstraint smallint,
	@Comments varchar(1000),
	@ScheduleTask tinyint,
	@TrackBudget tinyint,
	@MoneyTask tinyint,
	@HideFromClient tinyint,
	@AllowAnyone tinyint,
	@ConstraintDate smalldatetime,
	@WorkAnyDay int,
	@ProjectOrder int,
	@DisplayOrder int,
	@TaskLevel int,
	@Priority smallint,
	@PercCompSeparate int = null,
	@oIdentity INT OUTPUT
AS --Encrypt

  /*
  || When     Who Rel   What
  || 01/02/07 GHL 8.4   Corrected BudgetTaskKey when TrackBudget = 1 
  || 04/01/14 GHL 10.577 Added PercCompSeparate
  ||                    
  */

DECLARE @ProjectKey int
		,@SummaryTaskKey int
		,@BudgetTaskKey int
		,@WorkTypeKey int
		
	-- TaskID is optional now	
	IF @TaskID IS NOT NULL
		IF EXISTS(SELECT 1 FROM tTask (NOLOCK) WHERE TaskID = @TaskID AND ProjectKey = @ProjectKey)
			RETURN -1

	IF @PercCompSeparate is null
	begin
		if @TaskType = 2
			-- Detail
			select @PercCompSeparate = 1
		else
			-- Summary
			select @PercCompSeparate = 0
	end	

	SELECT @ProjectKey = ProjectKey
	FROM   tProject (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    ProjectNumber = @ProjectNumber
	
	SELECT @WorkTypeKey = WorkTypeKey
	FROM   tWorkType (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    WorkTypeID = @WorkTypeID
	
	-- In load standard, we insert summary tasks first so summary task id and budget task id should be fine
	-- Except for tasks where TrackBudget = 1 
	SELECT @SummaryTaskKey = TaskKey
	FROM   tTask (NOLOCK)
	WHERE  ProjectKey = @ProjectKey
	AND    TaskID = @SummaryTaskID
	 
	SELECT @BudgetTaskKey = TaskKey
	FROM   tTask (NOLOCK)
	WHERE  ProjectKey = @ProjectKey
	AND    TaskID = @BudgetTaskID     
	                               
	INSERT tTask
		(
		ProjectKey,
		TaskID,
		SummaryTaskKey,
		BudgetTaskKey,
		TaskName,
		Description,
		TaskType,
		TaskStatus,
		HourlyRate,
		Markup,
		ShowDescOnEst,
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
		ConstraintDate,
		WorkAnyDay,
		ProjectOrder,
		TaskLevel,
		Priority,
		PercCompSeparate
		)

	VALUES
		(
		@ProjectKey,
		@TaskID,
		isnull(@SummaryTaskKey,0),
		isnull(@BudgetTaskKey,0),
		@TaskName,
		@Description,
		@TaskType,
		1, -- TaskStatus
		@HourlyRate,
		@Markup,
		@ShowDescOnEst,
		@DisplayOrder,
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
		0, -- PercComp
		@TaskConstraint,
		@Comments,
		@ScheduleTask,
		@TrackBudget,
		@MoneyTask, 
		@HideFromClient,
		@AllowAnyone,
		@ConstraintDate,
		@WorkAnyDay,
		@ProjectOrder,
		@TaskLevel,
		@Priority,
		@PercCompSeparate
		)
	
	SELECT @oIdentity = @@IDENTITY

	IF @TrackBudget = 1
		UPDATE tTask
		SET    BudgetTaskKey = @oIdentity
		WHERE  TaskKey = @oIdentity
	
	RETURN 1
GO
