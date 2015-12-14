USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectCopyTasksEntity]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectCopyTasksEntity]
	(
		@ProjectKey int,
		@CopyProjectKey int,
		@CopyEstimate tinyint = 0,
		@Entity varchar(50),
		@EntityKey int,		
		@UserKey int = null
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 03/22/10 GHL 10.521 Cloned sptProjectCopyTasks for opportunities
  ||                     Reading now tEstimateTaskTemp rather tTask 
  || 04/09/10 GHL 10.521 Copying now approval info from source to target estimate 
  || 04/22/10 GHL 10.521 Added support of tCampaignSegment entity
  ||
  ||                     Reason why we cloned sptProjectCopyTasks
  ||                     When a template project is specified, it may be stored in tEstimateTaskTemp
  ||                     So we need to read tEstimateTaskTemp OR tTask
  ||                     
  ||                     Currently only 2 entities are supported:
  ||                     1) tLead with OR without a project in tEstimateTaskTemp
  ||                     2) tCampaignSegment
  ||
  ||                     Here we do not copy estimates by service only or segment/service
  ||                     We only do here task only, task/service, task/user
  ||                     Reason is that if no project is selected, this sp is not called 
  ||                     so I had to create another sp to handle that case
  || 06/04/10 GHL 10.530 (82392) Added VendorKey when copying expenses (request by Ron Ause)
  || 06/09/10 GHL 10.531  Added support of task user records with UserKey = null
  || 07/23/10 GHL 10.532 (85993) Added Entity/EntityKey to where clause when reading tEstimateTaskTempPredecessor
  ||
  || 08/19/10 GHL 10.534 (87237 + 87571) The estimates for the entity should always be copied
  ||                     the estimates for the initial project should only be copied if CopyEstimate = 1
  ||                     The logic has now 2 loops for the estimates (must be in same stored proc to use the task Xref) and is:
  ||
  ||                     1) Copy tasks from tEstimateTaskTemp OR tTask
  ||                     2) Copy estimates from the entity using the task Xref table...always
  ||                     ...but only estimates of type = task only, task/service, task/user
  ||                     3) Copy estimates from the project using the task Xref table if CopyEstimate = 1  
  ||
  ||                      Note: Campain segments are not converted to projects anymore
  || 09/23/11 GHL 10.548  (120964) Added copying of tEstimateTaskLaborLevel
  || 10/11/11 RLB 10.549  (123384) Fixed copy project estimate getting created as approved
  || 11/4/11  GHL 10.5.4.9 (125561) Instead of deleting tEstimateTaskExpense recs, set TaskKey = null when deleting tasks
  || 01/29/13 GHL 10.5.6.4 (166383) In the case when there is no project in tEstimateTaskTemp, added in tTaskUser
  ||                       records where UserKey is null (roles only)
  || 04/30/15 GHL 10.5.9.1 (255095) Added copying of task's ToDos 
  */
  
	IF EXISTS (SELECT 1 FROM tTask (NOLOCK) WHERE ProjectKey = @ProjectKey)
		RETURN 1

	/* Move this to the place where we save tEstimateTaskTemp 
	IF EXISTS (SELECT 1 FROM tTask t (NOLOCK)
	           LEFT JOIN tTask tsum (NOLOCK) ON t.SummaryTaskKey = tsum.TaskKey
	           WHERE t.ProjectKey = @CopyProjectKey
	           AND   t.SummaryTaskKey <> 0
	           AND   ISNULL(tsum.ProjectKey, 0) <> @CopyProjectKey 
			   )
		RETURN -1		   
	
	IF EXISTS (SELECT 1 FROM tTask t (NOLOCK)
	           LEFT JOIN tTask tsum (NOLOCK) ON t.BudgetTaskKey = tsum.TaskKey
	           WHERE t.ProjectKey = @CopyProjectKey
	           AND   ISNULL(t.BudgetTaskKey, 0) <> 0
	           AND   ISNULL(tsum.ProjectKey, 0) <> @CopyProjectKey 
			   )
		RETURN -1	
	*/
				
	DECLARE @RequireMasterTask INT
	DECLARE @CompanyKey INT
	
	SELECT @CompanyKey = CompanyKey 
	FROM   tProject (NOLOCK)
	WHERE  ProjectKey = @CopyProjectKey 
	
	SELECT @RequireMasterTask = ISNULL(RequireMasterTask, 0)
	FROM   tPreference (NOLOCK)
	WHERE  CompanyKey = @CompanyKey 
	  
	IF @RequireMasterTask = 1 
	BEGIN
		IF EXISTS (SELECT 1
				FROM   tTask (NOLOCK)
				WHERE  tTask.ProjectKey = @CopyProjectKey
				AND    tTask.TrackBudget = 1
				AND    ISNULL(tTask.MasterTaskKey, 0) = 0)
				RETURN -10

	END

	DECLARE @TemporaryProject int
	IF EXISTS (SELECT 1 FROM tEstimateTaskTemp (NOLOCK)
		WHERE Entity = @Entity
		AND    EntityKey = @EntityKey
		) 
		SELECT @TemporaryProject = 1
	ELSE
		SELECT @TemporaryProject = 0
	
	
	-- Cross Reference old and new tasks
	-- This will be used for the Estimates as well
	CREATE TABLE #tTask (OldTaskKey int null, NewTaskKey int null)
	
	DECLARE @OldTaskKey INT
	        ,@NewTaskKey INT
	        ,@Error INT
	        ,@CustomFieldKey INT
			,@ObjectFieldSetKey int
			,@FieldSetKey int

