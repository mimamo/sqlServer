USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptDDLaborBudget]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptDDLaborBudget]
	(
		@DDSource VARCHAR(50) -- "Project", "Task", "Item", "ExpenseReceipt", "Service"
		,@ProjectKey INT
		,@TaskKey INT
		,@ServiceKey INT
		,@TitleKey INT = null
		,@oBudgetHours DECIMAL(24, 4) OUTPUT
		,@oBudgetLabor MONEY  OUTPUT		
	)
AS

  /*
  || When     Who Rel   What
  || 02/08/07 GHL 8.4   Creation to display budget on labor DD 
  ||                    Bug 8215. Incorrect budget values when drilling down 
  ||                    from Snapshot or [No Task] row
  || 02/16/07 GHL 8.4   Added missing BEGIN/END
  || 10/17/07 GWG 8.43  Fixed services calc to include project
  || 02/16/12 GHL 10.553 (134167) calc budget labor as sum(round(hours * rate))
  || 11/18/14 GHL 10.586 Added Title for Abelson Taylor
  */

	SET NOCOUNT ON
	
	IF @DDSource = 'Project'
	BEGIN
		-- Drill down from snapshot, get info from project directly
         SELECT @oBudgetHours = ISNULL(EstHours, 0) +  ISNULL(ApprovedCOHours, 0)              
                ,@oBudgetLabor = ISNULL(EstLabor, 0) + ISNULL(ApprovedCOLabor, 0)        	
		 FROM   tProject (NOLOCK)
		 WHERE  ProjectKey = @ProjectKey		
	END
	 
	IF @DDSource = 'Task'
	BEGIN
		-- Drill down from budget screen, task grid
		IF ISNULL(@TaskKey, 0) > 0
			 -- we have a task
			SELECT @oBudgetHours = ISNULL(EstHours, 0) +  ISNULL(ApprovedCOHours, 0)              
                  ,@oBudgetLabor = ISNULL(EstLabor, 0) + ISNULL(ApprovedCOLabor, 0)        	
			FROM   tTask (NOLOCK)
			WHERE  TaskKey = @TaskKey
		ELSE
		BEGIN
			-- we drill down from the [No Task] row, we must go to the estimate
			SELECT @oBudgetHours = ISNULL(
			(
			Select Sum(etl.Hours) 
			from tEstimateTaskLabor etl (nolock)
				inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = @ProjectKey  
			and e.EstType > 1 
			and e.Approved = 1 
			and isnull(etl.TaskKey, 0) = 0 
			), 0)
			+ ISNULL(
			(
			Select Sum(et.Hours) 
			from tEstimateTask et (nolock) 
				inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey  
			Where e.ProjectKey = @ProjectKey    
			and e.EstType = 1 
			and e.Approved = 1 
			and isnull(et.TaskKey, 0) = 0 
			), 0)
	
			SELECT @oBudgetLabor = ISNULL(
			(
			Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
			from tEstimateTaskLabor etl  (nolock) 
			inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey   
			and e.EstType > 1  
			and e.Approved = 1 
			and isnull(etl.TaskKey, 0) = 0 
			), 0)
			+ ISNULL(
			(
			Select Sum(et.EstLabor)
			from tEstimateTask et  (nolock) 
			inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
			Where e.ProjectKey = @ProjectKey 
			and e.EstType = 1  
			and e.Approved = 1 
			and isnull(et.TaskKey, 0) = 0 
			), 0)
		END
	END
	 
	IF @DDSource = 'Service'
	BEGIN
		-- Drill down from budget screen, service grid	
		-- Get it from tProjectEstByItem even if @ServiceKey = 0
		SELECT @oBudgetHours = ISNULL(Qty, 0) + ISNULL(COQty, 0) 
	          ,@oBudgetLabor = ISNULL(Gross, 0) + ISNULL(COGross, 0)
		FROM   tProjectEstByItem (NOLOCK) 
		WHERE  Entity = 'tService'
		AND    EntityKey = ISNULL(@ServiceKey, 0) 
		AND	   ProjectKey = @ProjectKey	
	END
	
	IF @DDSource = 'Title'
	BEGIN
		-- Drill down from budget screen, service grid	
		-- Get it from tProjectEstByItem even if @ServiceKey = 0
		SELECT @oBudgetHours = ISNULL(Qty, 0) + ISNULL(COQty, 0) 
	          ,@oBudgetLabor = ISNULL(Gross, 0) + ISNULL(COGross, 0)
		FROM   tProjectEstByTitle (NOLOCK) 
		WHERE  TitleKey = ISNULL(@TitleKey, 0) 
		AND	   ProjectKey = @ProjectKey	
	END
	
	IF @DDSource = 'Item'
	BEGIN
		-- There is no budget labor for items
		SELECT @oBudgetHours = 0 
	          ,@oBudgetLabor = 0
	END
	 
	IF @DDSource = 'ExpenseReceipt'
	BEGIN
		-- There no budget labor for expense receipts
		SELECT @oBudgetHours = 0 
	          ,@oBudgetLabor = 0
	END
	
	 
	 
	RETURN 1
GO
