USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignFromEstimateDetail]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskAssignFromEstimateDetail]

	(
		@ProjectKey int
		,@CreateAssignments int = 0 -- 0 Just update current assignments
									-- 1 Delete and create new ones
	)

AS --Encrypt

 /*
  || When     Who Rel   What
  || 04/04/08 GHL 8.507 (23960) Reading now tEstimateTaskAssignmentLabor when creating tTaskUser records 
  || 06/08/09 GHL 10.5   Made changes to allow duplicate tTaskUser.UserKey per task  
  */

-- Primary key is TaskKey, UserKey just like in tTaskUser
CREATE TABLE #tSubtask (BudgetTaskKey INT NULL, TaskKey INT NULL, PlanDuration INT NULL
                        ,UserKey INT NULL, Hours DECIMAL(24, 4) NULL, ServiceKey INT NULL
                        ,TaskUserKey INT NULL,GPFlag INT NULL) -- General Purpose flag 

DECLARE @NumSubtasks INT
       ,@ServiceKey INT 
	   ,@UserKey INT
	   ,@ServiceHours DECIMAL(24, 4)
	   ,@UserHours DECIMAL(24, 4)
	   ,@SubtaskHours DECIMAL(24,4)
	   ,@TotalDuration INT
	   ,@TaskKey INT
	   ,@TempKey INT

