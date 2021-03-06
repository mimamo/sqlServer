USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskDeleteMultiple]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskDeleteMultiple]
AS --Encrypt
	SET NOCOUNT ON

  /*
  || When     Who Rel   What
  || 01/02/08 GHL 8.5   Added ProjectKey when querying tTime to help with indexes
  || 01/08/10 GHL 10.516 Added check of Transfer status
  || 01/11/10 GHL 10.516 (71304) Removed check of time DetailTaskKey 
  */
  		
	declare @KeyChar varchar(100)
	declare @KeyInt int
	declare @Pos int
	declare @ProjectKey int

	IF (SELECT COUNT(*) FROM #tTask) = 0
		RETURN 1

	SELECT @ProjectKey = t.ProjectKey
	FROM	tTask t (NOLOCK)
		INNER JOIN #tTask b ON t.TaskKey = b.TaskKey

  				
/*

	-- Parse the passed keys into a temp table
	--CREATE TABLE #tTask (TaskKey int null, KeepFlag int null)
	
	IF LEN(@TaskKeys) > 0 
	BEGIN
		WHILE (1 = 1)
		BEGIN
			SELECT @Pos = CHARINDEX ('|', @TaskKeys, 1) 
			IF @Pos = 0 
				SELECT @KeyChar = @TaskKeys
			ELSE
				SELECT @KeyChar = LEFT(@TaskKeys, @Pos -1)
	  
			IF LEN(@KeyChar) > 0
			BEGIN
				SELECT @KeyInt = CONVERT(Int, @KeyChar)
	   
				INSERT #tTask (TaskKey, KeepFlag)
				VALUES (@KeyInt, 0)
	   
				IF @Pos = 0 
					BREAK
	  
				SELECT @TaskKeys = SUBSTRING(@TaskKeys, @Pos + 1, LEN(@TaskKeys)) 
			END
		END
	END

*/	  
	-- Prevent deletion if used in child tables
	UPDATE	#tTask
	SET		#tTask.KeepFlag = 1
	FROM	tTask (NOLOCK)  
	WHERE	#tTask.TaskKey = tTask.SummaryTaskKey 
		    
	UPDATE	#tTask
	SET		#tTask.KeepFlag = 2
	FROM	tTime (NOLOCK)  
	WHERE	tTime.ProjectKey = @ProjectKey
	AND     #tTask.TaskKey = tTime.TaskKey
    AND     tTime.TransferToKey is null

	UPDATE	#tTask
	SET		#tTask.KeepFlag = 2
	FROM	tTime (NOLOCK)  
	WHERE	tTime.ProjectKey = @ProjectKey
	AND     #tTask.TaskKey = tTime.TaskKey
    AND     tTime.TransferToKey is not null
    AND     tTime.WIPPostingInKey > 0
 
	UPDATE	#tTask
	SET		#tTask.KeepFlag = 3
	FROM	tExpenseReceipt (NOLOCK)  
	WHERE	#tTask.TaskKey = tExpenseReceipt.TaskKey
	AND     tExpenseReceipt.TransferToKey is null
     
	UPDATE	#tTask
	SET		#tTask.KeepFlag = 3
	FROM	tExpenseReceipt (NOLOCK)  
	WHERE	#tTask.TaskKey = tExpenseReceipt.TaskKey
	AND     tExpenseReceipt.TransferToKey is not null
	AND     tExpenseReceipt.WIPPostingInKey > 0 
	
	UPDATE	#tTask
	SET		#tTask.KeepFlag = 4
	FROM	tPurchaseOrderDetail (NOLOCK)  
	WHERE	#tTask.TaskKey = tPurchaseOrderDetail.TaskKey

	UPDATE	#tTask
	SET		#tTask.KeepFlag = 5
	FROM	tVoucherDetail (NOLOCK)  
	WHERE	#tTask.TaskKey = tVoucherDetail.TaskKey
	AND     tVoucherDetail.TransferToKey is null
	
	UPDATE	#tTask
	SET		#tTask.KeepFlag = 5
	FROM	tVoucherDetail (NOLOCK)  
	WHERE	#tTask.TaskKey = tVoucherDetail.TaskKey
	AND     tVoucherDetail.TransferToKey is not null
	AND     tVoucherDetail.WIPPostingInKey > 0
	
	UPDATE	#tTask
	SET		#tTask.KeepFlag = 6
	FROM	tMiscCost (NOLOCK)  
	WHERE	#tTask.TaskKey = tMiscCost.TaskKey
	AND     tMiscCost.TransferToKey is null
	
	UPDATE	#tTask
	SET		#tTask.KeepFlag = 6
	FROM	tMiscCost (NOLOCK)  
	WHERE	#tTask.TaskKey = tMiscCost.TaskKey
	AND     tMiscCost.TransferToKey is not null
	AND     tMiscCost.WIPPostingInKey > 0

	UPDATE	#tTask
	SET		#tTask.KeepFlag = 9
	FROM	tInvoiceLine (NOLOCK)  
	WHERE	#tTask.TaskKey = tInvoiceLine.TaskKey

	-- Cannot delete if on an approved estimate
	UPDATE	#tTask
	SET		#tTask.KeepFlag = 8
	FROM	tEstimateTask et (NOLOCK)
		   ,tEstimate e (NOLOCK)  
	WHERE	#tTask.TaskKey = et.TaskKey
	AND     et.EstimateKey = e.EstimateKey
	AND     ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
			Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
	
	UPDATE	#tTask
	SET		#tTask.KeepFlag = 8
	FROM	tEstimateTaskLabor etl (NOLOCK)
		   ,tEstimate e (NOLOCK)  
	WHERE	#tTask.TaskKey = etl.TaskKey
	AND     etl.EstimateKey = e.EstimateKey
	AND     ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
			Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			
	UPDATE	#tTask
	SET		#tTask.KeepFlag = 8
	FROM	tEstimateTaskExpense ete (NOLOCK)
		   ,tEstimate e (NOLOCK)  
	WHERE	#tTask.TaskKey = ete.TaskKey
	AND     ete.EstimateKey = e.EstimateKey
	AND     ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
			Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
				
	IF (SELECT COUNT(*) FROM #tTask WHERE KeepFlag = 0) = 0 
		RETURN 1
		
	-- Save the current orders et calculate new ones
	CREATE TABLE #tTaskOrder(TaskKey int null, SummaryTaskKey int null, OldOrder int null, NewOrder int null)
	INSERT 	#tTaskOrder
	SELECT  b.TaskKey, b.SummaryTaskKey, b.DisplayOrder, 0
	FROM    tTask b (NOLOCK)
	WHERE   b.ProjectKey = @ProjectKey
	ORDER BY b.SummaryTaskKey, b.DisplayOrder
	
	DELETE #tTaskOrder 
	FROM   #tTask
	WHERE  #tTaskOrder.TaskKey = #tTask.TaskKey
	AND    #tTask.KeepFlag = 0
	
	DECLARE @SummaryTaskKey INT
			,@TaskKey INT
			,@OldOrder INT
			,@NewOrder INT
			,@OrderCount INT
			
	SELECT @SummaryTaskKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @SummaryTaskKey = MIN(SummaryTaskKey)
		FROM   #tTaskOrder
		WHERE  SummaryTaskKey > @SummaryTaskKey
		
		IF @SummaryTaskKey IS NULL
			BREAK
			
		SELECT @OldOrder = -1
			   ,@NewOrder = 1	
		WHILE (1=1)
		BEGIN
			SELECT @OldOrder = MIN(OldOrder)
			FROM   #tTaskOrder
			WHERE  SummaryTaskKey = @SummaryTaskKey
			AND    OldOrder > @OldOrder
			
			IF @OldOrder IS NULL
				BREAK
			
			-- In case several tasks have the same order
			SELECT @OrderCount = COUNT(*)
			   FROM #tTaskOrder
			WHERE  SummaryTaskKey = @SummaryTaskKey
			AND    OldOrder = @OldOrder			
			   
			IF @OrderCount > 1
			BEGIN
				SELECT @TaskKey = -1
				WHILE (1=1)
				BEGIN
					SELECT @TaskKey = MIN(TaskKey)
					FROM   	#tTaskOrder
					WHERE  SummaryTaskKey = @SummaryTaskKey
					AND    OldOrder = @OldOrder
					AND    TaskKey > @TaskKey
					
					IF @TaskKey IS NULL
						BREAK

					UPDATE 	#tTaskOrder
					SET     NewOrder = @NewOrder
					WHERE  SummaryTaskKey = @SummaryTaskKey
					AND   OldOrder = @OldOrder
					AND    TaskKey = @TaskKey
					
					SELECT @NewOrder = @NewOrder + 1
						
				END
			END
			ELSE
			BEGIN			   
				UPDATE 	#tTaskOrder
				SET     NewOrder = @NewOrder
				WHERE  SummaryTaskKey = @SummaryTaskKey
				AND    OldOrder = @OldOrder
				
				SELECT @NewOrder = @NewOrder + 1
			END
		END
		
	END
	
	 
	-- Now start deletion
	Begin Transaction
	
	delete tTaskUser
	from   #tTask 
	where  tTaskUser.TaskKey = #tTask.TaskKey
	and    #tTask.KeepFlag = 0
	
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end

	delete tTaskPredecessor
	from   #tTask 
	where  tTaskPredecessor.TaskKey = #tTask.TaskKey
	and    #tTask.KeepFlag = 0
	
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	delete tTaskPredecessor
	from   #tTask 
	where  tTaskPredecessor.PredecessorKey = #tTask.TaskKey
	and    #tTask.KeepFlag = 0

	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end

	delete tEstimateTaskExpense
	from   #tTask 
	where  tEstimateTaskExpense.TaskKey = #tTask.TaskKey
	and    #tTask.KeepFlag = 0
	
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end

	delete tEstimateTaskLabor
	from   #tTask 
	where  tEstimateTaskLabor.TaskKey = #tTask.TaskKey
	and    #tTask.KeepFlag = 0
	
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end

	delete tEstimateTaskAssignmentLabor
	from   #tTask 
	where  tEstimateTaskAssignmentLabor.TaskKey = #tTask.TaskKey
	and    #tTask.KeepFlag = 0
	
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	delete tEstimateTask
	from   #tTask 
	where  tEstimateTask.TaskKey = #tTask.TaskKey
	and    #tTask.KeepFlag = 0
	
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	update tTask
		set tTask.DisplayOrder = b.NewOrder
	from   #tTaskOrder b
	where  tTask.TaskKey = b.TaskKey

	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	update tTask
		set tTask.BudgetTaskKey = NULL
	from   #tTask b
	where  tTask.BudgetTaskKey = b.TaskKey

	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	DELETE tPurchaseOrderDetail
    FROM   #tTask b
	WHERE  tPurchaseOrderDetail.TaskKey = b.TaskKey
	AND    b.TaskKey > 0
	AND    tPurchaseOrderDetail.TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -99		   	
	end

	DELETE tVoucherDetail
	FROM   #tTask b
	WHERE  tVoucherDetail.TaskKey = b.TaskKey
	AND    b.TaskKey > 0
	AND    tVoucherDetail.TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -99		   	
	end

	DELETE tExpenseReceipt
	FROM   #tTask b
	WHERE  tExpenseReceipt.TaskKey = b.TaskKey
	AND    b.TaskKey > 0
	AND    tExpenseReceipt.TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -99		   	
	end

	DELETE tMiscCost
	FROM   #tTask b
	WHERE  tMiscCost.TaskKey = b.TaskKey
	AND    b.TaskKey > 0
	AND    tMiscCost.TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -99		   	
	end

	DELETE tTime
	FROM   #tTask b
	WHERE  tTime.TaskKey = b.TaskKey
	AND    b.TaskKey > 0
	AND    tTime.TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -99		   	
	end

	UPDATE tTime
	SET    tTime.DetailTaskKey = NULL
	FROM   #tTask b
	WHERE  tTime.ProjectKey = @ProjectKey
	AND    b.TaskKey > 0
	AND    tTime.DetailTaskKey = b.TaskKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -99		   	
	end

	delete tTask
	from   #tTask 
	where  tTask.TaskKey = #tTask.TaskKey
	and    #tTask.KeepFlag = 0

	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
		
	Commit Transaction

	
	RETURN 1
GO
