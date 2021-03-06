USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportTask]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportTask]
	@CompanyKey int,
	@ProjectNumber varchar(50),
	@TaskID varchar(30),
	@TaskName varchar(300),
	@Description varchar(1000),
	@TaskType smallint,
	@SummaryTaskID varchar(30),
	@HourlyRate money,
	@Markup decimal(9,3),
	@ShowDescOnEst tinyint,
	@Taxable tinyint,
	@WorkTypeID varchar(100),
	@BaseStart smalldatetime,
	@BaseComplete smalldatetime,
	@PlanStart smalldatetime,
	@PlanComplete smalldatetime,
	@PlanDuration int,
	@ActStart smalldatetime,
	@ActComplete smalldatetime,
	@PercComp int,
	@TaskConstraint smallint,
	@ScheduleNote varchar(200),
	@Comments varchar(1000),
	@ScheduleTask tinyint,
	@MoneyTask tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

declare @NewDisplayOrder int,
		@ProjectKey int,
		@WorkTypeKey int,
		@SummaryTaskKey int,
		@TaskTypeNum smallint,
		@TaskStatus smallint

	SELECT	@ProjectKey = ProjectKey
	FROM	tProject (nolock)
	WHERE	ProjectNumber = @ProjectNumber
	AND		CompanyKey = @CompanyKey
	
	IF @ProjectKey IS NULL
		RETURN -2

	IF EXISTS(SELECT 1 FROM tTask (nolock) WHERE TaskID = @TaskID AND ProjectKey = @ProjectKey)
		RETURN -1

	IF @WorkTypeID IS NOT NULL
	BEGIN		
		SELECT	@WorkTypeKey = WorkTypeKey
		FROM	tWorkType (nolock)
		WHERE	WorkTypeID = @WorkTypeID
		AND		CompanyKey = @CompanyKey

		IF @WorkTypeKey IS NULL
			RETURN -3
	END		
	
	IF @SummaryTaskID IS NOT NULL
	BEGIN
		SELECT	@SummaryTaskKey = t.TaskKey
		FROM	tTask t (nolock)
		WHERE	t.TaskID = @SummaryTaskID
		AND		t.TaskType = 1
		AND		t.ProjectKey = @ProjectKey

		IF @SummaryTaskKey IS NULL
			RETURN -4
	END
		
	--Calculate Plan Dates
	IF @PlanStart IS NULL
		SELECT @PlanStart = GETDATE()
	
	IF @PlanComplete IS NULL
		IF (@PlanStart IS NOT NULL) AND (@PlanDuration IS NOT NULL)
			SELECT @PlanComplete = DATEADD(day, @PlanDuration, @PlanStart)
		ELSE
			SELECT @PlanComplete = GETDATE()
	ELSE
		IF @PlanDuration IS NULL	
			SELECT @PlanDuration = DATEDIFF(day, @PlanStart, @PlanComplete)
	
	IF @PlanDuration IS NULL
		SELECT @PlanDuration = 0

	select @NewDisplayOrder = (select count(*)+1
	                            from tTask (nolock)
	                           where ProjectKey = @ProjectKey
	                             and ISNULL(SummaryTaskKey, 0) = ISNULL(@SummaryTaskKey, 0))
	
	SELECT @TaskStatus = 1
                           
	INSERT tTask
		(
		ProjectKey,
		TaskID,
		TaskName,
		Description,
		TaskType,
		SummaryTaskKey,
		HourlyRate,
		Markup,
		ShowDescOnEst,
		DisplayOrder,
		Taxable,
		WorkTypeKey,
		BaseStart,
		BaseComplete,
		PlanStart,
		PlanComplete,
		PlanDuration,
		ActStart,
		ActComplete,
		PercComp,
		TaskStatus,
		TaskConstraint,
		Comments,
		ScheduleTask,
		MoneyTask
		)

	VALUES
		(
		@ProjectKey,
		@TaskID,
		@TaskName,
		@Description,
		ISNULL(@TaskType, 2),
		isnull(@SummaryTaskKey,0),
		@HourlyRate,
		@Markup,
		@ShowDescOnEst,
		@NewDisplayOrder,
		@Taxable,
		@WorkTypeKey,
		@BaseStart,
		@BaseComplete,
		@PlanStart,
		@PlanComplete,
		@PlanDuration,
		@ActStart,
		@ActComplete,
		@PercComp,
		@TaskStatus,
		@TaskConstraint,
		@Comments,
		@ScheduleTask,
		@MoneyTask
		)
	
	SELECT @oIdentity = @@IDENTITY
	
	exec sptTaskOrder @ProjectKey, 0, 0, 0

	RETURN 1
GO
