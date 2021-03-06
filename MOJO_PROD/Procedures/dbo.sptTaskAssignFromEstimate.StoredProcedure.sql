USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignFromEstimate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskAssignFromEstimate]

	(
		@ProjectKey int
		,@CreateAssignments int = 0 -- 0 Just update current assignments
									-- 1 Delete and create new ones
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 01/16/07 GHL 8.4   Modified as specified here
  ||                    1) Do not take in account TaskAssignmentType
  ||                    2) Do not create tTaskUser records, this confuses users (bug 7757)
  ||                       Users create a project with assignments first, then do a budget
  ||                       We simply overwrite here the hours in the current tTaskUser records
  ||                    3) Also allocate based on task durations 
  ||                    4) Note:
  ||                        We only do 2 passes: 1 for estimates by task and person,   
  ||                        1 for estimates by task and service. 
  ||                        i.e. I do not account for estimates by task only/by service only
  || 03/13/07 GHL 8.407 Added @CreateAssignments parameter
  ||                    This way we can update current allocations or create new ones
  || 03/20/07 GHL 8.407 Corrected where clause
  || 04/04/08 GHL 8.507 (23960) Reading now tEstimateTaskAssignmentLabor 
  || 06/08/09 GHL 10.5   Made changes to allow duplicate tTaskUser.UserKey per task
  */

-- TaskUserKey will only be used when @CreateAssignments = 0
CREATE TABLE #tSubtask (BudgetTaskKey INT NULL, TaskKey INT NULL, PlanDuration INT NULL
                        ,UserKey INT NULL, Hours DECIMAL(24, 4) NULL, ServiceKey INT NULL
                        ,TaskUserKey INT NULL, GPFlag INT NULL) -- General Purpose flag 


CREATE TABLE #tEstimateTaskLabor (
	EstimateKey int NOT NULL ,
	TaskKey int NULL ,
	ServiceKey int NULL ,
	UserKey int NULL ,
	Hours decimal(24, 4) NOT NULL ,
	Rate money NOT NULL ,
	Cost money NULL)

DECLARE @BudgetTaskKey INT
       ,@NumSubtasks INT
       ,@ServiceKey INT 
	   ,@UserKey INT
	   ,@ServiceHours DECIMAL(24, 4)
	   ,@UserHours DECIMAL(24, 4)
	   ,@SubtaskHours DECIMAL(24,4)
	   ,@TotalDuration INT
	   ,@TaskKey INT
	   ,@TempKey INT

-- Save all budget task labor records, we may have to eliminate some if we find some detail task labor
INSERT #tEstimateTaskLabor (EstimateKey, TaskKey, ServiceKey, UserKey, Hours, Rate, Cost)
SELECT etl.EstimateKey, etl.TaskKey, etl.ServiceKey, etl.UserKey, etl.Hours, etl.Rate, etl.Cost
FROM   tEstimateTaskLabor etl (NOLOCK)
	INNER JOIN tEstimate e (NOLOCK) ON etl.EstimateKey = e.EstimateKey 
WHERE  e.ProjectKey = @ProjectKey
And ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
	  Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4)) 
   
