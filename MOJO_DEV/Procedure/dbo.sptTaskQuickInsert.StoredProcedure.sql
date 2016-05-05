USE [MOJo_dev]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskQuickInsert]    Script Date: 04/29/2016 16:26:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sptTaskQuickInsert]
	@ProjectKey int,
	@TaskID varchar(30),
	@TaskName varchar(300),
	@PlanDuration int,
	@CanTrackBudget int,
	@oIdentity INT OUTPUT
AS --Encrypt

  /*
  || When     Who Rel   What
  || 10/13/06 GHL 8.4   Added subtasks of master tasks 
  || 10/16/06 GHL 8.4   Added CFs and predecessors for subtasks of master tasks 
  ||                    Added @CanTrackBudget parameter (see below)   
  || 10/17/06 GHL 8.4   Added correction of TaskType   
  || 10/24/06 GHL 8.4   Modified error return -2 so that we error out if RequireMasterTasks = 1
  ||                    AND no master task can be found AND TrackBudget parameter = 1
  || 11/17/06 GHL 8.4   Inserting now detail master tasks by Work Order 
  || 12/13/06 GHL 8.4   Inserting now detail master tasks with MasterTaskKey = NULL
  || 01/17/07 GHL 8.4   Modified logic for creation of Predecessors  
  */
  
  /*
  || This stored procedure is use from sptProjectCopy and tasks.aspx
  || In sptProjectCopy pass @CanTrackBudget = 1 since all master tasks are inserted under the root 
  ||    and there cannot be any conflict
  || In tasks.aspx you may pass @CanTrackBudget = 0 since a task can be under another task where TrackBudget = 1   
  */

