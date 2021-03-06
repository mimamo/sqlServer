USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskCheckTransactions]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskCheckTransactions]
	(
		@ProjectKey int
	)
AS

  /*
  || When     Who Rel    What
  || 01/02/08 GHL 8.5    Added ProjectKey when querying tTime to help with indexes
  || 01/04/10 GHL 10.516 Added check of transfer status
  || 01/08/10 GHL 10.516 Added check of WIP status
  || 01/11/10 GHL 10.516 (71304) Removed check of DetailTaskKey
  || 04/14/10 GHL 10.521 (78802) Checking now amounts and rates on approved estimates
  ||                      if 0, we can delete the tasks
  || 05/6/11  rlb 10.543 (110478) if an estimate is approved internally then locked the tasks
  */
	
	SET NOCOUNT ON
	
	CREATE TABLE #tTask (TaskKey int null, ErrorNumber int null )

	INSERT #tTask(TaskKey, ErrorNumber)
	SELECT TaskKey, 0
	FROM   tTask (NOLOCK)
	WHERE  ProjectKey = @ProjectKey
	
	UPDATE #tTask
	SET    #tTask.ErrorNumber = -2
	FROM   tTime (NOLOCK)
	WHERE  tTime.ProjectKey = @ProjectKey 
	AND    tTime.TransferToKey IS NULL -- Not Transferred
	AND    #tTask.TaskKey = tTime.TaskKey
	AND    #tTask.ErrorNumber = 0
	
	UPDATE #tTask
	SET    #tTask.ErrorNumber = -2
	FROM   tTime (NOLOCK)
	WHERE  tTime.ProjectKey = @ProjectKey 
	AND    tTime.TransferToKey IS NOT NULL	-- Transferred
	AND    tTime.WIPPostingInKey > 0		-- In WIP
	AND    #tTask.TaskKey = tTime.TaskKey
	AND    #tTask.ErrorNumber = 0
	
		
	
	UPDATE #tTask
	SET    #tTask.ErrorNumber = -3
	FROM   tExpenseReceipt (NOLOCK)
	WHERE  #tTask.TaskKey = tExpenseReceipt.TaskKey
	AND    tExpenseReceipt.TransferToKey IS NULL
	AND    #tTask.ErrorNumber = 0
	
	UPDATE #tTask
	SET    #tTask.ErrorNumber = -3
	FROM   tExpenseReceipt (NOLOCK)
	WHERE  #tTask.TaskKey = tExpenseReceipt.TaskKey
	AND    tExpenseReceipt.TransferToKey IS NOT NULL
	AND    tExpenseReceipt.WIPPostingInKey > 0		-- In WIP
	AND    #tTask.ErrorNumber = 0
	
	
	
	
	UPDATE #tTask
	SET    #tTask.ErrorNumber = -4
	FROM   tPurchaseOrderDetail (NOLOCK)
	WHERE  #tTask.TaskKey = tPurchaseOrderDetail.TaskKey
	AND    tPurchaseOrderDetail.TransferToKey IS NULL
	AND    #tTask.ErrorNumber = 0

	
	
	
	UPDATE #tTask
	SET    #tTask.ErrorNumber = -5
	FROM   tVoucherDetail (NOLOCK)
	WHERE  #tTask.TaskKey = tVoucherDetail.TaskKey
	AND    tVoucherDetail.TransferToKey IS NULL
	AND    #tTask.ErrorNumber = 0
	
	UPDATE #tTask
	SET    #tTask.ErrorNumber = -5
	FROM   tVoucherDetail (NOLOCK)
	WHERE  #tTask.TaskKey = tVoucherDetail.TaskKey
	AND    tVoucherDetail.TransferToKey IS NOT NULL
	AND    tVoucherDetail.WIPPostingInKey > 0
	AND    #tTask.ErrorNumber = 0
	
	
	
		
	UPDATE #tTask
	SET    #tTask.ErrorNumber = -6
	FROM   tMiscCost (NOLOCK)
	WHERE  #tTask.TaskKey = tMiscCost.TaskKey
	AND    tMiscCost.TransferToKey IS NULL
	AND    #tTask.ErrorNumber = 0
			
	UPDATE #tTask
	SET    #tTask.ErrorNumber = -6
	FROM   tMiscCost (NOLOCK)
	WHERE  #tTask.TaskKey = tMiscCost.TaskKey
	AND    tMiscCost.TransferToKey IS NOT NULL
	AND    tMiscCost.WIPPostingInKey > 0
	AND    #tTask.ErrorNumber = 0
			
			
			
	UPDATE #tTask
	SET    #tTask.ErrorNumber = -9 -- was added later
	FROM   tInvoiceLine (NOLOCK)
	WHERE  #tTask.TaskKey = tInvoiceLine.TaskKey
	AND    #tTask.ErrorNumber = 0
	
	-- Check for approved estimates	
	UPDATE #tTask
	SET    #tTask.ErrorNumber = -8
	FROM   tEstimateTask et (NOLOCK)
			INNER JOIN tEstimate e (NOLOCK) ON e.EstimateKey = et.EstimateKey
	WHERE  #tTask.TaskKey = et.TaskKey
	AND    #tTask.ErrorNumber = 0
	AND    e.ProjectKey = @ProjectKey
	AND    ISNULL(et.EstLabor, 0) + ISNULL(et.EstExpenses, 0) <> 0
	and    e.InternalStatus = 4
						
	UPDATE #tTask
	SET    #tTask.ErrorNumber = -8
	FROM   tEstimateTaskLabor et (NOLOCK)
			INNER JOIN tEstimate e (NOLOCK) ON e.EstimateKey = et.EstimateKey
	WHERE  #tTask.TaskKey = et.TaskKey
	AND    #tTask.ErrorNumber = 0
	AND    e.ProjectKey = @ProjectKey
	AND    et.Rate <> 0
	and    e.InternalStatus = 4
	
	UPDATE #tTask
	SET    #tTask.ErrorNumber = -8
	FROM   tEstimateTaskExpense et (NOLOCK)
			INNER JOIN tEstimate e (NOLOCK) ON e.EstimateKey = et.EstimateKey
	WHERE  #tTask.TaskKey = et.TaskKey
	AND    #tTask.ErrorNumber = 0
	AND    e.ProjectKey = @ProjectKey
	and    e.InternalStatus = 4
	
	DELETE #tTask WHERE ErrorNumber = 0
		
	SELECT * FROM #tTask
	 	
	RETURN 1
GO