IF @TemporaryProject = 1
BEGIN

	SELECT @OldTaskKey = -1
	
	-- Start a transaction, we cannot have corruption when saving tasks
	-- The other records do not need a transaction (best attempt)
	BEGIN TRAN
	
	WHILE (1=1)
	BEGIN
		SELECT @OldTaskKey = MIN(TaskKey)
		FROM   tEstimateTaskTemp (NOLOCK)
		WHERE  Entity = @Entity
		AND    EntityKey = @EntityKey
		AND    ProjectKey = @CopyProjectKey -- not necessary  now?
		AND    TaskKey > @OldTaskKey
		
		IF @OldTaskKey IS NULL
			BREAK
			
		INSERT tTask
			(
			ProjectKey,
			TaskID,
			TaskName,
			Description,
			TaskType,
			SummaryTaskKey,
			DisplayOrder,
			ProjectOrder,
			TaskLevel,
			HourlyRate,
			Markup,
			ShowDescOnEst,
			ShowEstimateDetail,
			RollupOnEstimate,
			RollupOnInvoice,
			Visibility,
			ServiceKey,
			Taxable,
			Taxable2,
			WorkTypeKey,
			PlanDuration,
			TaskConstraint,
			PlanStart,
			PlanComplete,
			ScheduleTask,
			MoneyTask,
			HideFromClient,
			AllowAnyone,
			-- New fields in 84
			TrackBudget,
			ConstraintDate,
			PercComp,
			PercCompSeparate,
			WorkAnyDay,
			TaskAssignmentTypeKey,
			ShowOnCalendar,
			EventStart,
			EventEnd,
			Priority,
			BudgetTaskKey,
			MasterTaskKey
			)
		SELECT
			@ProjectKey,
			TaskID,
			TaskName,
			Description,
			TaskType,
			ISNULL(SummaryTaskKey, 0),  -- Old one, needs to be converted 
			DisplayOrder,
			ProjectOrder,
			TaskLevel,
			HourlyRate,
			Markup,
			ShowDescOnEst,
			ShowEstimateDetail,
			RollupOnEstimate,
			RollupOnInvoice,
			Visibility,
			ServiceKey,
			Taxable,
			Taxable2,
			WorkTypeKey,
			PlanDuration,
			TaskConstraint, 
			CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101)),
			CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101)),
			ISNULL(ScheduleTask, 1),
			ISNULL(MoneyTask, 1),
			ISNULL(HideFromClient, 0),
			ISNULL(AllowAnyone, 0),
			-- New fields in 84
			ISNULL(TrackBudget,0),
			CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101)),
			0, -- PercComp
			PercCompSeparate,
			WorkAnyDay,
			TaskAssignmentTypeKey,
			ShowOnCalendar,
			EventStart,
			EventEnd,
			Priority,
			ISNULL(BudgetTaskKey, 0), -- Old one needs to be converted
			-- if not a Track Budget, set Master Task to null
			-- in case it is disassociated and user tries TrackBudget = 1 later
			CASE WHEN ISNULL(TrackBudget, 0) = 0 THEN NULL  
			ELSE MasterTaskKey
			END
		FROM tEstimateTaskTemp (NOLOCK)
		WHERE Entity = @Entity
		AND   EntityKey = @EntityKey
		AND   ProjectKey = @CopyProjectKey
		AND   TaskKey = @OldTaskKey			
	
		SELECT @NewTaskKey = @@IDENTITY, @Error = @@ERROR
		
		IF @Error <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -1
		END
		
		INSERT #tTask (OldTaskKey, NewTaskKey)
		SELECT @OldTaskKey, @NewTaskKey
		
		-- CustomFieldKeys
		SELECT @CustomFieldKey = CustomFieldKey
		FROM tEstimateTaskTemp (NOLOCK)
		WHERE Entity = @Entity
		AND   EntityKey = @EntityKey
		AND   ProjectKey = @CopyProjectKey
		AND   TaskKey = @OldTaskKey			
	
		IF ISNULL(@CustomFieldKey,0) > 0
        BEGIN
			SELECT	@FieldSetKey = FieldSetKey
			FROM	tObjectFieldSet
			WHERE	ObjectFieldSetKey = @CustomFieldKey
			
			EXEC spCF_tObjectFieldSetInsert @FieldSetKey, @ObjectFieldSetKey OUTPUT
			
			IF ISNULL(@ObjectFieldSetKey,0) > 0
				INSERT	tFieldValue
						(FieldValueKey, FieldDefKey, ObjectFieldSetKey, FieldValue)
				SELECT	newid(), FieldDefKey, @ObjectFieldSetKey, FieldValue
				FROM	tFieldValue
				WHERE	ObjectFieldSetKey = @CustomFieldKey
        END
		ELSE
			SELECT @ObjectFieldSetKey = NULL	

		IF ISNULL(@ObjectFieldSetKey,0) > 0
		BEGIN
			UPDATE tTask
			SET    CustomFieldKey = @ObjectFieldSetKey
			WHERE  TaskKey = @NewTaskKey
			
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				RETURN -1
			END				
			
		END
	
		--Copy over the activities for the task
		EXEC sptActivityCopyFromTask @CopyProjectKey, @OldTaskKey, @ProjectKey, @NewTaskKey, @UserKey

	END -- loop on task
	
	-- Now update the SummaryTaskKey
	UPDATE tTask
	SET    tTask.SummaryTaskKey = b.NewTaskKey 
	FROM   #tTask b
	WHERE  tTask.ProjectKey = @ProjectKey
	AND    tTask.SummaryTaskKey > 0
	AND    tTask.SummaryTaskKey = b.OldTaskKey
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
		
	-- Now update the BudgetTaskKey
	UPDATE tTask
	SET    tTask.BudgetTaskKey = b.NewTaskKey 
	FROM   #tTask b
	WHERE  tTask.ProjectKey = @ProjectKey
	AND    tTask.BudgetTaskKey > 0
	AND    tTask.BudgetTaskKey = b.OldTaskKey
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
		
	COMMIT TRAN
	
	-- Copy the predecessors
	Insert tTaskPredecessor (TaskKey, PredecessorKey, Type, Lag)
	Select t.NewTaskKey, tpt.NewTaskKey, tp.Type, tp.Lag
	From   tEstimateTaskTempPredecessor tp (NOLOCK)
		Inner Join #tTask t (NOLOCK) ON tp.TaskKey = t.OldTaskKey
		Inner Join #tTask tpt (NOLOCK) ON tp.PredecessorKey = tpt.OldTaskKey
	WHERE tp.Entity = @Entity
	AND   tp.EntityKey = @EntityKey
				
    -- we could also read tEstimateTaskTempUser
	-- Copy users		
	INSERT tTaskUser (TaskKey, UserKey, ServiceKey, Hours, PercComp, ActStart, ActComplete )
	SELECT b.NewTaskKey, old_tu.UserKey, old_tu.ServiceKey, old_tu.Hours, 0, NULL ,NULL  
	FROM   tTaskUser old_tu (nolock)
		INNER JOIN #tTask b on old_tu.TaskKey = b.OldTaskKey
		INNER JOIN tUser old_u (nolock) on old_tu.UserKey = old_u.UserKey
	WHERE old_u.Active = 1	

	-- Copy services
	INSERT tTaskUser (TaskKey, UserKey, ServiceKey, Hours, PercComp, ActStart, ActComplete )
	SELECT b.NewTaskKey, old_tu.UserKey, old_tu.ServiceKey, old_tu.Hours, 0, NULL ,NULL  
	FROM   tTaskUser old_tu (nolock)
		INNER JOIN #tTask b on old_tu.TaskKey = b.OldTaskKey
	WHERE old_tu.UserKey is null	