declare @NewDisplayOrder int, @GetRateFrom int, @RequireMasterTask tinyint, @CompanyKey int
declare @SummaryMasterTaskKey int, @TrackingMasterTaskKey int, @TrackingTaskKey int
declare @CustomFieldKey int
declare @WorkOrder int, @OldWorkOrder int
declare @SummaryMasterTaskTrackBudget int
declare @SummaryMasterTaskMoneyTask int
declare @TrackingMasterTaskTrackBudget int
declare @TrackingMasterTaskMoneyTask int
declare @TaskType int
declare @TrackBudget int
declare @MoneyTask int
declare @BudgetTaskKey int

	IF EXISTS(SELECT 1 FROM tTask (NOLOCK) WHERE TaskID = @TaskID AND ProjectKey = @ProjectKey)
		RETURN -1
	
	-- company info	
	Select	@RequireMasterTask = ISNULL(RequireMasterTask, 0)
			,@CompanyKey = p.CompanyKey
	From tProject p (nolock) 
		inner join tPreference pr (nolock) on p.CompanyKey = pr.CompanyKey
	Where p.ProjectKey = @ProjectKey
	
	-- master task info
	Select @SummaryMasterTaskKey = MasterTaskKey 
	      ,@CustomFieldKey = CustomFieldKey
	      ,@SummaryMasterTaskTrackBudget = TrackBudget
	      ,@SummaryMasterTaskMoneyTask = MoneyTask
	from tMasterTask (NOLOCK) 
	Where CompanyKey = @CompanyKey 
	and Active = 1 
	and TaskID = @TaskID 
	and TaskType = 1 -- Summary
	
	if @RequireMasterTask = 1 and ISNULL(@SummaryMasterTaskKey, 0) = 0 and @CanTrackBudget = 1
			return -2
	 
	if @TaskName is null
		if ISNULL(@SummaryMasterTaskKey, 0) > 0
			Select @TaskName = TaskName from tMasterTask (NOLOCK) Where MasterTaskKey = @SummaryMasterTaskKey
		else
			return -3
					
	-- If we have tracking master tasks, we must validate them as well
	IF EXISTS (SELECT 1
			   FROM   tMasterTask (NOLOCK)	
			   WHERE  CompanyKey = @CompanyKey 
			   AND    SummaryMasterTaskKey = @SummaryMasterTaskKey 
			   AND    Active = 1
			   AND    TaskID IN (SELECT TaskID FROM tTask (NOLOCK) 
								WHERE ProjectKey = @ProjectKey AND TaskID IS NOT NULL)
			   )
		return -4
				
	-- If we have tracking master tasks, this is a summary task
	-- If we do not have any, this is a tracking task even if the master task says summary 
	IF EXISTS (SELECT 1
			   FROM   tMasterTask (NOLOCK)	
			   WHERE  CompanyKey = @CompanyKey 
			   AND    SummaryMasterTaskKey = @SummaryMasterTaskKey 
			   AND    Active = 1
			   )
		SELECT @TaskType = 1
	ELSE 
		SELECT @TaskType = 2	
			
	-- we place the new task at the root and use the component later to set summary task
	select @NewDisplayOrder = (select count(*)+1
	                            from tTask
	                           where ProjectKey = @ProjectKey
	    and ISNULL(SummaryTaskKey, 0) = 0)
	
	-- set up defaults for general case (no master tasks)
	IF @CanTrackBudget = 1
		SELECT @TrackBudget = 1
				,@MoneyTask = 1
				,@BudgetTaskKey = NULL -- Will have to be updated later
	ELSE
		SELECT @TrackBudget = 0
				,@MoneyTask = 0
				,@BudgetTaskKey = NULL
								
				   
	INSERT tTask
		(
		ProjectKey,
		TaskID,
		TaskName,
		Description,
		TaskType,
		SummaryTaskKey,
		BudgetTaskKey,
		HourlyRate,
		Markup,
		ShowDescOnEst,
		ShowEstimateDetail,
		RollupOnEstimate,
		RollupOnInvoice,
		Visibility,
		ServiceKey,
		DisplayOrder,
		Taxable,
		Taxable2,
		WorkTypeKey,
		PlanStart,
		PlanComplete,
		PlanDuration,
		ActStart,
		ActComplete,
		PercComp,
		TaskStatus,
		TaskConstraint,
		Comments,
		MasterTaskKey,
		ScheduleTask,
		TrackBudget,
		MoneyTask
		)

	VALUES
		(
		@ProjectKey,
		@TaskID,
		@TaskName,
		NULL,
		2, -- Tracking by default
		0, -- SummaryTaskKey
		@BudgetTaskKey, 
		0,
		0,
		0,
		0,
		0,
		0,
		3,
		0,
		@NewDisplayOrder,
		0,
		0,
		NULL,
		CONVERT(VARCHAR(10), GETDATE(), 101),
		CONVERT(VARCHAR(10), GETDATE(), 101),
		@PlanDuration,
		NULL,
		NULL,
		0,
		1,
		0,
		NULL,
		@SummaryMasterTaskKey,
		1, -- ScheduleTask
		@TrackBudget,
		@MoneyTask
		)
	
	SELECT @oIdentity = @@IDENTITY
	
	IF @CanTrackBudget = 1
		UPDATE tTask SET BudgetTaskKey = @oIdentity WHERE TaskKey = @oIdentity
	
	
	-- Now handle the case when there is a master task
	if ISNULL(@SummaryMasterTaskKey, 0) > 0
	BEGIN
		IF @CanTrackBudget = 1
		BEGIN
			SELECT @TrackBudget = @SummaryMasterTaskTrackBudget
				   ,@MoneyTask = @SummaryMasterTaskMoneyTask	
			IF @TrackBudget = 1
				SELECT @BudgetTaskKey = @oIdentity
			ELSE
				SELECT @BudgetTaskKey = NULL
		END
		ELSE
			SELECT @TrackBudget = 0
				   ,@MoneyTask = 0	
				   ,@BudgetTaskKey = NULL 		
			
		-- update info from master task
		Update tTask
		Set
			TaskType = @TaskType,
			Description = tMasterTask.Description ,
			HourlyRate = tMasterTask.HourlyRate ,
			Markup = tMasterTask.Markup ,
			IOCommission = tMasterTask.IOCommission ,
			BCCommission = tMasterTask.BCCommission ,
			ShowDescOnEst = tMasterTask.ShowDescOnEst ,
			Taxable = tMasterTask.Taxable ,
			Taxable2 = tMasterTask.Taxable2 ,
			WorkTypeKey = tMasterTask.WorkTypeKey ,
			HideFromClient = tMasterTask.HideFromClient,
			PlanDuration = tMasterTask.PlanDuration,
			AllowAnyone = tMasterTask.AllowAnyone,
			PercCompSeparate = tMasterTask.PercCompSeparate,
			WorkAnyDay = tMasterTask.WorkAnyDay,
			TaskAssignmentTypeKey = tMasterTask.TaskAssignmentTypeKey,
			Priority = tMasterTask.Priority,
			ScheduleTask = tMasterTask.ScheduleTask ,
			TrackBudget = @TrackBudget,
			MoneyTask = @MoneyTask,
			BudgetTaskKey = @BudgetTaskKey 
		from tMasterTask 
		Where tMasterTask.MasterTaskKey = tTask.MasterTaskKey 
		and tTask.TaskKey = @oIdentity

		-- Set custom field on task
		if ISNULL(@CustomFieldKey, 0) > 0
			EXEC sptTaskDetailCopyCF @oIdentity, @CustomFieldKey 
		
		-- Now add the tracking tasks of the master task one by one
		SELECT @WorkOrder = -9999
		      ,@TrackingMasterTaskKey = 0
			  ,@NewDisplayOrder = 1
		
		CREATE TABLE #tMTTask (TaskKey INT NULL, MasterTaskKey INT NULL, WorkOrder INT NULL)
		
		WHILE (1=1)
		BEGIN
			SELECT @WorkOrder = MIN(WorkOrder)
			FROM   tMasterTask (NOLOCK)
			WHERE  CompanyKey = @CompanyKey
			AND	   SummaryMasterTaskKey = @SummaryMasterTaskKey	    
			AND    Active = 1
			AND    TaskType = 2
			AND    WorkOrder > @WorkOrder
			
			IF @WorkOrder IS NULL
				BREAK
			
			SELECT @TrackingMasterTaskKey = 0
				
			WHILE (1=1)
			BEGIN
				SELECT @TrackingMasterTaskKey = MIN(MasterTaskKey)
				FROM   tMasterTask (NOLOCK)
				WHERE  CompanyKey = @CompanyKey
				AND	   SummaryMasterTaskKey = @SummaryMasterTaskKey	    
				AND    Active = 1
				AND    TaskType = 2
				AND    MasterTaskKey > @TrackingMasterTaskKey
				AND    WorkOrder = @WorkOrder
							
				IF @TrackingMasterTaskKey IS NULL
					BREAK
				
				-- loop reset
				SELECT @CustomFieldKey = NULL
					,@TrackingMasterTaskTrackBudget = NULL
					  
				SELECT @CustomFieldKey = CustomFieldKey 		
					,@TrackingMasterTaskTrackBudget = TrackBudget
					,@TrackingMasterTaskMoneyTask = MoneyTask		
				FROM   tMasterTask (NOLOCK)
				WHERE CompanyKey = @CompanyKey
				AND    MasterTaskKey = @TrackingMasterTaskKey

				INSERT tTask
					(
					ProjectKey,
					TaskID,
					TaskName,
					Description,
					TaskType,
					SummaryTaskKey,
					BudgetTaskKey,
					HourlyRate,
					Markup,
					ShowDescOnEst,
					ShowEstimateDetail,
					RollupOnEstimate,
					RollupOnInvoice,
					Visibility,
					ServiceKey,
					DisplayOrder,
					Taxable,
					Taxable2,
					WorkTypeKey,
					PlanStart,
					PlanComplete,
					PlanDuration,
					ActStart,
					ActComplete,
					PercComp,
					TaskStatus,
					TaskConstraint,
					Comments,
					MasterTaskKey,
					ScheduleTask,
					TrackBudget,
					MoneyTask
					)

				SELECT
					@ProjectKey,
					tm.TaskID,
					tm.TaskName,
					tm.Description,
					2,
					@oIdentity, -- SummaryTaskKey
					NULL,			-- BudgetTaskKey temporary !!!
					tm.HourlyRate,
					tm.Markup,
					tm.ShowDescOnEst,
					0,
					0,
					0,
					3,
					0,
					@NewDisplayOrder,
					0,
					0,
					NULL,
					CONVERT(VARCHAR(10), GETDATE(), 101),
					CONVERT(VARCHAR(10), GETDATE(), 101),
					tm.PlanDuration,
					NULL,
					NULL,
					0,
					1,
					0,
					NULL,
					NULL, -- tm.MasterTaskKey, -- No master tasks on subtasks
					tm.ScheduleTask,
					0, -- tm.TrackBudget, temporary !!!
					0  -- tm.MoneyTask temporary !!!
				FROM tMasterTask tm (NOLOCK)
				WHERE MasterTaskKey = @TrackingMasterTaskKey				
				
				SELECT @TrackingTaskKey = @@IDENTITY

				INSERT #tMTTask(TaskKey, MasterTaskKey, WorkOrder)
				SELECT @TrackingTaskKey, @TrackingMasterTaskKey, @WorkOrder
				
				-- if we can track budget, apply the flags on the tracking master task
				IF @CanTrackBudget = 1
				BEGIN
					-- Always pickup flags from the tracking master task
					SELECT @TrackBudget = @TrackingMasterTaskTrackBudget
							,@MoneyTask = @TrackingMasterTaskMoneyTask

					-- Now determine BudgetTaskKey 
					IF @SummaryMasterTaskTrackBudget = 1
						SELECT @BudgetTaskKey = @oIdentity
					ELSE
					BEGIN
						IF @TrackingMasterTaskTrackBudget = 1
							SELECT @BudgetTaskKey = @TrackingTaskKey
						ELSE
							SELECT @BudgetTaskKey = NULL
					END
					
					UPDATE tTask 
					SET TrackBudget = @TrackBudget
						,MoneyTask = @MoneyTask
						,BudgetTaskKey = @BudgetTaskKey
					WHERE TaskKey = @TrackingTaskKey

				END
				
				-- Now set custom field on tracking task
				if ISNULL(@CustomFieldKey, 0) > 0
					EXEC sptTaskDetailCopyCF @TrackingTaskKey, @CustomFieldKey 
						
				SELECT @NewDisplayOrder = @NewDisplayOrder + 1	
			
			END -- End Tracking Master Task Key		
		
		END -- End WorkOrder loop
		
		-- Now establish predecessor relationships based on workorders
		SELECT @WorkOrder = -99999
		SELECT @OldWorkOrder = -99999
		WHILE (1=1)
		BEGIN
			SELECT @WorkOrder = MIN(WorkOrder)
			FROM   #tMTTask 
			WHERE  WorkOrder > @WorkOrder
			
			IF @WorkOrder IS NULL
				BREAK
			
			-- If not at the beginning
			IF @OldWorkOrder <> -99999
			BEGIN
				SELECT @TrackingMasterTaskKey = -1
				WHILE (1=1)
				BEGIN
					SELECT @TrackingMasterTaskKey = MIN(MasterTaskKey)
					FROM   #tMTTask (NOLOCK)
					WHERE  WorkOrder = @WorkOrder
					AND    MasterTaskKey > @TrackingMasterTaskKey
					
					IF @TrackingMasterTaskKey IS NULL
						BREAK
							
					SELECT @TrackingTaskKey = NULL
							
					SELECT @TrackingTaskKey = TaskKey
					FROM   #tMTTask
					WHERE  MasterTaskKey = @TrackingMasterTaskKey
					
					IF @TrackingTaskKey IS NOT NULL
						INSERT tTaskPredecessor (TaskKey, PredecessorKey, Lag, Type)
						SELECT @TrackingTaskKey, tm.TaskKey, 0, 'FS'
						FROM   #tMTTask tm (NOLOCK)
						WHERE  tm.WorkOrder = @OldWorkOrder
						
				END				
			END
		
			SELECT @OldWorkOrder = @WorkOrder
		END
		
		
		
	END -- End Master Task Key > 0
	
							
	RETURN 1
	




