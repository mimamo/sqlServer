USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskCheckResetTrackBudget]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskCheckResetTrackBudget]
	(
		@TaskKey INT
	)
AS -- Encrypt

/*
|| When     Who Rel  What
|| 12/19/06 CRG 8.4  Modified to check for Task in any Estimates, not just approved.
|| 12/27/06 GHL 8.4  Added check of negative TaskKeys causing problems in import.
|| 1/8/10   GHL 10.516 Added check of transfer status
|| 5/13/10  GHL 10.5.2.3 (80489) Added checking of rate and amounts on tEstimateTask and
||                        tEstimateTaskLabor before preventing from resetting the TrackBudget flag
||                        One reason is that tEstimateTask records are saved even if amounts = 0
|| 02/01/11 GHL 10.540   (102327) Added ProjectKey in where clause when checking estimates
||                        because opportunities will have that same task key
*/
	
	if @TaskKey <= 0
		return 1

	SET NOCOUNT ON

	declare @ProjectKey int
	select @ProjectKey = ProjectKey from tTask (nolock) where TaskKey = @TaskKey
	
	IF EXISTS(SELECT 1 FROM tTime (NOLOCK) WHERE TaskKey = @TaskKey AND TransferToKey IS NULL) 
			RETURN -2
		IF EXISTS(SELECT 1 FROM tExpenseReceipt (NOLOCK) WHERE TaskKey = @TaskKey AND TransferToKey IS NULL) 
			RETURN -3
		IF EXISTS(SELECT 1 FROM tMiscCost (NOLOCK) WHERE TaskKey = @TaskKey AND TransferToKey IS NULL) 
			RETURN -4
		IF EXISTS(SELECT 1 FROM tVoucherDetail (NOLOCK) WHERE TaskKey = @TaskKey AND TransferToKey IS NULL) 
			RETURN -5
		IF EXISTS(SELECT 1 FROM tPurchaseOrderDetail (NOLOCK) WHERE TaskKey = @TaskKey AND TransferToKey IS NULL) 
			RETURN -6
		IF EXISTS(SELECT 1 FROM tQuoteDetail (NOLOCK) WHERE TaskKey = @TaskKey) 
			RETURN -7

	IF EXISTS(SELECT 1 FROM tTime (NOLOCK) WHERE TaskKey = @TaskKey AND TransferToKey IS NOT NULL AND WIPPostingInKey > 0) 
			RETURN -2
		IF EXISTS(SELECT 1 FROM tExpenseReceipt (NOLOCK) WHERE TaskKey = @TaskKey AND TransferToKey IS NOT NULL AND WIPPostingInKey > 0) 
			RETURN -3
		IF EXISTS(SELECT 1 FROM tMiscCost (NOLOCK) WHERE TaskKey = @TaskKey AND TransferToKey IS NOT NULL AND WIPPostingInKey > 0) 
			RETURN -4
		IF EXISTS(SELECT 1 FROM tVoucherDetail (NOLOCK) WHERE TaskKey = @TaskKey AND TransferToKey IS NOT NULL AND WIPPostingInKey > 0) 
			RETURN -5
			
		-- Check for estimates	
	IF EXISTS(SELECT 1 FROM tEstimateTask et (NOLOCK)
					INNER JOIN tEstimate e (NOLOCK) ON e.EstimateKey = et.EstimateKey
					WHERE et.TaskKey = @TaskKey
					AND   e.ProjectKey = @ProjectKey
					AND    ISNULL(et.EstLabor, 0) + ISNULL(et.EstExpenses, 0) <> 0
					) 
		RETURN -9
		
	IF EXISTS(SELECT 1 FROM tEstimateTaskExpense ete (NOLOCK)
					INNER JOIN tEstimate e (NOLOCK) ON e.EstimateKey = ete.EstimateKey
					WHERE ete.TaskKey = @TaskKey
					AND   e.ProjectKey = @ProjectKey
					) 
		RETURN -9

	IF EXISTS(SELECT 1 FROM tEstimateTaskLabor etl (NOLOCK)
					INNER JOIN tEstimate e (NOLOCK) ON e.EstimateKey = etl.EstimateKey
					WHERE etl.TaskKey = @TaskKey
					AND   e.ProjectKey = @ProjectKey
					AND   etl.Rate <> 0
					) 
		RETURN -9
			
	RETURN 1
GO