END -- end temporary project section

ELSE

BEGIN
-- This is a real project so go after tTask rather than tEstimateTaskTemp

	SELECT @OldTaskKey = -1
	
	-- Start a transaction, we cannot have corruption when saving tasks
	-- The other records do not need a transaction (best attempt)
	BEGIN TRAN
	
	WHILE (1=1)
	BEGIN
		SELECT @OldTaskKey = MIN(TaskKey)
		FROM   tTask (NOLOCK)
		WHERE  ProjectKey = @CopyProjectKey
		AND    TaskKey > @OldTaskKey
		
		IF @OldTaskKey IS NULL
			BREAK
			
		INSERT tTask
			(
			ProjectKey,
			TaskID,
			TaskName,
			Description,
			TaskType,
			SummaryTaskKey,
			DisplayOrder,
			ProjectOrder,
			TaskLevel,
			HourlyRate,
			Markup,
			ShowDescOnEst,
			ShowEstimateDetail,
			RollupOnEstimate,
			RollupOnInvoice,
			Visibility,
			ServiceKey,
			Taxable,
			Taxable2,
			WorkTypeKey,
			PlanDuration,
			TaskConstraint,
			PlanStart,
			PlanComplete,
			ScheduleTask,
			MoneyTask,
			HideFromClient,
			AllowAnyone,
			-- New fields in 84
			TrackBudget,
			ConstraintDate,
			PercComp,
			PercCompSeparate,
			WorkAnyDay,
			TaskAssignmentTypeKey,
			ShowOnCalendar,
			EventStart,
			EventEnd,
			Priority,
			BudgetTaskKey,
			MasterTaskKey
			)
		SELECT
			@ProjectKey,
			TaskID,
			TaskName,
			Description,
			TaskType,
			ISNULL(SummaryTaskKey, 0),  -- Old one, needs to be converted 
			DisplayOrder,
			ProjectOrder,
			TaskLevel,
			HourlyRate,
			Markup,
			ShowDescOnEst,
			ShowEstimateDetail,
			RollupOnEstimate,
			RollupOnInvoice,
			Visibility,
			ServiceKey,
			Taxable,
			Taxable2,
			WorkTypeKey,
			PlanDuration,
			TaskConstraint, 
			CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101)),
			CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101)),
			ISNULL(ScheduleTask, 1),
			ISNULL(MoneyTask, 1),
			ISNULL(HideFromClient, 0),
			ISNULL(AllowAnyone, 0),
			-- New fields in 84
			ISNULL(TrackBudget,0),
			CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101)),
			0, -- PercComp
			PercCompSeparate,
			WorkAnyDay,
			TaskAssignmentTypeKey,
			ShowOnCalendar,
			EventStart,
			EventEnd,
			Priority,
			ISNULL(BudgetTaskKey, 0), -- Old one needs to be converted
			-- if not a Track Budget, set Master Task to null
			-- in case it is disassociated and user tries TrackBudget = 1 later
			CASE WHEN ISNULL(TrackBudget, 0) = 0 THEN NULL  
			ELSE MasterTaskKey
			END
		FROM tTask (NOLOCK)
		WHERE ProjectKey = @CopyProjectKey
		AND   TaskKey = @OldTaskKey			
	
		SELECT @NewTaskKey = @@IDENTITY, @Error = @@ERROR
		
		IF @Error <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -1
		END
		
		INSERT #tTask (OldTaskKey, NewTaskKey)
		SELECT @OldTaskKey, @NewTaskKey
		
		-- CustomFieldKeys
		SELECT @CustomFieldKey = CustomFieldKey
		FROM tTask (NOLOCK)
		WHERE ProjectKey = @CopyProjectKey
		AND   TaskKey = @OldTaskKey			
	
		IF ISNULL(@CustomFieldKey,0) > 0
		   BEGIN
				SELECT	@FieldSetKey = FieldSetKey
				FROM	tObjectFieldSet
				WHERE	ObjectFieldSetKey = @CustomFieldKey
			
				EXEC spCF_tObjectFieldSetInsert @FieldSetKey, @ObjectFieldSetKey OUTPUT
			
				IF ISNULL(@ObjectFieldSetKey,0) > 0
					INSERT	tFieldValue
							(FieldValueKey, FieldDefKey, ObjectFieldSetKey, FieldValue)
					SELECT	newid(), FieldDefKey, @ObjectFieldSetKey, FieldValue
					FROM	tFieldValue
					WHERE	ObjectFieldSetKey = @CustomFieldKey
			END
		ELSE
			SELECT @ObjectFieldSetKey = NULL	

		IF ISNULL(@ObjectFieldSetKey,0) > 0
		BEGIN
			UPDATE tTask
			SET    CustomFieldKey = @ObjectFieldSetKey
			WHERE  TaskKey = @NewTaskKey
			
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				RETURN -1
			END				
			
		END
	
		--Copy over the activities for the task
		EXEC sptActivityCopyFromTask @CopyProjectKey, @OldTaskKey, @ProjectKey, @NewTaskKey, @UserKey

	END
	
	-- Now update the SummaryTaskKey
	UPDATE tTask
	SET    tTask.SummaryTaskKey = b.NewTaskKey 
	FROM   #tTask b
	WHERE  tTask.ProjectKey = @ProjectKey
	AND    tTask.SummaryTaskKey > 0
	AND    tTask.SummaryTaskKey = b.OldTaskKey
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
		
	-- Now update the BudgetTaskKey
	UPDATE tTask
	SET    tTask.BudgetTaskKey = b.NewTaskKey 
	FROM   #tTask b
	WHERE  tTask.ProjectKey = @ProjectKey
	AND    tTask.BudgetTaskKey > 0
	AND    tTask.BudgetTaskKey = b.OldTaskKey
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
		
	COMMIT TRAN
	
	-- Copy the predecessors
	Insert tTaskPredecessor (TaskKey, PredecessorKey, Type, Lag)
	Select t.NewTaskKey, tpt.NewTaskKey, tp.Type, tp.Lag
	From   tTaskPredecessor tp (NOLOCK)
		Inner Join #tTask t (NOLOCK) ON tp.TaskKey = t.OldTaskKey
		Inner Join #tTask tpt (NOLOCK) ON tp.PredecessorKey = tpt.OldTaskKey

	-- Copy Users if Active
	INSERT tTaskUser (TaskKey, UserKey, ServiceKey, Hours, PercComp, ActStart, ActComplete )
	SELECT b.NewTaskKey, old_tu.UserKey, old_tu.ServiceKey, old_tu.Hours, 0, NULL ,NULL  
	FROM   tTaskUser old_tu (nolock)
		INNER JOIN #tTask b on old_tu.TaskKey = b.OldTaskKey
		INNER JOIN tUser old_u (nolock) on old_tu.UserKey = old_u.UserKey
	WHERE old_u.Active = 1	

	-- Copy services
	INSERT tTaskUser (TaskKey, UserKey, ServiceKey, Hours, PercComp, ActStart, ActComplete )
	SELECT b.NewTaskKey, old_tu.UserKey, old_tu.ServiceKey, old_tu.Hours, 0, NULL ,NULL  
	FROM   tTaskUser old_tu (nolock)
		INNER JOIN #tTask b on old_tu.TaskKey = b.OldTaskKey
	WHERE old_tu.UserKey is null	

