USE [MOJo_dev]
GO

/****** Object:  StoredProcedure [dbo].[sptProjectCopyTasks]    Script Date: 04/29/2016 16:24:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



alter Procedure [dbo].[sptProjectCopyTasks]
	(
		@ProjectKey int,
		@CopyProjectKey int,
		@CopyEstimate tinyint = 0,
		@UserKey int = null
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 10/27/06 GHL 8.4   Added tTask.EventStart, tTask.EventEnd columns 
  || 11/1/06  CRG 8.35  (6949) Changed Inner Join to Left Join when copying from tEstimateTaskExpense.
  || 12/13/06 GHL 8.4   Added MasterTask update
  || 01/04/07 GHL 8.4   Added Insert of tTask.PercComp
  || 01/16/07 GHL 8.4   In 8.35 the TaskConstraint was copied from one task to another.
  ||                    In 8.4 because of initial validations of the tasks, new tasks were created
  ||                    with TaskConstraint = 0. Users complained. Since we removed task validations
  ||                    I put them back the way it was.
  || 01/29/07 GHL 8.4   Removed the recalc of the rates at Hitchcock request (Bug 8083)
  || 10/24/07 GHL 8.439 (14700) Added rollup of details to estimates so that the project snapshot 
  ||                    is correct immediately after copying another project
  || 11/07/07 CRG 8.5   (9503) Modified to only copy over Active users
  || 10/01/08 GHL 10.010 (35058) Copying now estimates and COs
  || 10/01/08 GHL 10.010 (35311) when copying tasks, allocated hours should be copied
  ||                      But actuals dates and % complete should not be copied
  || 11/02/08 GHL 10.012 (39044) Only copy tTaskUser records for active users 
  || 11/04/08 GHL 10.012  Abort copying of tasks if the summary/budget tasks are wrong 
  || 02/12/10 GHL 10.518  Added campaign + lead to estimate
  || 03/02/10 GHL 10.519  Added company key to estimate
  || 06/09/10 GHL 10.531  Added support of task user records with UserKey = null
  || 7/12/10  CRG 10.5.3.2 Added ShowOnTimeline and TaskColor
  || 7/14/10  CRG 10.5.3.2 Added call to sptActivityCopyFromTask
  || 10/19/10 CRG 10.5.3.7 Removed ShowOnTimeline and TaskColor. Added TimelineSegmentKey.
  || 04/05/11 RLB 10.5.4.3 added Layoutkey when copying estimates
  || 09/23/11 GHL 10.548  (120964) Added copying of tEstimateTaskLaborLevel
  || 03/21/12 GWG 10.554  Modified the call to copy activities so it will also copy project level todo's
  || 08/07/12 GHL 10.558  (151031) Added copy of tEstimateTaskExpense.UnitRate
  || 11/02/12 RLB 10.561  Added ConstraintDayOfTheWeek for Kohls Enhancement
  || 12/11/12 GWG 10.563  Copy constraint date as is, rolled forward in [sptProjectCopyTasksShiftDates]
  || 2/3/13   GWG 10.5.6.4   Added a customization to enable this
  || 08/05/13 RLB 10.5.7.1 (183753) if there is an inactive user that has a service just added the role to task user
  || 03/05/15 GHL 10.5.9.0 Added fields and tables for Abelson Taylor 
  || 03/27/15 GHL 10.591  (250940) Added setting of client rate and markup for Abelson Taylor
  || 04/21/15 GHL 10.591  (253968) Only apply rate from client if get rate from = from client
  ||                      Only apply markup from client if get markup from = from client    
  || 05/07/15 GHL 10.591  (253968) Read the client from the new project and the GetRateFrom/GetMarkupFrom from the old project
  ||                      I was doing the inverse...If the old project says get rate from the client, we must apply rates from the new client    
  || 05/15/15 GHL 10.592 (254386) Change for Abelson Taylor. If the client says 'Lock Labor Rate', we should pull the rates
  ||                       from the client, else do as usual 
  || 06/25/15 GHL 10.593 (262323) Added saving of tEstimateTitle
  || 10/29/15 GHL 10.597  Added logging of copy at MN's request + use estimate number when logging 
  */
  
	IF EXISTS (SELECT 1 FROM tTask (NOLOCK) WHERE ProjectKey = @ProjectKey)
		RETURN 1

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
				
	DECLARE @RequireMasterTask INT, @CompanyKey INT, @ClientKey INT, @PushDate TINYINT, @GetRateFrom SMALLINT, @GetMarkupFrom SMALLINT, @LockRateFrom SMALLINT, @LockMarkupFrom SMALLINT
	Declare @LogActionDate smalldatetime, @LogComments varchar(4000), @LogRef varchar(200) 

	SELECT @CompanyKey = CompanyKey 
	      ,@GetRateFrom = GetRateFrom		-- Read this from the old project
	      ,@GetMarkupFrom = GetMarkupFrom	-- Read this from the old project
	FROM   tProject (NOLOCK)
	WHERE  ProjectKey = @CopyProjectKey 
	
	SELECT @ClientKey = ClientKey			-- Read this from the new project
	      ,@LogRef = ProjectNumber
	FROM   tProject (NOLOCK)
	WHERE  ProjectKey = @ProjectKey 

	select @LockRateFrom = isnull(LockLaborRate, 0) -- if the new client says the rates are locked, we will apply rates from the client below 
		 ,@LockMarkupFrom = isnull(LockMarkupFrom, 0)
	from  tCompany (nolock)
	where CompanyKey = @ClientKey 

	SELECT @RequireMasterTask = ISNULL(RequireMasterTask, 0)
	FROM   tPreference (NOLOCK)
	WHERE  CompanyKey = @CompanyKey 
	
	Select @PushDate = 0
	if exists(Select 1 from tPreference (nolock) Where CompanyKey = @CompanyKey and lower(Customizations) like '%pushconstraintdates%')
	BEGIN
		Select @PushDate = 1
	END
	  
	IF @RequireMasterTask = 1 
	BEGIN
		IF EXISTS (SELECT 1
				FROM   tTask (NOLOCK)
				WHERE  tTask.ProjectKey = @CopyProjectKey
				AND    tTask.TrackBudget = 1
				AND    ISNULL(tTask.MasterTaskKey, 0) = 0)
				RETURN -10

	END

	--Copy over the activities for the project level
	EXEC sptActivityCopyFromTask @CopyProjectKey, 0, @ProjectKey, 0, @UserKey

	-- Cross Reference old and new tasks
	-- This will be used for the Estimates as well
	CREATE TABLE #tTask (OldTaskKey int null, NewTaskKey int null)
	
	DECLARE @OldTaskKey INT
	        ,@NewTaskKey INT
	        ,@Error INT
	        ,@CustomFieldKey INT
			,@ObjectFieldSetKey int
			,@FieldSetKey int

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
			MasterTaskKey,
			TimelineSegmentKey,
			ConstraintDayOfTheWeek,
			ExcludeFromStatus
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
			Case When @PushDate = 1 then ConstraintDate else CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101)) end,  -- This is rolled forward in [sptProjectCopyTasksShiftDates]
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
			END,
			TimelineSegmentKey,
			ISNULL(ConstraintDayOfTheWeek, 0),
			ExcludeFromStatus
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
	
	-- Copy active users		
	INSERT tTaskUser (TaskKey, UserKey, ServiceKey, Hours, PercComp, ActStart, ActComplete )
	SELECT b.NewTaskKey, old_tu.UserKey, old_tu.ServiceKey, old_tu.Hours, 0, NULL ,NULL  
	FROM   tTaskUser old_tu (nolock)
		INNER JOIN #tTask b on old_tu.TaskKey = b.OldTaskKey
		INNER JOIN tUser old_u (nolock) on old_tu.UserKey = old_u.UserKey
	WHERE old_u.Active = 1
	
	-- Copy inactive users roles		
	INSERT tTaskUser (TaskKey, UserKey, ServiceKey, Hours, PercComp, ActStart, ActComplete )
	SELECT b.NewTaskKey, NULL, old_tu.ServiceKey, old_tu.Hours, 0, NULL ,NULL  
	FROM   tTaskUser old_tu (nolock)
		INNER JOIN #tTask b on old_tu.TaskKey = b.OldTaskKey
		INNER JOIN tUser old_u (nolock) on old_tu.UserKey = old_u.UserKey
		INNER JOIN tService old_s (nolock) on old_tu.ServiceKey = old_s.ServiceKey
	WHERE old_u.Active = 0 and old_s.Active = 1	

	-- Copy services
	INSERT tTaskUser (TaskKey, UserKey, ServiceKey, Hours, PercComp, ActStart, ActComplete )
	SELECT b.NewTaskKey, old_tu.UserKey, old_tu.ServiceKey, old_tu.Hours, 0, NULL ,NULL  
	FROM   tTaskUser old_tu (nolock)
		INNER JOIN #tTask b on old_tu.TaskKey = b.OldTaskKey
	WHERE old_tu.UserKey is null	
		 				
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

	IF @CopyEstimate = 0
		Return 1
	
	DECLARE @OldEstimateKey int
	       ,@EstimateNumber VARCHAR(50)
	       ,@Revision INT
	       ,@NewEstimateKey INT
	       ,@RetVal INT
	
	SELECT @OldEstimateKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @OldEstimateKey = MIN(EstimateKey)
		FROM   tEstimate (NOLOCK)
		Where  ProjectKey = @CopyProjectKey 
		--AND    ChangeOrder = 0
		AND    EstimateKey > @OldEstimateKey

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
				LayoutKey,
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
				UseRateLevel,
				LineFormat,
				UseTitle
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
				e.LayoutKey,                        -- @LayoutKey
				e.SalesTaxKey,						-- @SalesTaxKey,
				e.SalesTaxAmount,					-- @SalesTax amount
				e.SalesTax2Key,						-- @SalesTax2Key,
				e.SalesTax2Amount,					-- @SalesTax2 amount
				e.LaborTaxable,						-- @LaborTaxable,
				e.Contingency,						-- @Contingency,		
				e.ChangeOrder,						-- @ChangeOrder,
				isnull(p.AccountManager, e.InternalApprover),					-- @InternalApprover,
				1,									-- @InternalStatus
				NULL,								-- @InternalApproval
				NULL,								-- @InternalComments
				0,									-- @ExternalApprover,
				1,									-- @ExternalStatus
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
				UseRateLevel,
				LineFormat,
				UseTitle				
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
			BillingRate,
			Cost
			)
		SELECT
			@NewEstimateKey,
			eu.UserKey,
			eu.BillingRate,
			eu.Cost
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
			b.NewTaskKey,
			etl.ServiceKey,
			etl.UserKey,
			etl.Hours,
			etl.Rate,
			etl.Cost
		FROM
			tEstimateTaskLabor etl (nolock),
			#tTask b (NOLOCK)
		WHERE
			etl.EstimateKey = @OldEstimateKey AND
			etl.TaskKey = b.OldTaskKey

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
			etl.TaskKey = b.OldTaskKey

	INSERT tEstimateTaskLaborTitle
			(
			EstimateKey,
			TaskKey,
			ServiceKey,
			TitleKey,
			Hours,
			Rate,
			Gross,
			Cost	-- Added in 7.9
			)
		SELECT
			@NewEstimateKey,
			b.NewTaskKey,
			etl.ServiceKey,
			etl.TitleKey,
			etl.Hours,
			etl.Rate,
			etl.Gross,
			etl.Cost
		FROM
			tEstimateTaskLaborTitle etl (nolock),
			#tTask b (NOLOCK)
		WHERE
			etl.EstimateKey = @OldEstimateKey AND
			etl.TaskKey = b.OldTaskKey

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
			b.NewTaskKey,
			etl.ServiceKey,
			etl.UserKey,
			etl.Hours,
			etl.Rate
		FROM
			tEstimateTaskAssignmentLabor etl (nolock),
			#tTask b (NOLOCK)
		WHERE
			etl.EstimateKey = @OldEstimateKey AND
			etl.TaskKey = b.OldTaskKey
			
		Insert tEstimateService
		( EstimateKey, ServiceKey, Rate, Cost )
		Select @NewEstimateKey, ServiceKey, Rate, Cost
		from tEstimateService Where EstimateKey = @OldEstimateKey

		Insert tEstimateTitle
		( EstimateKey, TitleKey, Rate, Cost )
		Select @NewEstimateKey, TitleKey, Rate, Cost
		from tEstimateTitle Where EstimateKey = @OldEstimateKey

		-- Also etl records where TaskKey is null (Estimates by service only) 
		INSERT tEstimateTaskLabor
			(
			EstimateKey,
			TaskKey,
			ServiceKey,
			UserKey,
			Hours,
			Rate,
			Cost	
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
		AND 
			etl.TaskKey IS NULL
						
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

		INSERT tEstimateTaskExpense
				(
				EstimateKey,
				TaskKey,
				ItemKey,
				ShortDescription,
				LongDescription,
				Taxable,
				Taxable2,
				
				Quantity,
				UnitCost,
				UnitDescription,
				TotalCost,
				Billable,
				Markup,
				BillableCost,
				UnitRate,

				Quantity2,
				UnitCost2,
				UnitDescription2,
				TotalCost2,
				Markup2,
				BillableCost2,
				UnitRate2,

				Quantity3,
				UnitCost3,
				UnitDescription3,
				TotalCost3,
				Markup3,
				BillableCost3,
				UnitRate3,

				Quantity4,
				UnitCost4,
				UnitDescription4,
				TotalCost4,
				Markup4,
				BillableCost4,
				UnitRate4,

				Quantity5,
				UnitCost5,
				UnitDescription5,
				TotalCost5,
				Markup5,
				BillableCost5,
				UnitRate5,


				Quantity6,
				UnitCost6,
				UnitDescription6,
				TotalCost6,
				Markup6,
				BillableCost6,
				UnitRate6,

                DisplayOrder
				)

			SELECT
				@NewEstimateKey,
				b.NewTaskKey,
				ete.ItemKey,
				ete.ShortDescription,
				ete.LongDescription,
				ete.Taxable,
				ete.Taxable2,

				ete.Quantity,
				ete.UnitCost,
				ete.UnitDescription,
				ete.TotalCost,
				ete.Billable,
				ete.Markup,
				ete.BillableCost,
				ete.UnitRate,

				ete.Quantity2,
				ete.UnitCost2,
				ete.UnitDescription2,
				ete.TotalCost2,
				ete.Markup2,
				ete.BillableCost2,
				ete.UnitRate2,

				ete.Quantity3,
				ete.UnitCost3,
				ete.UnitDescription3,
				ete.TotalCost3,
				ete.Markup3,
				ete.BillableCost3,
				ete.UnitRate3,

				ete.Quantity4,
				ete.UnitCost4,
				ete.UnitDescription4,
				ete.TotalCost4,
				ete.Markup4,
				ete.BillableCost4,
				ete.UnitRate4,

				ete.Quantity5,
				ete.UnitCost5,
				ete.UnitDescription5,
				ete.TotalCost5,
				ete.Markup5,
				ete.BillableCost5,
				ete.UnitRate5,

				ete.Quantity6,
				ete.UnitCost6,
				ete.UnitDescription6,
				ete.TotalCost6,
				ete.Markup6,
				ete.BillableCost6,
				ete.UnitRate6,

				ete.DisplayOrder

		FROM 
			tEstimateTaskExpense ete (NOLOCK)
		LEFT JOIN #tTask b (NOLOCK) ON b.OldTaskKey = ete.TaskKey
		WHERE ete.EstimateKey  = @OldEstimateKey
			
		-- now change labor rate and markup based on client setting
		if isnull(@ClientKey, 0) > 0
		BEGIN
			DECLARE @ApplyRate SMALLINT				SELECT @ApplyRate = 0
            DECLARE @ApplyMarkup SMALLINT			SELECT @ApplyMarkup = 0
            
			IF ISNULL(@GetRateFrom,0) = 1 Or ISNULL(@LockRateFrom,0) = 1 -- From Client Or Locked
				SELECT @ApplyRate = 1
			IF ISNULL(@GetMarkupFrom,0) = 1 Or ISNULL(@LockMarkupFrom,0) = 1 -- From Client Or Locked
				SELECT @ApplyMarkup = 1

			IF @ApplyRate + @ApplyMarkup > 0
				EXEC sptEstimateApplyClientRateMarkup @NewEstimateKey, @ClientKey, @ApplyRate, @ApplyMarkup
		END
        
		-- EXEC sptEstimateRecalcRates @NewEstimateKey
		Exec sptEstimateTaskRollupDetail @NewEstimateKey


		select @LogActionDate = GETUTCDATE()
		select @LogRef = ProjectNumber from tProject (nolock) where ProjectKey = @ProjectKey
		select @LogComments = 'Estimate ' + isnull(@EstimateNumber, '') + ' was copied and added to Project ' + isnull(@LogRef, '')
		exec sptActionLogInsert 'Estimate', @NewEstimateKey, @CompanyKey, @ProjectKey, 'Created', @LogActionDate, null, @LogComments, @LogRef, null, @UserKey, null

	END

	RETURN 1

GO


