USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spScheduleFlashSaveWMJ]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spScheduleFlashSaveWMJ]
	(
	@ProjectKey int,
	@ProjectStatusKey int,
	@StartDate smalldatetime,
	@CompleteDate smalldatetime,
	@ScheduleDirection smallint,
	@DetailedNotes varchar(4000),
	@WorkMon tinyint,
	@WorkTue tinyint,
	@WorkWed tinyint,
	@WorkThur tinyint,
	@WorkFri tinyint,
	@WorkSat tinyint,
	@WorkSun tinyint,
	@Duration int,
	@PercComp int,
	@AutoIDTask tinyint,
	@SimpleSchedule tinyint,
	@UserKey int = NULL
	)

AS -- Encrypt

  /*
  || When     Who Rel   What
  || 10/19/06 GHL 8.4   Added tTaskUser Rollup logic 
  || 11/27/06 GHL 8.4   Added update of tProject.Active 
  || 12/20/06 GHL 8.4   Added verification logic for predecessors similar to tasks
  || 12/21/06 GHL 8.4   Added logic to prevent duplicates in tAssignment
  || 01/03/07 GHL 8.4   Added patch to cleanup SummaryTaskKey = TaskKey situation
  || 01/03/07 GHL 8.4   Added protection against null PercComp
  || 01/22/07 GHL 8.4   Added logic for completed time and user
  || 02/09/07 GHL 8.4   Adding now user in tAssignment if missing there but is in tTaskUser
  ||                    Bug 8250 at Media Logic
  || 04/13/07 GHL 8.4   Added update of tProject.TaskStatus     
  || 05/18/07 RTC 8.5   (8314) Added custom field handling       
  || 09/06/07 GHL 8.435 Added patch for incorrect MoneyTask flag         
  || 05/09/08 RTC 8.5.1 Added logic for Task User Assignments to handle insert and updates, instead of delete all and re-insert      
  || 08/02/08 GWG 10.006 Added UserKey to the update tTaskUser to handle reasigning tasks. 
  || 09/03/08 GHL 10.008 (30569, 33987) Added/Fixed patch to update the BudgetTaskKey when missing
  || 09/29/08 GHL 10.009 (35379) Added patch to fix problem with TaskType = Tracking with existing subtasks
  ||                     i.e. should be TaskType = Summary  
  || 10/07/08 GHL 10.010 (36176) Added patch for incorrect MoneyTask flag (when TrackBudget = 1 and MoneyTask = 0)
  || 6/8/09   CRG 10.5.0.0 Added ServiceKey, Subject, Description, Comments to be updated from the #tTaskUser table
  || 09/14/09 RLB 10.5.1.0 Added DetailedNotes, Saving Next step comments on the project Schedule Project Setup area
  || 01/04/10 GHL 10.516 Added check of tran transfer status (task deletion)
  || 01/08/10 GHL 10.516 Added check of tran WIP status (task deletion) 
  || 01/11/10 GHL 10.516 (71304) Removed check of time DetailTaskKey (task deletion)
  || 01/21/10 GHL 10.517 (72908) Reviewed the deletion of transferred trans at the bottom of sp
  ||                     to increase perfo
  || 3/2/10   CRG 10.5.1.9 Added @AutoIDTask and @SimpleSchedule
  || 3/11/10  CRG 10.5.1.9 Added code to make sure that any tasks where ShowOnCalendar = 1 have the date part of EventStart/End matching the PlanStart/Complete dates
  || 04/14/10 GHL 10.521 (78802) Checking now amounts and rates on approved estimates
  ||                      if 0, we can delete the tasks
  || 7/12/10  CRG 10.5.3.2 Added ShowOnTimeline and TaskColor
  || 7/14/10  GWG 10.5.3.2 Added the rollup of names and allocated hours
  || 7/27/10  CRG 10.5.3.3 Now copying over Activities if the new Task was dragged onto the Schedule screen.
  ||                       Added optional UserKey parameter for use by the Activity copy SP.
  || 10/19/10 CRG 10.5.3.7 Removed ShowOnTimeline and TaskColor. Added TimelineSegmentKey.
  || 12/30/10 GHL 10.5.3.9 (87237) When checking if the tasks are in tEstimateTask before deleting them
  ||                       check if the estimate is for the project, because this could be for an opportunity
  ||                       If this for an opportunity, it is OK to delete because the task structure 
  ||                       is temporary stored in tEstimateTaskTemp
  || 2/11/11  RLB 10.5.4.1 (101827) changed error code on Task Predecessors to help locate where an error is coming from
  || 3/8/11   CRG 10.5.4.2 Now calling spScheduleSaveReassignToDo to reassign To Do items
  || 3/23/11  RLB 10.5.4.2 (106451) only pull tasks with PercComp < 100 when setting project task status
  || 4/19/11  GHL 10.5.4.3 (109241) Added recalc of estimates data when deleting tasks on estimates
  || 8/03/11  GHL 10.5.4.6 (118043) Removed an error when trying to delete a predecessor relationship which is already deleted 
  || 11/4/11  GHL 10.5.4.9 (125561) Instead of deleting tEstimateTaskExpense recs, set TaskKey = null when deleting tasks
  || 12/15/11 GWG 10.5.5.1 Added handling of defaults for subscribing and deliverable review and notify
  || 03/12/12 GHL 10.5.5.3 (136576) Modified the queries setting BudgetTaskKey (i.e I set them even if BTK <> 0)
  ||                       cause we keep on getting corrupted tasks at CenterLine
  || 03/21/12 GWG 10.554  Modified the call to copy activities so it will also copy project level todo's
  || 05/15/12 GHL 10.556  Modified the insertion of tTaskUser so that we can have duplicate (TaskKey,UserKey,ServiceKey)
  || 10/30/12 RLB 10.5.6.1 Kohls enhancement for Constraint Day of the Week 
  || 10/30/12 RLB 10.5.6.2 Kohls enhancement for Exclude From Status
  || 06/20/13 RLB 10.5.6.9 Added for Enhancement (172776) 
  || 10/28/13 WDF 10.5.7.3 Added Logging of Task deletes
  || 03/06/14 RLB 10.5.7.8 (196273) Adding AllowAllocatedHours for enhancement
  */

	SET NOCOUNT ON
	 
    /* 
    Assume that the following tables have been populated
    #tTask
    #tTaskPredecessor
    #tTaskUser
    #tAssignment
    Also
    
    CREATE TABLE #NewKeys(Entity VARCHAR(50) NULL, OldKey INT NULL, NewKey INT NULL)
    
    Validation of temp tables ex #tTask

	Action = 1 Insert, 2 Update, 3 Delete, 4 Cannot Delete
	
    #tTask.TaskKey  | #tTask.Action | Currently in DB
    ------------------------------------------------
        x		           2                x
        y                  2                y
        w                  2       
        -1                 1
        -2                 1
        u                  3                u
        v                  3
                                            z
        
        -1 and -2 will be inserted
        x and y can be updated
        u can be deleted
        
        w cannot be updated = ABORT
        z was not sent from flash = ABORT
        v cannot be deleted = ABORT 
	
	*/
	
	-- Tasks
	-- will capture case z 
	IF EXISTS (SELECT 1 FROM tTask (NOLOCK) WHERE ProjectKey = @ProjectKey
				AND   TaskKey NOT IN (SELECT TaskKey FROM #tTask )
				                      --WHERE  Action IN (2, 3) )
		       ) RETURN -1
		       
	-- will capture cases v and w	       
	IF EXISTS (SELECT 1 FROM #tTask WHERE Action IN (2, 3)
	           AND    TaskKey NOT IN (SELECT TaskKey FROM tTask (NOLOCK) 
	                                  WHERE ProjectKey = @ProjectKey)
		       ) RETURN -2

	-- Task Predecessors
	-- will capture case z 
	IF EXISTS (SELECT 1 FROM tTaskPredecessor tp (NOLOCK)
				INNER JOIN tTask t (NOLOCK) ON tp.TaskKey = t.TaskKey 
				WHERE t.ProjectKey = @ProjectKey
				AND   tp.TaskPredecessorKey NOT IN (SELECT TaskPredecessorKey FROM #tTaskPredecessor 
				                      WHERE  Action IN (2, 3) )
		       ) RETURN -8
		       
	-- will capture cases v and w	       
	--IF EXISTS (SELECT 1 FROM #tTaskPredecessor WHERE Action IN (2, 3)
	IF EXISTS (SELECT 1 FROM #tTaskPredecessor WHERE Action = 2
	           AND    TaskPredecessorKey NOT IN (SELECT tp.TaskPredecessorKey FROM tTaskPredecessor tp (NOLOCK)
				INNER JOIN tTask t (NOLOCK) ON tp.TaskKey = t.TaskKey 
				WHERE t.ProjectKey = @ProjectKey)
		  ) RETURN -9
	
	UPDATE	#tTask
	SET		#tTask.Action = 4
	FROM	tTime (NOLOCK)  
	WHERE	#tTask.TaskKey = tTime.TaskKey
	AND     tTime.TransferToKey is null -- not transferred
	AND     #tTask.Action = 3

	UPDATE	#tTask
	SET		#tTask.Action = 4
	FROM	tTime (NOLOCK)  
	WHERE	#tTask.TaskKey = tTime.TaskKey
	AND     tTime.TransferToKey is not null -- transferred
	AND     tTime.WIPPostingInKey > 0      -- WIP
	AND     #tTask.Action = 3

	UPDATE	#tTask
	SET		#tTask.Action = 4
	FROM	tExpenseReceipt (NOLOCK)  
	WHERE	#tTask.TaskKey = tExpenseReceipt.TaskKey
	AND     tExpenseReceipt.TransferToKey is null -- not transferred
	AND     #tTask.Action = 3

	UPDATE	#tTask
	SET		#tTask.Action = 4
	FROM	tExpenseReceipt (NOLOCK)  
	WHERE	#tTask.TaskKey = tExpenseReceipt.TaskKey
	AND     tExpenseReceipt.TransferToKey is not null -- transferred
	AND     tExpenseReceipt.WIPPostingInKey > 0       -- in wip
	AND     #tTask.Action = 3

	UPDATE	#tTask
	SET		#tTask.Action = 4
	FROM	tPurchaseOrderDetail (NOLOCK)  
	WHERE	#tTask.TaskKey = tPurchaseOrderDetail.TaskKey
	AND     tPurchaseOrderDetail.TransferToKey is null -- not transferred
	AND     #tTask.Action = 3

	UPDATE	#tTask
	SET		#tTask.Action = 4
	FROM	tVoucherDetail (NOLOCK)  
	WHERE	#tTask.TaskKey = tVoucherDetail.TaskKey 
	AND     tVoucherDetail.TransferToKey is null	-- not transferred
	AND     #tTask.Action = 3

	UPDATE	#tTask
	SET		#tTask.Action = 4
	FROM	tVoucherDetail (NOLOCK)  
	WHERE	#tTask.TaskKey = tVoucherDetail.TaskKey 
	AND     tVoucherDetail.TransferToKey is not null -- transferred
	AND     tVoucherDetail.WIPPostingInKey > 0 -- in wip
	AND     #tTask.Action = 3
	
	UPDATE	#tTask
	SET		#tTask.Action = 4
	FROM	tMiscCost (NOLOCK)  
	WHERE	#tTask.TaskKey = tMiscCost.TaskKey
	AND     tMiscCost.TransferToKey is null -- not transferred
	AND     #tTask.Action = 3

	UPDATE	#tTask
	SET		#tTask.Action = 4
	FROM	tMiscCost (NOLOCK)  
	WHERE	#tTask.TaskKey = tMiscCost.TaskKey
	AND     tMiscCost.TransferToKey is not null -- transferred
	AND     tMiscCost.WIPPostingInKey > 0      -- in wip
	AND     #tTask.Action = 3

	UPDATE	#tTask
	SET		#tTask.Action = 4
	FROM	tInvoiceLine (NOLOCK)  
	WHERE	#tTask.TaskKey = tInvoiceLine.TaskKey
	AND     #tTask.Action = 3

	-- Cannot delete if on an approved estimate
	UPDATE	#tTask
	SET		#tTask.Action = 4
	FROM	tEstimateTask et (NOLOCK)
		  ,tEstimate e (NOLOCK)  
	WHERE	#tTask.TaskKey = et.TaskKey
	AND     et.EstimateKey = e.EstimateKey
	AND    ISNULL(et.EstLabor, 0) + ISNULL(et.EstExpenses, 0) <> 0
	AND     ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
			Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
	AND     #tTask.Action = 3
	AND     e.ProjectKey = @ProjectKey -- could be a tLead estimate, OK to delete

	UPDATE	#tTask
	SET		#tTask.Action = 4
	FROM	tEstimateTaskLabor etl (NOLOCK)
		   ,tEstimate e (NOLOCK)  
	WHERE	#tTask.TaskKey = etl.TaskKey
	AND     etl.EstimateKey = e.EstimateKey
	AND     etl.Rate <> 0
	AND     ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
			Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
	AND     #tTask.Action = 3
	AND     e.ProjectKey = @ProjectKey -- could be a tLead estimate, OK to delete

	UPDATE	#tTask
	SET		#tTask.Action = 4
	FROM	tEstimateTaskExpense ete (NOLOCK)
		   ,tEstimate e (NOLOCK)  
	WHERE	#tTask.TaskKey = ete.TaskKey
	AND     ete.EstimateKey = e.EstimateKey
	AND     ((isnull(e.ExternalApprover, 0) > 0 and e.ExternalStatus = 4) 
			Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4)) 
	AND     #tTask.Action = 3
	AND     e.ProjectKey = @ProjectKey -- could be a tLead estimate, OK to delete
				
	-- Abort if we cannot delete
	IF EXISTS (SELECT 1 FROM #tTask Where Action = 4)
		RETURN -3
	                          
	DECLARE @TaskKey INT
	       ,@NewTaskKey INT
	       ,@Error INT
		   ,@Rowcount INT
	       ,@Active INT
		   ,@FromTaskKey int
	       ,@RecalcEstimate int
		   ,@RequireTasks int

	SELECT @Active = IsActive
	FROM tProjectStatus (NOLOCK) 
	WHERE ProjectStatusKey = @ProjectStatusKey

	select @RequireTasks = pref.RequireTasks 
	from tPreference pref (nolock)
	inner join tProject p (nolock) on p.CompanyKey = pref.CompanyKey 
	where p.ProjectKey = @ProjectKey 

	/*
	 * tTask Inserts
	 */

	BEGIN TRAN
		 
	SELECT @TaskKey = 0
	WHILE (1=1)
	BEGIN
		SELECT @TaskKey = MAX(TaskKey)
		FROM   #tTask
		WHERE  Action = 1
		AND    TaskKey < @TaskKey
		
		IF @TaskKey IS NULL
			BREAK 

		SELECT	@FromTaskKey = FromTaskKey
		FROM	#tTask
		WHERE	TaskKey = @TaskKey
					     
		INSERT tTask
			(
			--TaskKey,
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
			TaskStatus,
			ScheduleNote,
			CompletedByDate,
			CompletedByKey,
			TimelineSegmentKey,
			ConstraintDayOfTheWeek,
			ExcludeFromStatus,
			TimelineSegmentDisplayName,
			AllowAllocatedHours
			)
		SELECT	
			--TaskKey,
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
			ISNULL(PercComp, 0),
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
			TaskStatus,
			ScheduleNote,
			CompletedByDate,
			CompletedByKey,
			TimelineSegmentKey,
			ConstraintDayOfTheWeek,
			ExcludeFromStatus,
			TimelineSegmentDisplayName,
			AllowAllocatedHours
		FROM #tTask
		WHERE TaskKey = @TaskKey 
		
		SELECT @NewTaskKey = @@IDENTITY
			  ,@Error = @@ERROR
	
		IF @Error <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -99
		END
				  
		UPDATE #tTask SET NewTaskKey = @NewTaskKey WHERE TaskKey = @TaskKey	   	
		--CF update
		--UPDATE #tCFDocSaveKeys SET NewEntityKey = @NewTaskKey WHERE EntityKey = @TaskKey	
	    
	    -- For returns to Flash
	    INSERT #NewKeys (Entity, OldKey, NewKey)
	    VALUES ('tTask', @TaskKey, @NewTaskKey) 

		-- Now copy over any activities if this task was a template task that was dragged onto the Schedule screen
		IF ISNULL(@FromTaskKey, 0) > 0
			EXEC sptActivityCopyFromTask 0, @FromTaskKey, @ProjectKey, @NewTaskKey, @UserKey
	END
		        		       
	/*
	 * tTask Updates
	 */
	
	UPDATE  tTask
	SET tTask.TaskID = #tTask.TaskID,
			tTask.TaskName = #tTask.TaskName,
			tTask.Description = #tTask.Description,
			tTask.TaskType = #tTask.TaskType,
			tTask.SummaryTaskKey = #tTask.SummaryTaskKey,
			tTask.BudgetTaskKey = #tTask.BudgetTaskKey,
			tTask.HourlyRate = #tTask.HourlyRate,
			tTask.Markup = #tTask.Markup,
			tTask.IOCommission = #tTask.IOCommission,
			tTask.BCCommission = #tTask.BCCommission,
			tTask.ShowDescOnEst = #tTask.ShowDescOnEst,
			tTask.ServiceKey = #tTask.ServiceKey,
			tTask.Taxable = #tTask.Taxable,
			tTask.Taxable2 = #tTask.Taxable2,
			tTask.WorkTypeKey = #tTask.WorkTypeKey,
			tTask.BaseStart = #tTask.BaseStart,
			tTask.BaseComplete = #tTask.BaseComplete,
			tTask.PlanStart = #tTask.PlanStart,
			tTask.PlanComplete = #tTask.PlanComplete,
			tTask.PlanDuration = #tTask.PlanDuration,
			tTask.ActStart = #tTask.ActStart,
			tTask.ActComplete = #tTask.ActComplete,
			tTask.PercComp = ISNULL(#tTask.PercComp, 0),
			tTask.TaskConstraint = #tTask.TaskConstraint,
			tTask.Comments = #tTask.Comments,
			tTask.ScheduleTask = #tTask.ScheduleTask,
			tTask.TrackBudget = #tTask.TrackBudget ,
			tTask.MoneyTask = #tTask.MoneyTask,
			tTask.HideFromClient = #tTask.HideFromClient,
			tTask.AllowAnyone = #tTask.AllowAnyone,
			tTask.MasterTaskKey = #tTask.MasterTaskKey,
			tTask.ConstraintDate = #tTask.ConstraintDate,
			tTask.WorkAnyDay = #tTask.WorkAnyDay,
			tTask.PercCompSeparate = #tTask.PercCompSeparate,
			tTask.ProjectOrder = #tTask.ProjectOrder,
			tTask.DisplayOrder = #tTask.DisplayOrder,
			tTask.TaskLevel = #tTask.TaskLevel,
			tTask.TaskAssignmentTypeKey = #tTask.TaskAssignmentTypeKey,
			tTask.Priority = #tTask.Priority,
			tTask.ShowOnCalendar = #tTask.ShowOnCalendar,
			tTask.EventStart = #tTask.EventStart,
			tTask.EventEnd = #tTask.EventEnd,
			tTask.TimeZoneIndex = #tTask.TimeZoneIndex,
			tTask.DueBy = #tTask.DueBy,
			tTask.ReviewedByTraffic = #tTask.ReviewedByTraffic,
			tTask.ReviewedByDate = #tTask.ReviewedByDate,
			tTask.ReviewedByKey = #tTask.ReviewedByKey,
			tTask.PredecessorsComplete = #tTask.PredecessorsComplete,
			tTask.TaskStatus = #tTask.TaskStatus,
			tTask.ScheduleNote = #tTask.ScheduleNote,
			tTask.CompletedByDate = #tTask.CompletedByDate,
			tTask.CompletedByKey = #tTask.CompletedByKey,
			tTask.TimelineSegmentKey = ISNULL(#tTask.TimelineSegmentKey, tTask.TimelineSegmentKey), --Temp table could be null from CMP90, then keep existing value
			tTask.ConstraintDayOfTheWeek = #tTask.ConstraintDayOfTheWeek,
			tTask.ExcludeFromStatus = #tTask.ExcludeFromStatus,
			tTask.TimelineSegmentDisplayName = #tTask.TimelineSegmentDisplayName,
			tTask.AllowAllocatedHours = #tTask.AllowAllocatedHours
	FROM    #tTask
	WHERE   tTask.TaskKey = #tTask.TaskKey
	AND     tTask.ProjectKey = @ProjectKey
	AND     #tTask.Action = 2
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
					
	-- Now update the summary and budget tasks			
	UPDATE tTask
	SET    tTask.SummaryTaskKey = #tTask.NewTaskKey
	FROM   #tTask
	WHERE  tTask.SummaryTaskKey = #tTask.TaskKey
	AND    tTask.ProjectKey = @ProjectKey
	AND    tTask.SummaryTaskKey < 0
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
	
	UPDATE tTask
	SET    tTask.BudgetTaskKey = #tTask.NewTaskKey
	FROM   #tTask
	WHERE  tTask.BudgetTaskKey = #tTask.TaskKey
	AND    tTask.ProjectKey = @ProjectKey
	AND    tTask.BudgetTaskKey < 0
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
	
	-- Also save new keys in #tTaskPredecessor 
	UPDATE #tTaskPredecessor
	SET    #tTaskPredecessor.TaskKey = #tTask.NewTaskKey
	FROM   #tTask
	WHERE  #tTaskPredecessor.TaskKey = #tTask.TaskKey
	AND #tTaskPredecessor.TaskKey < 0
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
	
	UPDATE #tTaskPredecessor
	SET    #tTaskPredecessor.PredecessorKey = #tTask.NewTaskKey
	FROM   #tTask
	WHERE  #tTaskPredecessor.PredecessorKey = #tTask.TaskKey
	AND    #tTaskPredecessor.PredecessorKey < 0
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
	
	-- Save new keys in #tTaskUser 
	UPDATE #tTaskUser
	SET    #tTaskUser.TaskKey = #tTask.NewTaskKey
	FROM   #tTask
	WHERE  #tTaskUser.TaskKey = #tTask.TaskKey
	AND    #tTaskUser.TaskKey < 0
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
	
	/*
	 * tTask Deletes
	 */
	 
	-- Same order than in sptTaskDelete for deadlocks
	-- However we updated tTask first!!!! The order is different

	
	delete tTaskUser
	from   #tTask 
	where  tTaskUser.TaskKey = #tTask.TaskKey
	and    #tTask.Action = 3
	
	
	/*
	-- Might as well delete them all
	DELETE tTaskUser
	FROM   tTask (NOLOCK)
	WHERE  tTaskUser.TaskKey = tTask.TaskKey	
	AND    tTask.ProjectKey = @ProjectKey 
	*/
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
	
	-- We should update the tasks on tTaskPredecessor before deleting
	UPDATE  tTaskPredecessor
	SET		tTaskPredecessor.TaskKey = #tTaskPredecessor.TaskKey
			,tTaskPredecessor.PredecessorKey = #tTaskPredecessor.PredecessorKey
			,tTaskPredecessor.Lag = #tTaskPredecessor.Lag
	FROM    #tTaskPredecessor  		
	WHERE   tTaskPredecessor.TaskPredecessorKey = #tTaskPredecessor.TaskPredecessorKey  		
	AND		Action = 2
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
	
	delete tTaskPredecessor
	from   #tTask 
	where  tTaskPredecessor.TaskKey = #tTask.TaskKey
	and    #tTask.Action = 3
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
	
	delete tTaskPredecessor
	from   #tTask 
	where  tTaskPredecessor.PredecessorKey = #tTask.TaskKey
	and    #tTask.Action = 3

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
	
	if isnull(@RequireTasks, 0) = 1
	begin
		-- tasks are required on expenses
		delete tEstimateTaskExpense
		from   #tTask 
		where  tEstimateTaskExpense.TaskKey = #tTask.TaskKey
		and    #tTask.Action = 3
	
		select @Error = @@ERROR, @Rowcount = @@ROWCOUNT

		If @Rowcount > 0
			select @RecalcEstimate = 1

		IF @Error <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -99
		END
	end
	else
	begin
		-- tasks are not required on expenses
		update tEstimateTaskExpense
		set    tEstimateTaskExpense.TaskKey = null
		from   #tTask 
		where  tEstimateTaskExpense.TaskKey = #tTask.TaskKey
		and    #tTask.Action = 3

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -99
		END
	end

	delete tEstimateTaskLabor
	from   #tTask 
	where  tEstimateTaskLabor.TaskKey = #tTask.TaskKey
	and    #tTask.Action = 3
	
	select @Error = @@ERROR, @Rowcount = @@ROWCOUNT

	If @Rowcount > 0
		select @RecalcEstimate = 1

	IF @Error <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
	
	delete tEstimateTaskAssignmentLabor
	from   #tTask 
	where  tEstimateTaskAssignmentLabor.TaskKey = #tTask.TaskKey
	and    #tTask.Action = 3
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
	
	delete tEstimateTask
	from   #tTask 
	where  tEstimateTask.TaskKey = #tTask.TaskKey
	and    #tTask.Action = 3
	
	select @Error = @@ERROR, @Rowcount = @@ROWCOUNT

	If @Rowcount > 0
		select @RecalcEstimate = 1

	IF @Error <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END

	-- Log Tasks being deleted from the Schedule
	DECLARE @CompanyKey INT, @ProjectNumber VARCHAR(50), @Now as datetime, @Comments varchar(4000)

	SELECT @ProjectNumber = ProjectNumber, @CompanyKey = CompanyKey from tProject (nolock) where ProjectKey = @ProjectKey
	SELECT @Now = GETUTCDATE()
	SELECT @TaskKey = 0
	
	WHILE (1=1)
		BEGIN
			SELECT @TaskKey = MIN(TaskKey)
			  FROM #tTask
			 WHERE Action = 3
			   AND TaskKey > @TaskKey
		
			IF @TaskKey IS NULL
				BREAK
				
			SELECT @Comments = 'Task ' + TaskID + ' - ' + TaskName + ' was deleted'
			  FROM tTask (nolock)
			 WHERE ProjectKey = @ProjectKey
			   AND TaskKey = @TaskKey

			-- Log Task Deletion 
			EXEC sptActionLogInsert 'Project', @TaskKey, @CompanyKey, @ProjectKey, 'Task Deleted',
								@Now, NULL, @Comments, @ProjectNumber, NULL, @UserKey  
		END
	
	-- Delete the tasks			
	DELETE tTask 
	FROM   #tTask
	WHERE  tTask.TaskKey = #tTask.TaskKey
	AND    tTask.ProjectKey = @ProjectKey
	AND    #tTask.Action = 3
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
	
	/*
	 * tTaskUser 
	 */
	
	/*	
	DELETE tTaskUser
	FROM   tTask (NOLOCK)
	WHERE  tTaskUser.TaskKey = tTask.TaskKey	
	AND    tTask.ProjectKey = @ProjectKey 
	*/
		
	DELETE  tTaskUser
	FROM    #tTaskUser  		
	WHERE   tTaskUser.TaskUserKey = #tTaskUser.TaskUserKey  		
	AND     Action = 3

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END

	--Call SP to reassign ToDo items	
	EXEC spScheduleSaveReassignToDo

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END

	UPDATE tTaskUser
	SET		tTaskUser.UserKey = #tTaskUser.UserKey,
			tTaskUser.Hours = #tTaskUser.Hours,
			tTaskUser.PercComp = #tTaskUser.PercComp,
			tTaskUser.ActStart = #tTaskUser.ActStart,
			tTaskUser.ActComplete = #tTaskUser.ActComplete,
			tTaskUser.ReviewedByTraffic = #tTaskUser.ReviewedByTraffic,
			tTaskUser.ReviewedByDate = #tTaskUser.ReviewedByDate,
			tTaskUser.ReviewedByKey = #tTaskUser.ReviewedByKey,
			tTaskUser.CompletedByDate = #tTaskUser.CompletedByDate,
			tTaskUser.CompletedByKey = #tTaskUser.CompletedByKey,
			tTaskUser.ServiceKey = #tTaskUser.ServiceKey,
			tTaskUser.Subject = #tTaskUser.Subject,
			tTaskUser.Description = #tTaskUser.Description,
			tTaskUser.Comments = #tTaskUser.Comments,
			tTaskUser.DeliverableKey = #tTaskUser.DeliverableKey
	FROM	#tTaskUser
	WHERE	tTaskUser.TaskUserKey = #tTaskUser.TaskUserKey		
	AND		Action = 2
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
		
	-- tTaskUser records must be inserted one at a time
	-- because the composite key (TaskKey,UserKey,ServiceKey) has been broken on the UI
	-- i.e. we can now have duplicate UserKey,ServiceKey for each task

	declare @OldKey int
	       ,@NewKey int
	select @OldKey = -10000
	while (1=1)
	begin
		select @OldKey = Min(TaskUserKey)
		from   #tTaskUser
		where  TaskUserKey <=0
		and    TaskUserKey > @OldKey
		and    Action = 1

		if @OldKey is null
			break

		INSERT tTaskUser
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
			ServiceKey,
			Subject,
			Description,
			Comments,
			DeliverableKey
			)
		SELECT
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
			ServiceKey,
			Subject,
			Description,
			Comments,
			DeliverableKey
		FROM  #tTaskUser
		WHERE TaskUserKey = @OldKey

		select @Error = @@ERROR, @NewKey = @@IDENTITY

		IF @Error <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -99
		END

		-- For returns to Flash
		INSERT #NewKeys (Entity, OldKey, NewKey)
		SELECT 'tTaskUser', @OldKey, @NewKey
		

	end


	/*
	 * tTaskPredecessor 
	 */		

	DELETE  tTaskPredecessor
	FROM    #tTaskPredecessor  		
	WHERE   tTaskPredecessor.TaskPredecessorKey = #tTaskPredecessor.TaskPredecessorKey  		
	AND     Action = 3

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END

	-- Safer to do this ??
	DELETE  tTaskPredecessor
		FROM tTask (NOLOCK)
	WHERE   tTaskPredecessor.TaskKey = tTask.TaskKey
	AND     tTask.ProjectKey = @ProjectKey
	AND     tTaskPredecessor.TaskPredecessorKey NOT IN (SELECT TaskPredecessorKey FROM #tTaskPredecessor)

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END
	
	/* Already done earlier
	UPDATE  tTaskPredecessor
	SET		tTaskPredecessor.TaskKey = #tTaskPredecessor.TaskKey
			,tTaskPredecessor.PredecessorKey = #tTaskPredecessor.PredecessorKey
			,tTaskPredecessor.Lag = #tTaskPredecessor.Lag
	FROM    #tTaskPredecessor  		
	WHERE   tTaskPredecessor.TaskPredecessorKey = #tTaskPredecessor.TaskPredecessorKey  		
	AND		Action = 2
	*/
	
	
	INSERT  tTaskPredecessor (TaskKey, PredecessorKey, Type, Lag)
	SELECT  #tTaskPredecessor.TaskKey
			,#tTaskPredecessor.PredecessorKey
			,#tTaskPredecessor.Type
			,#tTaskPredecessor.Lag
	FROM    #tTaskPredecessor  		
	WHERE   Action = 1

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -99
	END

	-- For returns to Flash
	INSERT #NewKeys (Entity, OldKey, NewKey)
	SELECT 'tTaskPredecessor', TaskPredecessorKey, NULL
	FROM   #tTaskPredecessor
	WHERE  Action = 1
	
	UPDATE #NewKeys
	SET    #NewKeys.NewKey = b.TaskPredecessorKey 
	FROM   #tTaskPredecessor a
	       ,tTaskPredecessor b (NOLOCK)  
	WHERE  a.TaskPredecessorKey = #NewKeys.OldKey
	AND    a.TaskKey = b.TaskKey
	AND    a.PredecessorKey = b.PredecessorKey
	AND    #NewKeys.Entity = 'tTaskPredecessor'
	
	COMMIT TRAN
	 
	 /*
	 * tProject 
	 */	

	-- This update does not have to be in the transaction
	UPDATE  tProject
	SET		ProjectStatusKey = @ProjectStatusKey,
			StartDate = @StartDate,
			CompleteDate = @CompleteDate,
			ScheduleDirection = @ScheduleDirection,
			DetailedNotes = @DetailedNotes,
			WorkMon = @WorkMon,
			WorkTue = @WorkTue,
			WorkWed = @WorkWed,
			WorkThur = @WorkThur,
			WorkFri = @WorkFri,
			WorkSat = @WorkSat,
			WorkSun = @WorkSun,
			Duration = @Duration,
			PercComp = @PercComp,
			Active = @Active,
			AutoIDTask = @AutoIDTask,
			SimpleSchedule = @SimpleSchedule,
			TaskStatus = ISNULL((SELECT MAX(tTask.TaskStatus) 
					FROM tTask (NOLOCK) 
					WHERE tTask.ProjectKey = @ProjectKey
					AND tTask.PercComp < 100
					AND tTask.ScheduleTask = 1
					AND tTask.TaskType = 2 ), 1)
	WHERE ProjectKey = @ProjectKey	 
			
	/*
	 * tAssignment
	 * Did not put any SQL Transaction since the original code does not have any 
	 */		

	-- Inserts and Deletes only, do not process Updates
	DELETE tProjectUserServices
	FROM   #tAssignment
	WHERE  tProjectUserServices.ProjectKey = @ProjectKey
	AND    tProjectUserServices.UserKey = #tAssignment.UserKey
	AND    #tAssignment.Action IN (1, 3)	
			
	-- Deletes
	DELETE tAssignment
	FROM   #tAssignment
	WHERE  tAssignment.ProjectKey = @ProjectKey 
	AND    tAssignment.UserKey = #tAssignment.UserKey
	AND    #tAssignment.Action = 3	

	-- Before inserting, check if already there
	UPDATE #tAssignment
	SET    #tAssignment.Action = 4 -- do not process later
	FROM   tAssignment (NOLOCK)
	WHERE  tAssignment.ProjectKey = @ProjectKey 
	AND    tAssignment.UserKey = #tAssignment.UserKey 
	
	INSERT tAssignment(ProjectKey,UserKey, HourlyRate, SubscribeDiary, SubscribeToDo, DeliverableReviewer, DeliverableNotify)
	SELECT DISTINCT @ProjectKey, u.UserKey, ISNULL(u.HourlyRate, 0), ISNULL(u.SubscribeDiary, 0), ISNULL(u.SubscribeToDo, 0), ISNULL(u.DeliverableReviewer, 0), ISNULL(u.DeliverableNotify, 0)
	FROM   #tAssignment
	INNER JOIN tUser u (nolock) on #tAssignment.UserKey = u.UserKey
	WHERE  #tAssignment.Action = 1

	-- protection against duplicates
	DELETE tAssignment
	WHERE  tAssignment.ProjectKey = @ProjectKey
	AND    tAssignment.AssignmentKey > (SELECT MIN(a2.AssignmentKey) FROM tAssignment a2 (NOLOCK)
							WHERE  a2.ProjectKey = @ProjectKey
							AND    a2.UserKey = tAssignment.UserKey)
		
	-- protection against missing users (Bug 8250)
	-- not sure why, but it happened at Media Logic
	INSERT tAssignment (ProjectKey, UserKey, HourlyRate, SubscribeDiary, SubscribeToDo, DeliverableReviewer, DeliverableNotify)
	SELECT DISTINCT @ProjectKey, tu.UserKey, u.HourlyRate, ISNULL(u.SubscribeDiary, 0), ISNULL(u.SubscribeToDo, 0), ISNULL(u.DeliverableReviewer, 0), ISNULL(u.DeliverableNotify, 0)
	FROM   tTaskUser tu (NOLOCK)
		INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey
		INNER JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey
	WHERE t.ProjectKey = @ProjectKey
	AND   tu.UserKey NOT IN (SELECT UserKey FROM tAssignment (NOLOCK) WHERE ProjectKey = @ProjectKey)
		
	-- For returns to Flash
	INSERT #NewKeys (Entity, OldKey, NewKey)
	SELECT 'tAssignment', AssignmentKey, AssignmentKey
	FROM   #tAssignment
	WHERE  Action = 1
	
	UPDATE #NewKeys
	SET    #NewKeys.NewKey = b.AssignmentKey 
	FROM   #tAssignment a
	       ,tAssignment b (NOLOCK)  
	WHERE  a.AssignmentKey = #NewKeys.OldKey
	AND    b.ProjectKey = @ProjectKey
	AND    a.UserKey = b.UserKey
	AND    #NewKeys.Entity = 'tAssignment'
	
	Insert tProjectUserServices (ProjectKey, UserKey, ServiceKey)
	Select @ProjectKey, u.UserKey, u.DefaultServiceKey
	from   tUser u (nolock)
	 ,#tAssignment b 
	Where  b.UserKey = u.UserKey
	And    b.Action = 1
	And    u.DefaultServiceKey IS NOT NULL
	 
	-- SummaryTaskKey
	UPDATE tTask SET SummaryTaskKey = 0 WHERE ProjectKey = @ProjectKey AND TaskKey = SummaryTaskKey 	

	-- MoneyTask
	
	-- Fix MoneyTask at the level we track budget
	UPDATE tTask
	SET    tTask.MoneyTask = 1
	WHERE  tTask.ProjectKey = @ProjectKey
	AND    tTask.MoneyTask = 0
	AND    tTask.TrackBudget = 1
	
	-- Fix MoneyTask one level higher than the level where we track budget
	UPDATE tTask
	SET    tTask.MoneyTask = 1
	FROM   tTask (NOLOCK)
		   ,tTask track (NOLOCK) 
	WHERE  tTask.ProjectKey = @ProjectKey
	AND    tTask.ProjectKey = track.ProjectKey 
	AND    tTask.TaskKey = track.SummaryTaskKey 
	AND    track.TrackBudget = 1
	AND    tTask.MoneyTask = 0

	-- BudgetTaskKey
	update tTask
	set    tTask.BudgetTaskKey = tTask.SummaryTaskKey
	from   tTask (NOLOCK)
		  ,tTask summary (NOLOCK)
	where  tTask.SummaryTaskKey = summary.TaskKey
	--and    ISNULL(tTask.BudgetTaskKey, 0) = 0  -- for (136576)
	and    summary.TrackBudget = 1
	and    tTask.TrackBudget = 0
	and    tTask.ProjectKey = @ProjectKey
	and    summary.ProjectKey = @ProjectKey
	
	update tTask
	set    tTask.BudgetTaskKey = summary.SummaryTaskKey
	from   tTask (NOLOCK)
		  ,tTask summary (NOLOCK)
		  ,tTask summary2 (NOLOCK)
	where  tTask.SummaryTaskKey = summary.TaskKey
	and    summary.SummaryTaskKey = summary2.TaskKey
	--and    ISNULL(tTask.BudgetTaskKey, 0) = 0 -- for (136576)
	and    summary2.TrackBudget = 1
	and    tTask.TrackBudget = 0
	and    tTask.ProjectKey = @ProjectKey
	and    summary.ProjectKey = @ProjectKey
	and    summary2.ProjectKey = @ProjectKey

	update tTask
	set    tTask.BudgetTaskKey = tTask.TaskKey
	where  tTask.TrackBudget = 1
	and    ISNULL(tTask.BudgetTaskKey, 0) = 0
	and    tTask.ProjectKey = @ProjectKey


	-- patch for TaskType
	update tTask
	set    tTask.TaskType = 1 -- summary
	where  tTask.ProjectKey = @ProjectKey
	and    tTask.TaskType = 2 -- tracking
	and    exists (select 1 from tTask t2 (nolock) 
					where t2.ProjectKey = @ProjectKey
					and   t2.SummaryTaskKey = tTask.TaskKey)  
	
	--Make sure that the date parts of EventStart/End match the dates in PlanStart and PlanComplete
	UPDATE	tTask
	SET		EventStart = dbo.fSyncDate(EventStart, PlanStart),
			EventEnd = dbo.fSyncDate(EventEnd, PlanComplete)
	WHERE	ProjectKey = @ProjectKey
	AND		ShowOnCalendar = 1	

	-- Do the rolldown when PercCompSeparate = 0
	SELECT @TaskKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @TaskKey = MIN(TaskKey)
		FROM   tTask (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		AND    TaskKey > @TaskKey
		AND    PercCompSeparate = 0
		
		IF @TaskKey IS NULL
			BREAK
		
		EXEC sptTaskUserRolldown @TaskKey
	
	END
	
	-- Do the rollup when PercCompSeparate = 1
	SELECT @TaskKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @TaskKey = MIN(TaskKey)
		FROM tTask (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		AND    TaskKey > @TaskKey
		AND    PercCompSeparate = 1
		
		IF @TaskKey IS NULL
			BREAK
		
		EXEC sptTaskUserRollup @TaskKey, 1 -- TrafficOnly = 1, no actuals
	
	END

	-- Re rollup assigned names, allocations
	exec sptProjectRollupSchedule @ProjectKey, @PercComp, @Duration
	
	-- GHL: I placed this outside of the SQL transaction because it takes too long
	-- and this concerns only transferred transactions
	if exists (select 1 from #tTask where TaskKey > 0 and Action = 3)
	begin
		-- At this time, we have established at the top of the sp that all tTime records have been
		-- 1) Transferred
		-- 2) And not in WIP
		-- we can safely delete tTime records without testing TransferToKey
		
		-- Same logic for other transactions
		
		delete tTime
		from   #tTask 
		where  tTime.ProjectKey = @ProjectKey -- Limit to ProjectKey
		and    tTime.TaskKey = #tTask.TaskKey 
		--and    tTime.TransferToKey is not null -- Avoid a costly RID lookup to read TransferToKey
		and    #tTask.Action = 3 -- delete action
		and    #tTask.TaskKey > 0
		
		create table #time(TimeKey uniqueidentifier null)
		
		insert #time (TimeKey)
		select TimeKey
		from   tTime (nolock)
		      ,#tTask 
		where  tTime.ProjectKey = @ProjectKey
		and    tTime.DetailTaskKey = #tTask.TaskKey
		and    #tTask.Action = 3 -- delete action
		and    #tTask.TaskKey > 0
 
		if (select count(*) from #time) > 0
		begin		 
			update tTime
			set    tTime.DetailTaskKey = null
			from   #time
			where  tTime.TimeKey = #time.TimeKey
		end
		
		
		delete tExpenseReceipt
		from   #tTask 
		where  tExpenseReceipt.ProjectKey = @ProjectKey
		and    tExpenseReceipt.TaskKey = #tTask.TaskKey
		--and    tExpenseReceipt.TransferToKey is not null -- was transferred
		and    #tTask.Action = 3 -- delete action
		and    #tTask.TaskKey > 0
		
		
		delete tVoucherDetail
		from   #tTask 
		where  tVoucherDetail.ProjectKey = @ProjectKey
		and    tVoucherDetail.TaskKey = #tTask.TaskKey
		--and    tVoucherDetail.TransferToKey is not null -- was transferred
		and    #tTask.Action = 3 -- delete action
		and    #tTask.TaskKey > 0
		
		delete tPurchaseOrderDetail
		from   #tTask 
		where  tPurchaseOrderDetail.ProjectKey = @ProjectKey
		and    tPurchaseOrderDetail.TaskKey = #tTask.TaskKey
		--and    tPurchaseOrderDetail.TransferToKey is not null -- was transferred
		and    #tTask.Action = 3 -- delete action
		and    #tTask.TaskKey > 0
		
		delete tMiscCost
		from   #tTask 
		where  tMiscCost.ProjectKey = @ProjectKey
		and    tMiscCost.TaskKey = #tTask.TaskKey
		--and    tMiscCost.TransferToKey is not null -- was transferred
		and    #tTask.Action = 3 -- delete action
		and    #tTask.TaskKey > 0
		
	end

	declare @EstimateKey int, @ApprovedQty int, @SalesTax1Amount money, @SalesTax2Amount money
	if isnull(@RecalcEstimate, 0) > 0
	begin
		select @EstimateKey = 0

		while (1=1)
		begin
			select @EstimateKey = min(EstimateKey)
			from   tEstimate (nolock)
			where  ProjectKey = @ProjectKey
			and    EstimateKey > @EstimateKey
			-- And not approved
			AND    NOT  ((isnull(ExternalApprover, 0) > 0 and  ExternalStatus = 4) 
						Or (isnull(ExternalApprover, 0) = 0 and  InternalStatus = 4))  

			if @EstimateKey is null
				break

			Select @ApprovedQty = ApprovedQty from tEstimate (nolock) where EstimateKey = @EstimateKey
			Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
			Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey

			exec sptEstimateTaskRollupDetail @EstimateKey

		end

	end
			  						 			
	RETURN 1
GO
