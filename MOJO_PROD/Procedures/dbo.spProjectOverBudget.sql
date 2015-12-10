USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectOverBudget]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectOverBudget]
	(
		@ProjectKey INT
		,@TaskKey INT
		,@ItemKey INT
	)
AS -- Encrypt

/*
|| When     Who Rel   What
|| 02/07/06 GHL 8.4   Calculating budget amount from gross instead of net 
||                    Bug 8213 - Users getting warning when they had budget for task
|| 07/09/07 GHL 8.5   Added restriction on ERs
|| 07/30/07 GHL 8.5   Removed refs to expense type
|| 02/21/08 GHL 8.504 Added restriction on ERs converted to vouchers when querying by task
|| 09/18/09 GHL 10.510 (63116) Subtracting now prebilled orders tied to voucher details 
||                    otherwise we will count the costs twice
*/
	SET NOCOUNT ON
	
	IF ISNULL(@ProjectKey, 0) = 0 
		RETURN 1
	
	DECLARE @HasEstimateBudget INT
		   ,@HasCampaignBudget INT
	       ,@CompanyKey Int
		   ,@CampaignKey  Int
		   
	SELECT @CompanyKey = CompanyKey
	      ,@CampaignKey = ISNULL(CampaignKey, 0)
	FROM   tProject (NOLOCK)
	WHERE  ProjectKey = @ProjectKey

	SELECT @HasEstimateBudget = 0
	       ,@HasCampaignBudget = 0
	       		
	IF EXISTS (SELECT 1 FROM tEstimate (NOLOCK)
				   WHERE  ProjectKey = @ProjectKey
				   AND   ((isnull(ExternalApprover, 0) > 0 and  ExternalStatus = 4) 
					Or (isnull(ExternalApprover, 0) = 0 and  InternalStatus = 4))  
				  )
		SELECT @HasEstimateBudget = 1
		
	IF EXISTS (SELECT 1 FROM tCampaignBudget (NOLOCK)
				WHERE CampaignKey = @CampaignKey
				)
		SELECT @HasCampaignBudget = 1		

	-- Exit if no Estimates and no Campaign Budgets
	IF @HasEstimateBudget + @HasCampaignBudget = 0
		RETURN 1
				
	-- For task
	DECLARE @TaskBudget As Money
			,@TaskCost As Money
			,@CountEstTask As Integer
			
	IF ISNULL(@TaskKey, 0) > 0 AND @HasEstimateBudget = 1
	BEGIN	
	
		SELECT @CountEstTask = COUNT(et.EstimateTaskKey)
		FROM   tEstimateTask et (NOLOCK)
			INNER JOIN tEstimate e (NOLOCK) ON et.EstimateKey = e.EstimateKey
		WHERE  e.ProjectKey = @ProjectKey
		AND   ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
		AND   et.TaskKey = @TaskKey
		AND   isnull(et.EstExpenses, 0) > 0
		
		IF @CountEstTask = 0
			SELECT @CountEstTask = COUNT(ete.EstimateTaskExpenseKey)
			FROM   tEstimateTaskExpense ete (NOLOCK)
				INNER JOIN tEstimate e (NOLOCK) ON ete.EstimateKey = e.EstimateKey
			WHERE  e.ProjectKey = @ProjectKey
			AND   ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))  
			AND   ete.TaskKey = @TaskKey
			AND   (isnull(ete.BillableCost, 0) + isnull(ete.BillableCost2, 0) + isnull(ete.BillableCost3, 0) + isnull(ete.BillableCost4, 0) + isnull(ete.BillableCost5, 0) + isnull(ete.BillableCost6, 0)) > 0   
						 
		-- Calculate budget from gross amounts				   				   	
		IF @CountEstTask > 0				   	
			SELECT @TaskBudget = isnull(EstExpenses, 0) + isnull(ApprovedCOExpense, 0)
			FROM   tTask (NOLOCK)
			WHERE  TaskKey = @TaskKey
						
		SELECT @TaskCost = SUM(v.TotalCost)
		FROM   vProjectCosts v (NOLOCK)
		WHERE  v.ProjectKey = @ProjectKey
		AND    v.TaskKey = @TaskKey
		AND    v.LinkVoucherDetailKey IS NULL
					
		SELECT @TaskCost = isnull(@TaskCost, 0)
					
		-- subtract prebilled orders tied to a voucher to avoid double dipping
		SELECT @TaskCost = @TaskCost - ISNULL((
			SELECT SUM(pod.TotalCost)
			FROM   tPurchaseOrderDetail pod (nolock)
			INNER JOIN tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
			WHERE pod.ProjectKey = @ProjectKey
			AND   vd.ProjectKey = @ProjectKey
			AND   pod.TaskKey = @TaskKey
			AND   vd.TaskKey = @TaskKey
			AND   pod.InvoiceLineKey > 0
		),0)
					
		IF @TaskBudget IS NULL
			RETURN -1	-- No Budget for that task
		ELSE
			BEGIN
				IF @TaskBudget >= @TaskCost
					RETURN 1 -- OK
				ELSE
					RETURN -2  -- Over Budget		
			END		
			
	END
	
	IF ISNULL(@ItemKey, 0) = 0
		RETURN 1
		
	-- For Item
	DECLARE @ItemEstimateBudget As Money
		   ,@ItemEstimateCost AS Money
	       ,@ItemCampaignBudget As Money
	       ,@ItemCampaignCost As Money
	       
	IF ISNULL(@ItemKey, 0) > 0 AND @HasEstimateBudget = 1
	BEGIN			
		SELECT @ItemEstimateBudget = isnull(Net, 0)
		FROM   tProjectEstByItem (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		AND    Entity = 'tItem'
		AND    EntityKey = @ItemKey
		
		SELECT @ItemEstimateCost = SUM(v.TotalCost)
		FROM   vProjectCosts v (NOLOCK)
			INNER JOIN tItem i (NOLOCK) ON v.ItemID = i.ItemID
		WHERE  v.ProjectKey = @ProjectKey
		AND    v.Type IN ('MISCCOST', 'VOUCHER', 'ORDER') -- Do not take labor and expense receipts
		AND    i.ItemKey = @ItemKey
		
		
		SELECT @ItemEstimateCost = isnull(@ItemEstimateCost, 0) 

		-- subtract prebilled orders tied to a voucher to avoid double dipping
		SELECT @ItemEstimateCost = @ItemEstimateCost - ISNULL((
			SELECT SUM(pod.TotalCost)
			FROM   tPurchaseOrderDetail pod (nolock)
			INNER JOIN tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
			WHERE pod.ProjectKey = @ProjectKey
			AND   vd.ProjectKey = @ProjectKey
			AND   pod.ItemKey = @ItemKey
			AND   vd.ItemKey = @ItemKey
			AND   pod.InvoiceLineKey > 0
		),0)

		IF @HasCampaignBudget = 0
		BEGIN
			-- If no campaign, we can return right away					
			IF @ItemEstimateBudget IS NULL
				RETURN -1	-- No Budget for that item
			ELSE
				BEGIN
					IF @ItemEstimateBudget >= @ItemEstimateCost
						RETURN 1 -- OK
					ELSE
						RETURN -2  -- Over Budget		
				END		
		END
		
	END 		
		
	IF ISNULL(@ItemKey, 0) > 0 AND @HasCampaignBudget = 1
	BEGIN
		SELECT @ItemCampaignBudget = SUM(Net)
		FROM   tCampaignBudget (NOLOCK)
		WHERE  CampaignKey = @CampaignKey
	
		IF NOT EXISTS (SELECT 1 
						FROM  tCampaignBudgetItem (NOLOCK)
						WHERE CampaignKey = @CampaignKey
						AND   Entity = 'Item'		
						AND   EntityKey = @ItemKey
					   )
			SELECT @ItemCampaignBudget = NULL  -- No Campaign Budget for that item

		SELECT @ItemCampaignCost = ISNULL((Select Sum(ROUND(CostRate * ActualHours, 2)) from tTime t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where p.CompanyKey = @CompanyKey
			And   p.CampaignKey = @CampaignKey 
			And t.ServiceKey in (Select EntityKey from tCampaignBudgetItem (nolock) 
									Where Entity = 'Service' and 
									CampaignKey = @CampaignKey)), 0)

			+ ISNULL((Select Sum(TotalCost) from tVoucherDetail vd (nolock)
			inner join tProject p (nolock) on vd.ProjectKey = p.ProjectKey 
			Where p.CompanyKey = @CompanyKey
			And   p.CampaignKey = @CampaignKey 
			And   vd.ItemKey in (Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'Item' and 
				CampaignKey = @CampaignKey)), 0)

			+ ISNULL((Select Sum(mc.TotalCost) from tMiscCost mc (nolock)
			inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey 
			Where p.CompanyKey = @CompanyKey
			And   p.CampaignKey = @CampaignKey 
			And   mc.ItemKey in (Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'Item' and 
				CampaignKey =  @CampaignKey)), 0)

			+ ISNULL((Select Sum(ActualCost) from tExpenseReceipt er (nolock)
			inner join tProject p (nolock) on er.ProjectKey = p.ProjectKey 
			Where p.CompanyKey = @CompanyKey
			And   p.CampaignKey = @CampaignKey 
			And   er.VoucherDetailKey is null
			And   er.ItemKey in (Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'Item' and 
				CampaignKey = @CampaignKey)), 0)

			+ ISNULL((Select Sum(TotalCost) from tPurchaseOrderDetail pod (nolock)
			inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey 
			Where p.CompanyKey = @CompanyKey
			And   p.CampaignKey = @CampaignKey 
			And   pod.ItemKey in (Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'Item' and 
				CampaignKey = @CampaignKey)), 0)
			
			- ISNULL((Select Sum(pod.TotalCost) from tPurchaseOrderDetail pod (nolock)
			inner join tProject p (nolock) on pod.ProjectKey = p.ProjectKey 
			inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey 
			Where p.CompanyKey = @CompanyKey
			And   p.CampaignKey = @CampaignKey 
			And   pod.InvoiceLineKey > 0
			And   pod.ItemKey in (Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'Item' and 
				CampaignKey = @CampaignKey)), 0)
			
		
		SELECT @ItemCampaignCost = isnull(@ItemCampaignCost, 0) 						
						
	END
	       	
	       	
	-- Compare budget ant cost on Estimates and Campaign Budgets
	IF ISNULL(@ItemKey, 0) > 0
	BEGIN
		IF @ItemEstimateBudget IS NOT NULL  
		BEGIN
			IF @ItemEstimateBudget >= @ItemEstimateCost
			BEGIN
				RETURN 1 -- OK
			END
			ELSE
			BEGIN
				IF @ItemCampaignBudget IS NOT NULL
				BEGIN
					IF @ItemCampaignBudget >= @ItemCampaignCost
						RETURN 1 -- OK
					ELSE
						RETURN -2 -- Under Budget  
				END 
				ELSE
					RETURN -2 -- Under Budget
			END
		END
		ELSE
		BEGIN
			-- ItemBudget is NULL
			IF @ItemCampaignBudget IS NOT NULL
			BEGIN
				IF @ItemCampaignBudget >= @ItemCampaignCost
					RETURN 1 -- OK
				ELSE
					RETURN -2 -- Under Budget  		
			END
			ELSE
				RETURN -1 -- No Budget
		END
	END
		
	RETURN 1
GO