DECLARE @EstimateKey INT, @BudgetTotal DECIMAL(24, 4), @DetailTotal DECIMAL(24, 4), @HasDetailHours INT  
SELECT @EstimateKey = -1, @HasDetailHours = 0
WHILE (1=1)
BEGIN
	SELECT @EstimateKey = MIN(EstimateKey)
	FROM   #tEstimateTaskLabor 
	WHERE  EstimateKey > @EstimateKey
	
	IF @EstimateKey IS NULL
		BREAK
		
	-- If there are some details records	
	IF EXISTS (SELECT 1 FROM tEstimateTaskAssignmentLabor (NOLOCK) WHERE EstimateKey = @EstimateKey)
	BEGIN
		-- compare the totals, they should be the same
		SELECT @BudgetTotal = SUM(Hours * Rate)
		FROM   #tEstimateTaskLabor 
		WHERE  EstimateKey = @EstimateKey
		AND    ServiceKey IS NOT NULL
	
		SELECT @DetailTotal = SUM(Hours * Rate)
		FROM   tEstimateTaskAssignmentLabor (NOLOCK)  
		WHERE  EstimateKey = @EstimateKey
		AND    ServiceKey IS NOT NULL
	
		-- eliminate labor at the budget task level since we have a better one at the detail level 
		IF ISNULL(@BudgetTotal, 0) = ISNULL(@DetailTotal, 0)
		BEGIN
			SELECT @HasDetailHours = 1
			
			DELETE #tEstimateTaskLabor
			WHERE  EstimateKey = @EstimateKey
			AND    ServiceKey IS NOT NULL
		END
		
		-- otherwise we keep the labor at the budget task level
	END
END

--select * from #tEstimateTaskLabor

