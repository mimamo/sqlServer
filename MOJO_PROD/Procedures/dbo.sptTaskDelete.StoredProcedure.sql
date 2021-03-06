USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskDelete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskDelete]
	@TaskKey int
AS --Encrypt

  /*
  || When     Who Rel   What
  || 01/02/08 GHL 8.5   Added ProjectKey when querying tTime to help with indexes
  || 01/08/10 GHL 10.516 Added check of transfer status
  || 01/11/10 GHL 10.516 (71304) Removed check of time DetailTaskKey
  */
  
declare @CurrentDisplayOrder int
declare @CurrentProjectKey int
declare @CurrentSummaryTaskKey int
declare @ProjectKey int

	SELECT @ProjectKey = ProjectKey FROM tTask (NOLOCK) WHERE TaskKey = @TaskKey
	
	IF EXISTS(SELECT 1 FROM tTask (NOLOCK) WHERE SummaryTaskKey = @TaskKey) 
		RETURN -1
		
	IF EXISTS(SELECT 1 FROM tTime (NOLOCK)  WHERE ProjectKey = @ProjectKey AND TaskKey = @TaskKey AND TransferToKey is null) 
		RETURN -2

	IF EXISTS(SELECT 1 FROM tTime (NOLOCK)  WHERE ProjectKey = @ProjectKey AND TaskKey = @TaskKey 
		AND TransferToKey is not null and WIPPostingInKey > 0) 
		RETURN -2

	IF EXISTS(SELECT 1 FROM tExpenseReceipt (NOLOCK)  WHERE TaskKey = @TaskKey AND TransferToKey is null) 
		RETURN -3

	IF EXISTS(SELECT 1 FROM tExpenseReceipt (NOLOCK)  WHERE TaskKey = @TaskKey 
		AND TransferToKey is not null and WIPPostingInKey > 0) 
		RETURN -3

	IF EXISTS(SELECT 1 FROM tPurchaseOrderDetail (NOLOCK)  WHERE TaskKey = @TaskKey AND TransferToKey is null) 
		RETURN -4
		
	IF EXISTS(SELECT 1 FROM tVoucherDetail  (NOLOCK) WHERE TaskKey = @TaskKey AND TransferToKey is null) 
		RETURN -5

	IF EXISTS(SELECT 1 FROM tVoucherDetail  (NOLOCK) WHERE TaskKey = @TaskKey 
		AND TransferToKey is not null AND WIPPostingInKey > 0) 
		RETURN -5

	IF EXISTS(SELECT 1 FROM tMiscCost (NOLOCK) WHERE TaskKey = @TaskKey AND TransferToKey is null) 
		RETURN -6
	
	IF EXISTS(SELECT 1 FROM tMiscCost (NOLOCK) WHERE TaskKey = @TaskKey 
		AND TransferToKey is not null AND WIPPostingInKey > 0) 
		RETURN -6
			
	IF EXISTS(SELECT 1 FROM tInvoiceLine  (NOLOCK) WHERE TaskKey = @TaskKey) 
		RETURN -9 -- added later
	
	-- Cannot delete if on an approved estimate
	IF EXISTS(SELECT 1 FROM tEstimateTask et (NOLOCK)
		                    ,tEstimate e (NOLOCK)  
						WHERE	et.TaskKey = @TaskKey
						AND     et.EstimateKey = e.EstimateKey
						AND     ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
								Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			  )
			  RETURN -8		
			
	IF EXISTS(SELECT 1 FROM tEstimateTaskLabor etl (NOLOCK)
		                    ,tEstimate e (NOLOCK)  
						WHERE	etl.TaskKey = @TaskKey
						AND     etl.EstimateKey = e.EstimateKey
						AND     ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
								Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			  )
			  RETURN -8			  	
			  
	IF EXISTS(SELECT 1 FROM tEstimateTaskExpense ete (NOLOCK)
		                    ,tEstimate e (NOLOCK)  
						WHERE	ete.TaskKey = @TaskKey
						AND     ete.EstimateKey = e.EstimateKey
						AND     ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
								Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			  )
			  RETURN -8			  	
					
	select @CurrentDisplayOrder = DisplayOrder
	      ,@CurrentProjectKey = ProjectKey
	      ,@CurrentSummaryTaskKey = SummaryTaskKey
	  from tTask (NOLOCK)
	 where TaskKey = @TaskKey
	 
	Begin Transaction
	
	delete tTaskUser
	 where TaskKey = @TaskKey
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	delete tTaskPredecessor
	 where TaskKey = @TaskKey
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	delete tTaskPredecessor
	 where PredecessorKey = @TaskKey
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	Delete tEstimateTaskExpense 
	Where TaskKey = @TaskKey
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	Delete tEstimateTaskLabor 
	Where TaskKey = @TaskKey
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	Delete tEstimateTaskAssignmentLabor 
	Where TaskKey = @TaskKey
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	delete tEstimateTask 
	WHERE TaskKey = @TaskKey
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	if @TaskKey > 0
	begin
	DELETE tPurchaseOrderDetail
	WHERE  TaskKey = @TaskKey
	AND    TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -99		   	
	end

	DELETE tVoucherDetail
	WHERE  TaskKey = @TaskKey
	AND    TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -99		   	
	end

	DELETE tExpenseReceipt
	WHERE  TaskKey = @TaskKey
	AND    TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -99		   	
	end

	DELETE tMiscCost
	WHERE  TaskKey = @TaskKey
	AND    TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -99		   	
	end

	DELETE tTime
	WHERE  TaskKey = @TaskKey
	AND    TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -99		   	
	end

	UPDATE tTime
	SET    DetailTaskKey = NULL
	WHERE  ProjectKey = @ProjectKey
	AND    DetailTaskKey = @TaskKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -99		   	
	end

	end -- @TaskKey > 0
	
	update tTask
	   set DisplayOrder = DisplayOrder - 1
	 where ProjectKey = @CurrentProjectKey
	   and SummaryTaskKey = @CurrentSummaryTaskKey
	   and DisplayOrder > @CurrentDisplayOrder
	   
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	update tTask
	   set BudgetTaskKey = NULL
	 where ProjectKey = @CurrentProjectKey
	   and BudgetTaskKey = @TaskKey
	   
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	 
	DELETE
	FROM tTask
	WHERE
		TaskKey = @TaskKey 
	if @@ERROR <> 0 
		begin
		rollback transaction 
		return -99
	end
	
	Commit Transaction

	RETURN 1
GO