IF @CreateAssignments = 1
BEGIN
	
	-- Insert tasks per user from estimates by task and service
    -- link with tProjectUserServices
    INSERT #tSubtask (TaskKey, UserKey, Hours, ServiceKey, GPFlag)
	SELECT DISTINCT etl.TaskKey
				, pus.UserKey, 0, 0, 0
	FROM   tEstimateTaskAssignmentLabor etl (NOLOCK)
		INNER JOIN tEstimate e (NOLOCK) ON etl.EstimateKey = e.EstimateKey
		INNER JOIN tProjectUserServices pus (NOLOCK) ON etl.ServiceKey = pus.ServiceKey 
	Where etl.ServiceKey is not null
	And   e.ProjectKey = @ProjectKey
	And ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
		Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4)) 
    And pus.ProjectKey = @ProjectKey
	-- This is important otherwise we would doubledip
	And e.EstimateKey NOT IN (SELECT EstimateKey FROM #tEstimateTaskLabor WHERE ServiceKey IS NOT NULL)
		
END

ELSE

BEGIN
    
   -- Insert tasks per user from current allocations
	INSERT #tSubtask (BudgetTaskKey, TaskKey, PlanDuration, UserKey, Hours, ServiceKey, TaskUserKey, GPFlag)
	SELECT t.BudgetTaskKey, t.TaskKey, t.PlanDuration, tu.UserKey, 0, 0, MIN(tu.TaskUserKey), 0
	FROM   tTaskUser tu (NOLOCK)
		INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey
	WHERE  t.ProjectKey = @ProjectKey
	AND    t.TaskType = 2 -- Tracking only 
    GROUP BY t.BudgetTaskKey, t.TaskKey, t.PlanDuration, tu.UserKey
    
    UPDATE #tSubtask
    SET    #tSubtask.PlanDuration = 
			CASE WHEN #tSubtask.PlanDuration IS NULL THEN 1
				WHEN #tSubtask.PlanDuration = 0 THEN 1
				ELSE #tSubtask.PlanDuration
			END 
    
END
     
--SELECT * FROM #tSubtask
     
IF (SELECT COUNT(*) FROM #tSubtask) = 0 
	RETURN 1     

SELECT @TaskKey = -1
WHILE (1=1)
BEGIN
	SELECT @TaskKey = MIN(etl.TaskKey)
	FROM   tEstimateTaskAssignmentLabor etl (NOLOCK)
		INNER JOIN tEstimate e (NOLOCK) ON etl.EstimateKey = e.EstimateKey
	Where etl.ServiceKey is not null
	And   e.ProjectKey = @ProjectKey
	And ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
		Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4)) 
    And  etl.TaskKey > @TaskKey
	-- This is important otherwise we would doubledip
	And e.EstimateKey NOT IN (SELECT EstimateKey FROM #tEstimateTaskLabor WHERE ServiceKey IS NOT NULL)
    
    IF @TaskKey IS NULL
		BREAK
	
	SELECT @ServiceKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ServiceKey = MIN(etl.ServiceKey)
		FROM   tEstimateTaskAssignmentLabor etl (NOLOCK)
			INNER JOIN tEstimate e (NOLOCK) ON etl.EstimateKey = e.EstimateKey
		Where etl.ServiceKey is not null
		And   e.ProjectKey = @ProjectKey
		And ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
			Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4)) 
		And  etl.TaskKey = @TaskKey
		And  etl.ServiceKey > @ServiceKey
		And  etl.Hours > 0
		-- This is important otherwise we would doubledip
		And e.EstimateKey NOT IN (SELECT EstimateKey FROM #tEstimateTaskLabor WHERE ServiceKey IS NOT NULL)
    	    
		IF @ServiceKey IS NULL
			BREAK
		
		UPDATE #tSubtask
		SET    ServiceKey = 0
		
		-- Mark subtasks if users are in tProjectUserServices for that service
		UPDATE #tSubtask
		SET    #tSubtask.ServiceKey = @ServiceKey
		FROM   tProjectUserServices (NOLOCK)
	    WHERE  tProjectUserServices.ProjectKey = @ProjectKey
	    AND    tProjectUserServices.ServiceKey = @ServiceKey
	    AND    tProjectUserServices.UserKey = #tSubtask.UserKey
	  AND    #tSubtask.TaskKey = @TaskKey
	
		-- Get number subtasks for that budget task and ServiceKey  	
		SELECT	@NumSubtasks = COUNT(*) FROM #tSubtask 
		WHERE  	TaskKey = @TaskKey
		AND     ServiceKey = @ServiceKey
	
		IF @NumSubtasks > 0
		BEGIN
			SELECT @ServiceHours = Sum(etl.Hours)
			FROM   tEstimateTaskAssignmentLabor etl (NOLOCK)
				INNER JOIN tEstimate e (NOLOCK) ON etl.EstimateKey = e.EstimateKey
			Where etl.ServiceKey is not null
			And   e.ProjectKey = @ProjectKey
			And ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
				Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4)) 
			And  etl.TaskKey = @TaskKey
			And  etl.ServiceKey = @ServiceKey
			-- This is important otherwise we would doubledip
			And e.EstimateKey NOT IN (SELECT EstimateKey FROM #tEstimateTaskLabor WHERE ServiceKey IS NOT NULL)

			IF @NumSubtasks = 1
				UPDATE #tSubtask
				SET    Hours = Hours + @ServiceHours 
				WHERE  TaskKey = @TaskKey
				AND    ServiceKey = @ServiceKey
			ELSE
			BEGIN
				-- Get what we had before update
				SELECT @UserHours = SUM(Hours)
				FROM   #tSubtask 
				WHERE  TaskKey = @TaskKey
				AND    ServiceKey = @ServiceKey
		
				-- update with the service hours
				UPDATE #tSubtask
				SET    Hours = Hours + ROUND(@ServiceHours  / CAST(@NumSubtasks AS DECIMAL(24,4)) , 2)
				WHERE  TaskKey = @TaskKey
				AND    ServiceKey = @ServiceKey
				
				-- Handle rounding errors later
				SELECT @SubtaskHours = SUM(Hours)
				FROM   #tSubtask
				WHERE  TaskKey = @TaskKey
				AND    ServiceKey = @ServiceKey
				
				IF @SubtaskHours <> (@UserHours + @ServiceHours)
				BEGIN
					-- difference between the 2 
					SELECT @SubtaskHours = (@UserHours + @ServiceHours) - @SubtaskHours  
					
					-- pick up any user to apply rounding fix
					
					SELECT @UserKey = MAX(UserKey)
					FROM   #tSubtask
					WHERE  TaskKey = @TaskKey
					AND    ServiceKey = @ServiceKey
					
					UPDATE #tSubtask
					SET    Hours = Hours + @SubtaskHours 
					WHERE  ServiceKey = @ServiceKey
					AND    TaskKey = @TaskKey
					AND    UserKey = @UserKey
				 
				END -- IF rounding Errors
				
			END -- IF @NumSubtasks > 1
							
	    END -- IF @NumSubtasks > 0
	    	
	END	-- @ServiceKey	 
    
END -- @TaskKey    

IF @CreateAssignments = 1
BEGIN
	-- delete current records 	
	DELETE tTaskUser 
	FROM   tTask t (NOLOCK)
	WHERE  t.TaskKey = tTaskUser.TaskKey
	AND    t.ProjectKey = @ProjectKey
		
	-- Insert new records		
	INSERT tTaskUser (UserKey, TaskKey, Hours 
		,PercComp, ActStart, ActComplete
		,ReviewedByTraffic, ReviewedByDate, ReviewedByKey
		,CompletedByDate,CompletedByKey)
	SELECT UserKey, TaskKey, Hours
	    ,0, NULL, NULL
	    ,0, NULL, NULL
	    ,NULL, NULL
	 FROM #tSubtask      
	  
	-- roll down from tTask 
	UPDATE	tTaskUser
	SET		tTaskUser.PercComp = ISNULL(tTask.PercComp, 0)
			,tTaskUser.ActStart = tTask.ActStart
			,tTaskUser.ActComplete = tTask.ActComplete
			,tTaskUser.ReviewedByTraffic = ISNULL(tTask.ReviewedByTraffic, 0)
			,tTaskUser.ReviewedByDate = tTask.ReviewedByDate
			,tTaskUser.ReviewedByKey = tTask.ReviewedByKey
			,tTaskUser.CompletedByDate = tTask.CompletedByDate
			,tTaskUser.CompletedByKey = tTask.CompletedByKey
	FROM	tTask (NOLOCK)
			,#tSubtask b  
	WHERE	tTaskUser.TaskKey = tTask.TaskKey		
	AND		tTask.ProjectKey = @ProjectKey
	AND		ISNULL(tTask.PercCompSeparate, 0) = 0
	AND     tTaskUser.UserKey = b.UserKey
	AND		tTaskUser.TaskKey = b.TaskKey
	
END

ELSE

BEGIN

	-- First reset ALL hours for the users we found
	-- we could have same user for a task
	UPDATE tTaskUser
	SET    tTaskUser.Hours = 0
	FROM   #tSubtask
	WHERE  tTaskUser.TaskKey = #tSubtask.TaskKey
	AND    tTaskUser.UserKey = #tSubtask.UserKey

	-- then update hours only for the TaskUserKey
	UPDATE tTaskUser
	SET    tTaskUser.Hours = #tSubtask.Hours
	FROM   #tSubtask
	WHERE  tTaskUser.TaskKey = #tSubtask.TaskKey
	AND    tTaskUser.UserKey = #tSubtask.UserKey
	AND    tTaskUser.TaskUserKey = #tSubtask.TaskUserKey

END


RETURN 1
GO