IF @CreateAssignments = 1
BEGIN

	-- Insert tasks per user from estimates by task and person
	INSERT #tSubtask (BudgetTaskKey, TaskKey, PlanDuration, UserKey, Hours, ServiceKey, GPFlag)
	SELECT etl.TaskKey, t.TaskKey 
			,CASE WHEN t.PlanDuration IS NULL THEN 1
						WHEN t.PlanDuration = 0 THEN 1
						ELSE t.PlanDuration
					END
			,etl.UserKey, 0, 0, 0
	FROM   #tEstimateTaskLabor etl (NOLOCK)
		INNER JOIN tTask t (NOLOCK) ON etl.TaskKey = t.BudgetTaskKey
	Where etl.UserKey is not null
    And t.ProjectKey = @ProjectKey
	AND t.TaskType = 2 -- Tracking only 
	
	-- Insert tasks per user from estimates by task and service
    -- we may have duplicates
    -- link with tProjectUserServices
    INSERT #tSubtask (BudgetTaskKey, TaskKey, PlanDuration, UserKey, Hours, ServiceKey, GPFlag)
	SELECT DISTINCT etl.TaskKey, t.TaskKey
				,CASE WHEN t.PlanDuration IS NULL THEN 1
						WHEN t.PlanDuration = 0 THEN 1
						ELSE t.PlanDuration
					END
				, pus.UserKey, 0, 0, 0
	FROM   #tEstimateTaskLabor etl (NOLOCK)
		INNER JOIN tTask t (NOLOCK) ON etl.TaskKey = t.BudgetTaskKey
		INNER JOIN tProjectUserServices pus (NOLOCK) ON etl.ServiceKey = pus.ServiceKey 
	Where etl.ServiceKey is not null
    And t.ProjectKey = @ProjectKey	
	AND t.TaskType = 2 -- Tracking only 
	And pus.ProjectKey = @ProjectKey
	
	-- Must eliminate dups, the hard way, we do not have a primary key, but 2 TaskKey and UserKey  
	SELECT @TempKey = 0
	UPDATE #tSubtask
	SET    #tSubtask.GPFlag = @TempKey
	      ,@TempKey = @TempKey + 1

	SELECT @TempKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @TempKey = MIN(GPFlag)
		FROM   #tSubtask 
		WHERE  GPFlag > @TempKey
		
		IF @TempKey IS NULL
			BREAK

		SELECT @TaskKey = TaskKey
		      ,@UserKey = UserKey
		FROM  #tSubtask 
		WHERE  GPFlag = @TempKey
		
		IF (SELECT COUNT(*) FROM #tSubtask WHERE TaskKey = @TaskKey AND UserKey = @UserKey)
				> 1
			BEGIN
				DELETE #tSubtask 
				WHERE TaskKey = @TaskKey AND UserKey = @UserKey
				AND GPFlag <> @TempKey   
			END
			
	END	
	
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
     
IF (SELECT COUNT(*) FROM #tSubtask) = 0 
BEGIN
	IF @HasDetailHours = 1
		EXEC sptTaskAssignFromEstimateDetail @ProjectKey, @CreateAssignments

	RETURN 1
END	

--SELECT * FROM #tSubtask

-- FIRST PASS !!! Estimate By Task And Person	   	
-- Loop through tEstimateTaskLabor where UserKey is not null

SELECT @BudgetTaskKey = -1
WHILE (1=1)
BEGIN
	SELECT @BudgetTaskKey = MIN(etl.TaskKey)
	FROM   #tEstimateTaskLabor etl (NOLOCK)
	Where etl.UserKey is not null
	And  etl.TaskKey > @BudgetTaskKey
    
    IF @BudgetTaskKey IS NULL
		BREAK
	
	SELECT @UserKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @UserKey = MIN(etl.UserKey)
		FROM   #tEstimateTaskLabor etl (NOLOCK)
		Where etl.UserKey is not null
		And  etl.TaskKey = @BudgetTaskKey
		And  etl.UserKey > @UserKey
		And  etl.Hours > 0
			    
		IF @UserKey IS NULL
			BREAK
				  
		-- Get number subtasks for that budget task  	
		SELECT	@NumSubtasks = COUNT(*) FROM #tSubtask 
		WHERE  	BudgetTaskKey = @BudgetTaskKey
		AND     UserKey = @UserKey
		  
	    IF @NumSubtasks > 0
	    BEGIN
	    	SELECT @UserHours = Sum(etl.Hours)
			FROM   #tEstimateTaskLabor etl (NOLOCK)
			Where etl.UserKey is not null
			And  etl.TaskKey = @BudgetTaskKey
			And  etl.UserKey = @UserKey

			SELECT @TotalDuration = SUM(PlanDuration) 
			FROM   #tSubtask 
			WHERE  BudgetTaskKey = @BudgetTaskKey
			AND    UserKey = @UserKey
		
			IF @NumSubtasks = 1
				UPDATE #tSubtask
				SET    Hours = Hours + @UserHours
				WHERE  BudgetTaskKey = @BudgetTaskKey
				AND    UserKey = @UserKey
			ELSE
			BEGIN
				UPDATE #tSubtask
				SET Hours = Hours + ROUND(@UserHours * PlanDuration / CAST(@TotalDuration AS DECIMAL(24,4)) , 2)
				WHERE  BudgetTaskKey = @BudgetTaskKey
				AND    UserKey = @UserKey
				
				-- Handle rounding errors
				SELECT @SubtaskHours = SUM(Hours)
				FROM   #tSubtask
				WHERE  BudgetTaskKey = @BudgetTaskKey
				AND    UserKey = @UserKey
				
				IF @SubtaskHours <> @UserHours
				BEGIN
					-- difference between the 2 
					SELECT @SubtaskHours = @UserHours - @SubtaskHours  
					
					-- pick up any user to apply rounding fix
					SELECT @TaskKey = MAX(TaskKey)
					FROM   #tSubtask
					WHERE  BudgetTaskKey = @BudgetTaskKey
					AND    UserKey = @UserKey
					
					UPDATE #tSubtask
					SET    Hours = Hours + @SubtaskHours 
					WHERE  BudgetTaskKey = @BudgetTaskKey
					AND    UserKey = @UserKey
					AND    TaskKey = @TaskKey
				 
				END -- IF rounding Errors
				
			END -- IF @NumSubtasks > 1
							
	    END -- IF @NumSubtasks > 0
	    	
	END	-- @UserKey	 
    
END -- @TaskKey    

-- SECOND PASS !!! Estimate By Task And Service	   	
-- Loop through tEstimateTaskLabor where TaskKey is not null and ServiceKey is not null
-- Query tProjectUserServices

SELECT @BudgetTaskKey = -1
WHILE (1=1)
BEGIN
	SELECT @BudgetTaskKey = MIN(etl.TaskKey)
	FROM   #tEstimateTaskLabor etl (NOLOCK)
	Where etl.ServiceKey is not null
	And  etl.TaskKey > @BudgetTaskKey
    
    IF @BudgetTaskKey IS NULL
		BREAK
	
	SELECT @ServiceKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ServiceKey = MIN(etl.ServiceKey)
		FROM   #tEstimateTaskLabor etl (NOLOCK)
		Where etl.ServiceKey is not null
		And  etl.TaskKey = @BudgetTaskKey
		And  etl.ServiceKey > @ServiceKey
		And  etl.Hours > 0
	    
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
	    AND    #tSubtask.BudgetTaskKey = @BudgetTaskKey
	
		-- Get number subtasks for that budget task and ServiceKey  	
		SELECT	@NumSubtasks = COUNT(*) FROM #tSubtask 
		WHERE  	BudgetTaskKey = @BudgetTaskKey
		AND     ServiceKey = @ServiceKey
	
		IF @NumSubtasks > 0
		BEGIN
			SELECT @ServiceHours = Sum(etl.Hours)
			FROM   #tEstimateTaskLabor etl (NOLOCK)
			Where etl.ServiceKey is not null
			And  etl.TaskKey = @BudgetTaskKey
			And  etl.ServiceKey = @ServiceKey
		
			SELECT @TotalDuration = SUM(PlanDuration) 
			FROM   #tSubtask 
			WHERE  BudgetTaskKey = @BudgetTaskKey
			AND  ServiceKey = @ServiceKey
		
			IF @NumSubtasks = 1
				UPDATE #tSubtask
				SET    Hours = Hours + @ServiceHours 
				WHERE  BudgetTaskKey = @BudgetTaskKey
				AND    ServiceKey = @ServiceKey
			ELSE
			BEGIN
				-- Get what we had before update
				SELECT @UserHours = SUM(Hours)
				FROM   #tSubtask 
				WHERE  BudgetTaskKey = @BudgetTaskKey
				AND    ServiceKey = @ServiceKey
		
				-- update with the service hours
				UPDATE #tSubtask
				SET    Hours = Hours + ROUND(@ServiceHours * PlanDuration / CAST(@TotalDuration AS DECIMAL(24,4)) , 2)
				WHERE  BudgetTaskKey = @BudgetTaskKey
				AND    ServiceKey = @ServiceKey
				
				-- Handle rounding errors later
				SELECT @SubtaskHours = SUM(Hours)
				FROM   #tSubtask
				WHERE  BudgetTaskKey = @BudgetTaskKey
				AND    ServiceKey = @ServiceKey
				
				IF @SubtaskHours <> (@UserHours + @ServiceHours)
				BEGIN
					-- difference between the 2 
					SELECT @SubtaskHours = (@UserHours + @ServiceHours) - @SubtaskHours  
					
					-- pick up any user to apply rounding fix
					SELECT @TaskKey = MAX(TaskKey)
					FROM   #tSubtask
					WHERE  BudgetTaskKey = @BudgetTaskKey
					AND    ServiceKey = @ServiceKey
					
					SELECT @UserKey = MAX(UserKey)
					FROM   #tSubtask
					WHERE  BudgetTaskKey = @BudgetTaskKey
					AND    ServiceKey = @ServiceKey
					AND    TaskKey = @TaskKey
					
					UPDATE #tSubtask
					SET    Hours = Hours + @SubtaskHours 
					WHERE  BudgetTaskKey = @BudgetTaskKey
					AND    ServiceKey = @ServiceKey
					AND    TaskKey = @TaskKey
					AND UserKey = @UserKey
				 
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

DROP TABLE #tSubtask

-- NOW take care of the records in tEstimateTaskAssignmentLabor
-- Do not create assignments the second time 
IF @HasDetailHours = 1
	EXEC sptTaskAssignFromEstimateDetail @ProjectKey, 0 --@CreateAssignments
 
RETURN 1
GO