END -- real project section





		 				
	-- Add the assignments to the project
	Declare @aUserKey int
	Select @aUserKey = -1
	While 1=1
	BEGIN
		Select @aUserKey = Min(ta.UserKey) 
		from tTaskUser ta (NOLOCK)
			inner join tTask t (NOLOCK) on t.TaskKey = ta.TaskKey
			inner join tUser u (nolock) on ta.UserKey = u.UserKey
		Where t.ProjectKey = @ProjectKey 
		AND ta.UserKey > @aUserKey
		AND u.Active = 1
		
		if @aUserKey is null
			Break

		exec sptAssignmentInsert @ProjectKey, @aUserKey, NULL

	END

	/*
	Removed on 8/19/10 because estimates for the entity ALWAYS have to be copied
	issues 87237 + 87571

	IF @CopyEstimate = 0
		Return 1
	
	-- If there are segment, I know that there is no task involved
	IF @Entity = 'tCampaignSegment'
		Return 1

	-- at this point, only tLead / opps is supported
	*/
	
	DECLARE @OldEstimateKey int
	       ,@EstimateName VARCHAR(100)
	       ,@EstimateNumber VARCHAR(50)
	       ,@Revision INT
	       ,@NewEstimateKey INT
	       ,@RetVal INT

	
	SELECT @OldEstimateKey = -1
	WHILE (1=1)
	BEGIN
		IF @Entity = 'tLead'
			SELECT @OldEstimateKey = MIN(EstimateKey)
			FROM   tEstimate (NOLOCK)
			Where  LeadKey = @EntityKey 
			AND    EstimateKey > @OldEstimateKey
			AND    EstType in (1, 2, 3) -- just Task Only, Task/Service, Task/Person 
			 
		-- can other entities later
				
		IF @OldEstimateKey IS NULL
			BREAK
		
		EXEC sptEstimateGetNextEstimateNum
			@CompanyKey,
			@ProjectKey,
			NULL, -- campaign
			NULL, -- lead
			@RetVal OUTPUT,
			@EstimateNumber OUTPUT
					
		INSERT tEstimate
				(
				CompanyKey,
				ProjectKey,
				EstimateName,
				EstimateNumber,
				EstimateDate,
				DeliveryDate,
				Revision,
				EstType,
				EstDescription,
				EstimateTemplateKey,
				SalesTaxKey,
				SalesTaxAmount,
				SalesTax2Key,
				SalesTax2Amount,
				LaborTaxable,
				Contingency,
				ChangeOrder,
				
				InternalApprover,
				InternalStatus,
				InternalApproval,
				InternalComments,
				InternalDueDate,
				
				ExternalApprover,
				ExternalStatus,
				ExternalApproval,
				ExternalComments,
				ExternalDueDate,
				
				MultipleQty,
				ApprovedQty,
				Expense1,
				Expense2,
				Expense3,
				Expense4,
				Expense5,
				Expense6,
				EnteredBy,
				DateAdded,
				UseRateLevel
				)

			SELECT
				@CompanyKey,
				@ProjectKey,
				e.EstimateName,						-- @EstimateName,
				@EstimateNumber,
				CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101)),
				CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101)),
				e.Revision,							-- @Revision,
				e.EstType,							-- @EstType,
				e.EstDescription,					-- @EstDescription,
				e.EstimateTemplateKey,				-- @EstimateTemplateKey,
				e.SalesTaxKey,						-- @SalesTaxKey,
				e.SalesTaxAmount,					-- @SalesTax amount
				e.SalesTax2Key,						-- @SalesTax2Key,
				e.SalesTax2Amount,					-- @SalesTax2 amount
				e.LaborTaxable,						-- @LaborTaxable,
				e.Contingency,						-- @Contingency,		
				e.ChangeOrder,						-- @ChangeOrder,
				
				e.InternalApprover,					-- @InternalApprover,
				e.InternalStatus,					-- @InternalStatus
				e.InternalApproval,					-- @InternalApproval
				e.InternalComments,					-- @InternalComments
				e.InternalDueDate,					-- @InternalDueDate
				
				e.ExternalApprover,					-- @ExternalApprover,
				e.ExternalStatus,					-- @ExternalStatus
				e.ExternalApproval,					-- @ExternalApproval
				e.ExternalComments,					-- @ExternalComments
				e.ExternalDueDate,					-- @ExternalDueDate
				
				e.MultipleQty,						-- @MultipleQty,
				e.ApprovedQty,						-- @ApprovedQty,
				e.Expense1,							-- @Expense1,
				e.Expense2,							-- @Expense2,
				e.Expense3,							-- @Expense3,
				e.Expense4,							-- @Expense4,
				e.Expense5,							-- @Expense5,
				e.Expense6,							-- @Expense6,
				isnull(@UserKey, e.EnteredBy),		-- @EnteredBy
				GETUTCDATE(),
				UseRateLevel				
		FROM tEstimate e (NOLOCK) 
		Where e.EstimateKey = @OldEstimateKey		
		
		SELECT @NewEstimateKey = @@IDENTITY

		INSERT tEstimateTask
			(
			EstimateKey,
			TaskKey,
			Hours,
			Rate,
			EstLabor,
			BudgetExpenses,
			Markup,
			EstExpenses,
			Cost			-- Added in 7.9
			)
		SELECT
			@NewEstimateKey,
			b.NewTaskKey,
			et.Hours,
			et.Rate,
			et.EstLabor,
			et.BudgetExpenses,
			et.Markup,
			et.EstExpenses,
			et.Cost
		FROM 
			tEstimateTask et (NOLOCK),
			#tTask b (NOLOCK)
		WHERE 
			et.EstimateKey  = @OldEstimateKey AND 
			et.TaskKey = b.OldTaskKey


		INSERT tEstimateUser
			(
			EstimateKey,
			UserKey,
			BillingRate
			)
		SELECT
			@NewEstimateKey,
			eu.UserKey,
			eu.BillingRate
		FROM
			tEstimateUser eu (NOLOCK)
		WHERE
			eu.EstimateKey = @OldEstimateKey

		INSERT tEstimateNotify		-- Added in 7.9 
			(EstimateKey
			, UserKey)
		Select
			@NewEstimateKey,
			UserKey
		from tEstimateNotify
      		where EstimateKey = @OldEstimateKey
	      	
		Select @aUserKey = -1
		While 1=1
		BEGIN
			Select @aUserKey = Min(eu.UserKey) 
			from tEstimateUser eu (NOLOCK)
			inner join tUser u (nolock) on eu.UserKey = u.UserKey
			Where eu.EstimateKey = @NewEstimateKey 
			AND	eu.UserKey > @aUserKey
			AND u.Active = 1
	
			if @aUserKey is null
				Break
	
			exec sptAssignmentInsert @ProjectKey, @aUserKey, NULL
	
		END

		-- copy straight from tEstimateTaskLabor
		
		INSERT tEstimateTaskLabor
			(
			EstimateKey,
			TaskKey,
			ServiceKey,
			UserKey,
			Hours,
			Rate,
			Cost	-- Added in 7.9
			)
		SELECT
			@NewEstimateKey,
			etl.TaskKey,
			etl.ServiceKey,
			etl.UserKey,
			etl.Hours,
			etl.Rate,
			etl.Cost
		FROM
			tEstimateTaskLabor etl (nolock)
		WHERE
			etl.EstimateKey = @OldEstimateKey 		
				
			
		-- then correct tasks
		UPDATE tEstimateTaskLabor
		SET    tEstimateTaskLabor.TaskKey = b.NewTaskKey
		FROM   #tTask b (NOLOCK)
		WHERE  tEstimateTaskLabor.EstimateKey = @NewEstimateKey 
		AND	   tEstimateTaskLabor.TaskKey = b.OldTaskKey
		
		INSERT tEstimateTaskLaborLevel
			(
			EstimateKey,
			TaskKey,
			ServiceKey,
			RateLevel,
			Hours,
			Rate
			)
		SELECT
			@NewEstimateKey,
			b.NewTaskKey,
			etl.ServiceKey,
			etl.RateLevel,
			etl.Hours,
			etl.Rate
		FROM
			tEstimateTaskLaborLevel etl (nolock),
			#tTask b (NOLOCK)
		WHERE
			etl.EstimateKey = @OldEstimateKey AND
			etl.TaskKey = b.OldTaskKey AND 
			etl.TaskKey is not null

		INSERT tEstimateTaskLaborLevel
			(
			EstimateKey,
			TaskKey,
			ServiceKey,
			RateLevel,
			Hours,
			Rate	
			)
		SELECT
			@NewEstimateKey,
			etl.TaskKey,
			etl.ServiceKey,
			etl.RateLevel,
			etl.Hours,
			etl.Rate
		FROM
			tEstimateTaskLaborLevel etl (nolock)
		WHERE
			etl.EstimateKey = @OldEstimateKey 
		AND 
			etl.TaskKey IS NULL

		INSERT tEstimateTaskAssignmentLabor		
				(
				EstimateKey,
				TaskKey,
				ServiceKey,
				UserKey,
				Hours,
				Rate
				)
			SELECT
				@NewEstimateKey,
				etl.TaskKey,
				etl.ServiceKey,
				etl.UserKey,
				etl.Hours,
				etl.Rate
			FROM
				tEstimateTaskAssignmentLabor etl (nolock)
			WHERE
				etl.EstimateKey = @OldEstimateKey 

		UPDATE tEstimateTaskAssignmentLabor
		SET    tEstimateTaskAssignmentLabor.TaskKey = b.NewTaskKey
		FROM   #tTask b (NOLOCK)
		WHERE  tEstimateTaskAssignmentLabor.EstimateKey = @NewEstimateKey 
		AND	   tEstimateTaskAssignmentLabor.TaskKey = b.OldTaskKey
			
		Insert tEstimateService ( EstimateKey, ServiceKey, Rate )
		Select @NewEstimateKey, ServiceKey, Rate
		from tEstimateService (nolock) Where EstimateKey = @OldEstimateKey
												
		INSERT tEstimateTaskExpense
				(
				EstimateKey,
				TaskKey,
				ItemKey,
				ShortDescription,
				LongDescription,
				Taxable,
				Taxable2,
				VendorKey, -- At Ron Ause's request

				Quantity,
				UnitCost,
				UnitDescription,
				TotalCost,
				Billable,
				Markup,
				BillableCost,

				Quantity2,
				UnitCost2,
				UnitDescription2,
				TotalCost2,
				Markup2,
				BillableCost2,
				
				Quantity3,
				UnitCost3,
				UnitDescription3,
				TotalCost3,
				Markup3,
				BillableCost3,

				Quantity4,
				UnitCost4,
				UnitDescription4,
				TotalCost4,
				Markup4,
				BillableCost4,

				Quantity5,
				UnitCost5,
				UnitDescription5,
				TotalCost5,
				Markup5,
				BillableCost5,

				Quantity6,
				UnitCost6,
				UnitDescription6,
				TotalCost6,
				Markup6,
				BillableCost6,

                DisplayOrder
				)

			SELECT
				@NewEstimateKey,
				ete.TaskKey,
				ete.ItemKey,
				ete.ShortDescription,
				ete.LongDescription,
				ete.Taxable,
				ete.Taxable2,
				ete.VendorKey, -- At Ron Ause's request

				ete.Quantity,
				ete.UnitCost,
				ete.UnitDescription,
				ete.TotalCost,
				ete.Billable,
				ete.Markup,
				ete.BillableCost,

				ete.Quantity2,
				ete.UnitCost2,
				ete.UnitDescription2,
				ete.TotalCost2,
				ete.Markup2,
				ete.BillableCost2,
				
				ete.Quantity3,
				ete.UnitCost3,
				ete.UnitDescription3,
				ete.TotalCost3,
				ete.Markup3,
				ete.BillableCost3,

				ete.Quantity4,
				ete.UnitCost4,
				ete.UnitDescription4,
				ete.TotalCost4,
				ete.Markup4,
				ete.BillableCost4,

				ete.Quantity5,
				ete.UnitCost5,
				ete.UnitDescription5,
				ete.TotalCost5,
				ete.Markup5,
				ete.BillableCost5,

				ete.Quantity6,
				ete.UnitCost6,
				ete.UnitDescription6,
				ete.TotalCost6,
				ete.Markup6,
				ete.BillableCost6,
				
				ete.DisplayOrder

		FROM 
			tEstimateTaskExpense ete (NOLOCK)
		WHERE ete.EstimateKey  = @OldEstimateKey

		
		UPDATE tEstimateTaskExpense
		SET    tEstimateTaskExpense.TaskKey = b.NewTaskKey
		FROM   #tTask b (NOLOCK)
		WHERE  tEstimateTaskExpense.EstimateKey = @NewEstimateKey 
		AND	   tEstimateTaskExpense.TaskKey = b.OldTaskKey
			
		-- EXEC sptEstimateRecalcRates @NewEstimateKey
		Exec sptEstimateTaskRollupDetail @NewEstimateKey
		
	END -- Estimate loop

	-- now if user does not want to copy the estimates for the PROJECT, exit
	IF @CopyEstimate = 0
	Return 1

	-- copy the estimates from the original project 
	
	SELECT @OldEstimateKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @OldEstimateKey = MIN(EstimateKey)
		FROM   tEstimate (NOLOCK)
		Where  ProjectKey = @CopyProjectKey 
		And    EstimateKey >  @OldEstimateKey
						
		IF @OldEstimateKey IS NULL
			BREAK
		
		EXEC sptEstimateGetNextEstimateNum
			@CompanyKey,
			@ProjectKey,
			NULL, -- campaign
			NULL, -- lead
			@RetVal OUTPUT,
			@EstimateNumber OUTPUT
					
		INSERT tEstimate
				(
				CompanyKey,
				ProjectKey,
				EstimateName,
				EstimateNumber,
				EstimateDate,
				DeliveryDate,
				Revision,
				EstType,
				EstDescription,
				EstimateTemplateKey,
				SalesTaxKey,
				SalesTaxAmount,
				SalesTax2Key,
				SalesTax2Amount,
				LaborTaxable,
				Contingency,
				ChangeOrder,
				
				InternalApprover,
				InternalStatus,
				InternalApproval,
				InternalComments,
				
				ExternalApprover,
				ExternalStatus,
				ExternalComments,
				
				MultipleQty,
				ApprovedQty,
				Expense1,
				Expense2,
				Expense3,
				Expense4,
				Expense5,
				Expense6,
				EnteredBy,
				DateAdded
				)

			SELECT
				@CompanyKey,
				@ProjectKey,
				e.EstimateName,						-- @EstimateName,
				@EstimateNumber,
				CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101)),
				CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101)),
				e.Revision,							-- @Revision,
				e.EstType,							-- @EstType,
				e.EstDescription,					-- @EstDescription,
				e.EstimateTemplateKey,				-- @EstimateTemplateKey,
				e.SalesTaxKey,						-- @SalesTaxKey,
				e.SalesTaxAmount,					-- @SalesTax amount
				e.SalesTax2Key,						-- @SalesTax2Key,
				e.SalesTax2Amount,					-- @SalesTax2 amount
				e.LaborTaxable,						-- @LaborTaxable,
				e.Contingency,						-- @Contingency,		
				e.ChangeOrder,						-- @ChangeOrder,
				
				isnull(p.AccountManager, e.InternalApprover),				-- @InternalApprover,
				1,						            -- @InternalStatus
				NULL,           					-- @InternalApproval
				NULL,				                -- @InternalComments
				
				0,				                    -- @ExternalApprover,
				1,					                -- @ExternalStatus
				NULL,								-- @ExternalComments
				
				e.MultipleQty,						-- @MultipleQty,
				e.ApprovedQty,						-- @ApprovedQty,
				e.Expense1,							-- @Expense1,
				e.Expense2,							-- @Expense2,
				e.Expense3,							-- @Expense3,
				e.Expense4,							-- @Expense4,
				e.Expense5,							-- @Expense5,
				e.Expense6,							-- @Expense6,
				isnull(@UserKey, e.EnteredBy),		-- @EnteredBy
				GETUTCDATE()				
		FROM tEstimate e (NOLOCK)
		INNER JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey 
		Where e.EstimateKey = @OldEstimateKey		
		
		SELECT @NewEstimateKey = @@IDENTITY

		INSERT tEstimateTask
			(
			EstimateKey,
			TaskKey,
			Hours,
			Rate,
			EstLabor,
			BudgetExpenses,
			Markup,
			EstExpenses,
			Cost			-- Added in 7.9
			)
		SELECT
			@NewEstimateKey,
			b.NewTaskKey,
			et.Hours,
			et.Rate,
			et.EstLabor,
			et.BudgetExpenses,
			et.Markup,
			et.EstExpenses,
			et.Cost
		FROM 
			tEstimateTask et (NOLOCK),
			#tTask b (NOLOCK)
		WHERE 
			et.EstimateKey  = @OldEstimateKey AND 
			et.TaskKey = b.OldTaskKey


		INSERT tEstimateUser
			(
			EstimateKey,
			UserKey,
			BillingRate
			)
		SELECT
			@NewEstimateKey,
			eu.UserKey,
			eu.BillingRate
		FROM
			tEstimateUser eu (NOLOCK)
		WHERE
			eu.EstimateKey = @OldEstimateKey

		INSERT tEstimateNotify		-- Added in 7.9 
			(EstimateKey
			, UserKey)
		Select
			@NewEstimateKey,
			UserKey
		from tEstimateNotify
      		where EstimateKey = @OldEstimateKey
	      	
		Select @aUserKey = -1
		While 1=1
		BEGIN
			Select @aUserKey = Min(eu.UserKey) 
			from tEstimateUser eu (NOLOCK)
			inner join tUser u (nolock) on eu.UserKey = u.UserKey
			Where eu.EstimateKey = @NewEstimateKey 
			AND	eu.UserKey > @aUserKey
			AND u.Active = 1
	
			if @aUserKey is null
				Break
	
			exec sptAssignmentInsert @ProjectKey, @aUserKey, NULL
	
		END

		-- copy straight from tEstimateTaskLabor
		
		INSERT tEstimateTaskLabor
			(
			EstimateKey,
			TaskKey,
			ServiceKey,
			UserKey,
			Hours,
			Rate,
			Cost	-- Added in 7.9
			)
		SELECT
			@NewEstimateKey,
			etl.TaskKey,
			etl.ServiceKey,
			etl.UserKey,
			etl.Hours,
			etl.Rate,
			etl.Cost
		FROM
			tEstimateTaskLabor etl (nolock)
		WHERE
			etl.EstimateKey = @OldEstimateKey 		
				
			
		-- then correct tasks
		UPDATE tEstimateTaskLabor
		SET    tEstimateTaskLabor.TaskKey = b.NewTaskKey
		FROM   #tTask b (NOLOCK)
		WHERE  tEstimateTaskLabor.EstimateKey = @NewEstimateKey 
		AND	   tEstimateTaskLabor.TaskKey = b.OldTaskKey
		
	
		INSERT tEstimateTaskAssignmentLabor		
				(
				EstimateKey,
				TaskKey,
				ServiceKey,
				UserKey,
				Hours,
				Rate
				)
			SELECT
				@NewEstimateKey,
				etl.TaskKey,
				etl.ServiceKey,
				etl.UserKey,
				etl.Hours,
				etl.Rate
			FROM
				tEstimateTaskAssignmentLabor etl (nolock)
			WHERE
				etl.EstimateKey = @OldEstimateKey 

		UPDATE tEstimateTaskAssignmentLabor
		SET    tEstimateTaskAssignmentLabor.TaskKey = b.NewTaskKey
		FROM   #tTask b (NOLOCK)
		WHERE  tEstimateTaskAssignmentLabor.EstimateKey = @NewEstimateKey 
		AND	   tEstimateTaskAssignmentLabor.TaskKey = b.OldTaskKey
			
		Insert tEstimateService ( EstimateKey, ServiceKey, Rate )
		Select @NewEstimateKey, ServiceKey, Rate
		from tEstimateService (nolock) Where EstimateKey = @OldEstimateKey
												
		INSERT tEstimateTaskExpense
				(
				EstimateKey,
				TaskKey,
				ItemKey,
				ShortDescription,
				LongDescription,
				Taxable,
				Taxable2,
				VendorKey, -- At Ron Ause's request

				Quantity,
				UnitCost,
				UnitDescription,
				TotalCost,
				Billable,
				Markup,
				BillableCost,

				Quantity2,
				UnitCost2,
				UnitDescription2,
				TotalCost2,
				Markup2,
				BillableCost2,
				
				Quantity3,
				UnitCost3,
				UnitDescription3,
				TotalCost3,
				Markup3,
				BillableCost3,

				Quantity4,
				UnitCost4,
				UnitDescription4,
				TotalCost4,
				Markup4,
				BillableCost4,

				Quantity5,
				UnitCost5,
				UnitDescription5,
				TotalCost5,
				Markup5,
				BillableCost5,

				Quantity6,
				UnitCost6,
				UnitDescription6,
				TotalCost6,
				Markup6,
				BillableCost6,

                DisplayOrder
				)

			SELECT
				@NewEstimateKey,
				ete.TaskKey,
				ete.ItemKey,
				ete.ShortDescription,
				ete.LongDescription,
				ete.Taxable,
				ete.Taxable2,
				ete.VendorKey, -- At Ron Ause's request

				ete.Quantity,
				ete.UnitCost,
				ete.UnitDescription,
				ete.TotalCost,
				ete.Billable,
				ete.Markup,
				ete.BillableCost,

				ete.Quantity2,
				ete.UnitCost2,
				ete.UnitDescription2,
				ete.TotalCost2,
				ete.Markup2,
				ete.BillableCost2,
				
				ete.Quantity3,
				ete.UnitCost3,
				ete.UnitDescription3,
				ete.TotalCost3,
				ete.Markup3,
				ete.BillableCost3,

				ete.Quantity4,
				ete.UnitCost4,
				ete.UnitDescription4,
				ete.TotalCost4,
				ete.Markup4,
				ete.BillableCost4,

				ete.Quantity5,
				ete.UnitCost5,
				ete.UnitDescription5,
				ete.TotalCost5,
				ete.Markup5,
				ete.BillableCost5,

				ete.Quantity6,
				ete.UnitCost6,
				ete.UnitDescription6,
				ete.TotalCost6,
				ete.Markup6,
				ete.BillableCost6,
				
				ete.DisplayOrder

		FROM 
			tEstimateTaskExpense ete (NOLOCK)
		WHERE ete.EstimateKey  = @OldEstimateKey

		
		UPDATE tEstimateTaskExpense
		SET    tEstimateTaskExpense.TaskKey = b.NewTaskKey
		FROM   #tTask b (NOLOCK)
		WHERE  tEstimateTaskExpense.EstimateKey = @NewEstimateKey 
		AND	   tEstimateTaskExpense.TaskKey = b.OldTaskKey
			
		-- EXEC sptEstimateRecalcRates @NewEstimateKey
		Exec sptEstimateTaskRollupDetail @NewEstimateKey
		
	END -- Estimate loop
	
	--safer to do this in case the project template has changed after it was placed on the opportunity/entity
	
	delete tEstimateTask
	from   tEstimate e (nolock)
	where  e.ProjectKey = @ProjectKey
	and    e.EstimateKey = tEstimateTask.EstimateKey
	and    tEstimateTask.TaskKey is not null
	and    tEstimateTask.TaskKey not in (select NewTaskKey from #tTask) 

	delete tEstimateTaskLabor
	from   tEstimate e (nolock)
	where  e.ProjectKey = @ProjectKey
	and    e.EstimateKey = tEstimateTaskLabor.EstimateKey
	and    tEstimateTaskLabor.TaskKey is not null
	and    tEstimateTaskLabor.TaskKey not in (select NewTaskKey from #tTask) 

	delete tEstimateTaskAssignmentLabor
	from   tEstimate e (nolock)
	where  e.ProjectKey = @ProjectKey
	and    e.EstimateKey = tEstimateTaskAssignmentLabor.EstimateKey
	and    tEstimateTaskAssignmentLabor.TaskKey is not null
	and    tEstimateTaskAssignmentLabor.TaskKey not in (select NewTaskKey from #tTask) 
	
	declare @RequireTasks int

	select @RequireTasks = pref.RequireTasks 
	from tPreference pref (nolock)
	inner join tProject p (nolock) on p.CompanyKey = pref.CompanyKey 
	where p.ProjectKey = @ProjectKey 

	if isnull(@RequireTasks, 0) = 1
		delete tEstimateTaskExpense
		from   tEstimate e (nolock)
		where  e.ProjectKey = @ProjectKey
		and    e.EstimateKey = tEstimateTaskExpense.EstimateKey
		and    tEstimateTaskExpense.TaskKey is not null
		and    tEstimateTaskExpense.TaskKey not in (select NewTaskKey from #tTask) 
	else
		update tEstimateTaskExpense
		set    tEstimateTaskExpense.TaskKey = null
		from   tEstimate e (nolock)
		where  e.ProjectKey = @ProjectKey
		and    e.EstimateKey = tEstimateTaskExpense.EstimateKey
		and    tEstimateTaskExpense.TaskKey is not null
		and    tEstimateTaskExpense.TaskKey not in (select NewTaskKey from #tTask) 
	
	declare @EstimateKey int
	select @EstimateKey = -1
	while (1=1)
	begin
		select @EstimateKey = min(EstimateKey)
		from tEstimate (nolock)
		where ProjectKey = @ProjectKey
		and   EstimateKey > @EstimateKey

		if @EstimateKey is null
			break

		exec sptEstimateTaskRollupDetail @EstimateKey
	end

	RETURN 1
GO
