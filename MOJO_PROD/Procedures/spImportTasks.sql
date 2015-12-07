CREATE PROCEDURE [dbo].[spImportTasks]
AS --Encrypt

  /*
  || When     Who Rel       What
  || 12/27/06 GHL 8.4       Fixed problem in predecessor loop
  || 01/22/07 GHL 8.4       Added logic for sptTaskInsert UserKey (for tTask.CompletedByKey)
  || 5/13/11  CRG 10.5.4.4  Added COLLATE DATABASE_DEFAULT to string compares to the temp table
  */
	DECLARE @ProjectKey int,
			@TaskID varchar(30),
			@TaskName varchar(300),
			@Description varchar(1000),
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
			@Comments varchar(1000),
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
			@oIdentity INT,
			@TaskKey int,
			@TempTaskKey int,
			@CompanyKey int,
			@UserKey int
				
	--First, update some foreign keys
	UPDATE	#tTask
	SET		ServiceKey = s.ServiceKey
	FROM	tService s (NOLOCK)
	WHERE	#tTask.ServiceCode = s.ServiceCode COLLATE DATABASE_DEFAULT
	AND		#tTask.Operator = 'I'
	
	UPDATE	#tTask
	SET		SystemErrors = 'Invalid ServiceCode. '
	WHERE	ServiceKey IS NULL
	AND		ServiceCode IS NOT NULL
	AND		#tTask.Operator = 'I'
	
	UPDATE	#tTask
	SET		WorkTypeKey = w.WorkTypeKey
	FROM	tWorkType w (NOLOCK)
	WHERE	#tTask.WorkTypeID = w.WorkTypeID COLLATE DATABASE_DEFAULT
	AND		#tTask.Operator = 'I'
	
	UPDATE	#tTask
	SET		SystemErrors = 'Invalid WorkTypeID. '
	WHERE	WorkTypeKey IS NULL
	AND		WorkTypeID IS NOT NULL
	AND		#tTask.Operator = 'I'
	
	UPDATE	#tTask
	SET		TaskAssignmentTypeKey = t.TaskAssignmentTypeKey
	FROM	tTaskAssignmentType t (NOLOCK)
	WHERE	#tTask.TaskAssignmentType = t.TaskAssignmentType COLLATE DATABASE_DEFAULT
	AND		#tTask.Operator = 'I'
	
	UPDATE	#tTask
	SET		SystemErrors = 'Invalid TaskAssignmentType. '
	WHERE	TaskAssignmentTypeKey IS NULL
	AND		TaskAssignmentType IS NOT NULL
	AND		#tTask.Operator = 'I'

	IF EXISTS
			(SELECT NULL FROM #tTask WHERE SystemErrors IS NOT NULL)
		RETURN -2 --Report the specific error back to the user
			
	--Loop through the TempTaskKeys and attempt to Insert the records into tTask
	BEGIN TRAN
	
	SELECT	@TempTaskKey=0
	WHILE (1=1)
	BEGIN
		SELECT	@TempTaskKey = MAX(TempTaskKey) --MAX because they are negative
		FROM	#tTask
		WHERE	TempTaskKey < @TempTaskKey
		AND		Operator = 'I'
		
		IF @TempTaskKey IS NULL
			BREAK
			
		SELECT	@ProjectKey = ProjectKey,
				@TaskID = TaskID,
				@TaskName = TaskName,
				@Description = Description,
				@TaskType = TaskType,
				@SummaryTaskKey = SummaryTaskKey,
				@HourlyRate = HourlyRate,
				@Markup = Markup,
				@IOCommission = IOCommission,
				@BCCommission = BCCommission,
				@ShowDescOnEst = ShowDescOnEst,
				@ServiceKey = ServiceKey,
				@Taxable = Taxable,
				@Taxable2 = Taxable2,
				@WorkTypeKey = WorkTypeKey,
				@BaseStart = BaseStart,
				@BaseComplete = BaseComplete,
				@PlanStart = PlanStart,
				@PlanComplete = PlanComplete,
				@PlanDuration = PlanDuration,
				@ActStart = ActStart,
				@ActComplete = ActComplete,
				@PercComp = ISNULL(PercComp, 0),
				@TaskConstraint = TaskConstraint,
				@Comments = Comments,
				@ScheduleTask = ScheduleTask,
				@TrackBudget = TrackBudget,
				@HideFromClient = HideFromClient,
				@AllowAnyone = AllowAnyone,
				@MasterTaskKey = MasterTaskKey,
				@ConstraintDate = ConstraintDate,
				@WorkAnyDay = WorkAnyDay,
				@PercCompSeparate = PercCompSeparate,
				@ProjectOrder = ProjectOrder,
				@DisplayOrder = DisplayOrder,
				@TaskLevel = TaskLevel,
				@TaskAssignmentTypeKey = TaskAssignmentTypeKey,
				@Priority = Priority,
				@ShowOnCalendar = ShowOnCalendar,
				@EventStart = EventStart,
				@EventEnd = EventEnd,
				@TimeZoneIndex = TimeZoneIndex,
				@DueBy = DueBy		
		FROM	#tTask
		WHERE	TempTaskKey = @TempTaskKey
	
		-- should have been set when importing the project
		SELECT @UserKey = CreatedByKey
			  ,@CompanyKey = CompanyKey
		FROM   tProject (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		
		IF  @UserKey IS NULL
			SELECT @UserKey = UserKey
			FROM   tUser (NOLOCK)
			WHERE  CompanyKey = @CompanyKey
			AND    Administrator = 1
			AND    Active = 1			
	
		EXEC sptTaskInsert
				@ProjectKey,
				@TaskID,
				@TaskName,
				@Description,
				@TaskType,
				@SummaryTaskKey,
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
				@UserKey,
				@oIdentity OUTPUT
				
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -1
		END
				
		IF @oIdentity > 0
			UPDATE	#tTask
			SET		TaskKey = @oIdentity
			WHERE	TempTaskKey = @TempTaskKey
		ELSE
		BEGIN
			ROLLBACK TRAN
			RETURN -1
		END
	END

	--Now go back through the inserted tasks one more time and update the ForeignKeys & PredecessorKeys to the correct TaskKey
	SELECT	@TempTaskKey=0
	
	WHILE (1=1)
	BEGIN
		SELECT	@TempTaskKey = MAX(TempTaskKey) --MAX because they are negative
		FROM	#tTask
		WHERE	TempTaskKey < @TempTaskKey
		AND		Operator = 'I'
		
		IF @TempTaskKey IS NULL
			BREAK
	
		SELECT	@TaskKey = TaskKey
		FROM	#tTask
		WHERE	TempTaskKey = @TempTaskKey
		
		UPDATE	#tTask
		SET		SummaryTaskKey = @TaskKey
		WHERE	SummaryTaskKey = @TempTaskKey
		
		UPDATE	#tTask
		SET		MasterTaskKey = @TaskKey
		WHERE	MasterTaskKey = @TempTaskKey
		
		UPDATE	#tTask
		SET		BudgetTaskKey = @TaskKey
		WHERE	BudgetTaskKey = @TempTaskKey
	END
	
	--Delete the TaskPredecessors where the TempTaskKey > 0 (because these already existed in the DB)
	DELETE	#tTaskPredecessor
	WHERE	TempTaskKey > 0
	
	--Loop through #tTaskPredecessor and set any negative TempTaskKeys to their correct keys
	SELECT	@TempTaskKey=0
	
	WHILE (1=1)
	BEGIN
		SELECT	@TempTaskKey = MAX(TempTaskKey) --MAX because they are negative
		FROM	#tTaskPredecessor
		WHERE	TempTaskKey < @TempTaskKey
		
		IF @TempTaskKey IS NULL
			BREAK

		--Get the correct TaskKey from #tTask
		SELECT	@TaskKey = TaskKey
		FROM	#tTask
		WHERE	TempTaskKey = @TempTaskKey
	
		UPDATE	#tTaskPredecessor
		SET		TaskKey = @TaskKey
		WHERE	TempTaskKey = @TempTaskKey
	END	
	
	--Loop through #tTaskPredecessor and set any negative TempPredecessorKeys to their correct keys
	SELECT	@TempTaskKey=0
	
	WHILE (1=1)
	BEGIN
		SELECT	@TempTaskKey = MAX(TempPredecessorKey) --MAX because they are negative
		FROM	#tTaskPredecessor
		WHERE	TempPredecessorKey < @TempTaskKey
		
		IF @TempTaskKey IS NULL
			BREAK

		--Get the correct TaskKey from #tTask
		SELECT	@TaskKey = TaskKey
		FROM	#tTask
		WHERE	TempTaskKey = @TempTaskKey
	
		UPDATE	#tTaskPredecessor
		SET		PredecessorKey = @TaskKey
		WHERE	TempPredecessorKey = @TempTaskKey
	END
	
	--Update the PredecessorKey to TempPredecessorKey, if it's still NULL
	--This is for PredecessorKeys that are already tasks in the DB
	UPDATE	#tTaskPredecessor
	SET		PredecessorKey = TempPredecessorKey
	WHERE	PredecessorKey IS NULL
	
	--Update tTask with the correct TaskKeys
	UPDATE	tTask WITH (ROWLOCK)
	SET		SummaryTaskKey = #tTask.SummaryTaskKey,
			MasterTaskKey = #tTask.MasterTaskKey,
			BudgetTaskKey = #tTask.BudgetTaskKey
	FROM	#tTask
	WHERE	tTask.TaskKey = #tTask.TaskKey
	AND		#tTask.Operator = 'I'

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
	
	--Update the tasks that already exsisted before the import, but may have changed in the ScheduleMgr
	UPDATE	tTask WITH (ROWLOCK)
	SET		tTask.TaskType = #tTask.TaskType
			,tTask.SummaryTaskKey = #tTask.SummaryTaskKey
			,tTask.ScheduleTask = #tTask.ScheduleTask
			,tTask.MoneyTask = #tTask.MoneyTask
            ,tTask.TrackBudget = #tTask.TrackBudget
            ,tTask.DisplayOrder = #tTask.DisplayOrder
            ,tTask.ProjectOrder = #tTask.ProjectOrder 
            ,tTask.TaskLevel = #tTask.TaskLevel
			,tTask.BudgetTaskKey = #tTask.BudgetTaskKey
	FROM	#tTask
	WHERE	tTask.TaskKey = #tTask.TaskKey
	AND		#tTask.Operator = 'U'	

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END

	--Insert new tTaskPredecessor records from the import
	INSERT	tTaskPredecessor (TaskKey, PredecessorKey, Type)
	SELECT	TaskKey, PredecessorKey, 'FS'
	FROM	#tTaskPredecessor
	WHERE	PredecessorKey IS NOT NULL
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
	
	COMMIT TRAN	
	RETURN 1
	
