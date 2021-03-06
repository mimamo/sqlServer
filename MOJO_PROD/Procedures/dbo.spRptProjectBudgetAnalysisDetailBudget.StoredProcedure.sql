USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectBudgetAnalysisDetailBudget]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectBudgetAnalysisDetailBudget]
	(
		@CompanyKey int
		,@ProjectKey int
		,@GroupBy int -- 1 Project, 2 Task, 3 Item, 4 Service
		,@TaskKey int			-- NULL or -1 [No Task] or valid TaskKey
		,@Entity varchar(50)	-- NULL or tService or tItem or tWorkType 
		,@EntityKey int			-- NULL or 0 [No Service]/[No Item] or ServiceKey or ItemKey
		,@DataField VARCHAR(100)	-- One of the columns in the temp table in spRptProjectBudgetAnalysis
	)
AS --Encrypt

	SET NOCOUNT ON

 /*
  || When     Who Rel   What
  || 11/19/07 GHL 8.5   New budget drill downs
  || 08/08/08 GHL 10.0.0.6 (30969) Fixed problem with NULL @Entity 
  || 02/16/12 GHL 10.553   (134167) calc labor as sum(round(hours * rate))
  */
 
	IF @GroupBy = 1
		SELECT @TaskKey = NULL, @Entity = NULL, @EntityKey = NULL
	IF @GroupBy = 2
		SELECT @EntityKey = NULL, @Entity = NULL
	IF @GroupBy >= 3
		SELECT @TaskKey = NULL
	
	DECLARE @ChangeOrder INT
			
	IF SUBSTRING(@DataField, 1, 2) = 'CO'
		SELECT @ChangeOrder = 1
	IF SUBSTRING(@DataField, 1, 8) = 'Original'
		SELECT @ChangeOrder = 0
	-- Else all budget CO AND Original	 
	 			
	-- Now we can remove the PREFIX 
	SELECT @DataField = REPLACE(@DataField, 'CO', '')
	SELECT @DataField = REPLACE(@DataField, 'Original', '')
	SELECT @DataField = REPLACE(@DataField, 'Current', '')
	
	 			
	CREATE TABLE #tEstimate(
		TransactionType VARCHAR(100) NULL -- for compatibility with actuals
		,HeaderKey INT NULL -- for compatibility with actuals
		,DetailKey VARCHAR(100) NULL -- for compatibility with actuals	 
		,EstimateName VARCHAR(100) NULL
		,EstimateDate SMALLDATETIME NULL
		,TaskName VARCHAR(200) NULL
		,ItemName VARCHAR(200) NULL
		,Hours DECIMAL(24,4) NULL
		,LaborNet MONEY NULL
		,LaborGross MONEY NULL
		,Quantity DECIMAL(24,4) NULL
		,ExpenseNet MONEY NULL
		,ExpenseGross MONEY NULL
		,TotalBudget MONEY NULL
		,Contingency MONEY NULL
		,TotalBudgetCont MONEY NULL
		,SalesTaxAmount MONEY NULL
		)
		
		
	INSERT #tEstimate(TransactionType, HeaderKey, DetailKey
					, EstimateName, EstimateDate, TaskName, ItemName
					,Hours , LaborNet, LaborGross
					,Quantity, ExpenseNet, ExpenseGross, Contingency)
	SELECT 'ESTIMATE', e.EstimateKey, CAST(e.EstimateKey as VARCHAR(100)), e.EstimateName, e.EstimateDate
	,ISNULL(t.TaskID + '-', '') + t.TaskName, NULL
	,et.Hours
	, ROUND(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate),2)
	,et.EstLabor
	,0 -- see sptEstimateRollupDetail
	,et.BudgetExpenses
	,et.EstExpenses   
	,0
	FROM    vEstimateApproved e (NOLOCK) 
		INNER JOIN tEstimateTask et (NOLOCK) ON e.EstimateKey = et.EstimateKey
		INNER JOIN tTask t (nolock) on et.TaskKey = t.TaskKey 
	WHERE   e.ProjectKey = @ProjectKey
	AND     e.Approved = 1
	AND     e.EstType = 1
	AND     (@ChangeOrder IS NULL OR (e.ChangeOrder = @ChangeOrder))
	And     (@TaskKey IS NULL OR (ISNULL(et.TaskKey, -1) = @TaskKey))
	And     (@Entity IS NULL OR (@Entity = 'tService'))
			
	
	INSERT #tEstimate(TransactionType, HeaderKey, DetailKey
					, EstimateName, EstimateDate, TaskName, ItemName
					,Hours , LaborNet, LaborGross
					,Quantity, ExpenseNet, ExpenseGross, Contingency)
	SELECT 'ESTIMATE', e.EstimateKey, CAST(e.EstimateKey as VARCHAR(100)), e.EstimateName, e.EstimateDate
	,ISNULL(t.TaskID + '-', '') + t.TaskName
	,CASE WHEN etl.UserKey IS NOT NULL THEN ISNULL(u.FirstName + ' ', '') + ISNULL(u.LastName, '')
		  ELSE ISNULL(s.Description, '')
	END
	,etl.Hours
	, ROUND(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate),2)
	, ROUND(ISNULL(etl.Hours, 0) * etl.Rate,2)
	,0 
	,0
	,0   
	,0
	FROM    vEstimateApproved e (NOLOCK) 
		INNER JOIN tEstimateTaskLabor etl (NOLOCK) ON e.EstimateKey = etl.EstimateKey
		LEFT JOIN tTask t (nolock) on etl.TaskKey = t.TaskKey 
		LEFT JOIN tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey
		LEFT JOIN tUser u (NOLOCK) ON etl.UserKey = u.UserKey
	WHERE   e.ProjectKey = @ProjectKey
	AND     e.Approved = 1
	AND     e.EstType > 1
	AND     (@ChangeOrder IS NULL OR (e.ChangeOrder = @ChangeOrder))
	And     (@TaskKey IS NULL OR (ISNULL(etl.TaskKey, -1) = @TaskKey))
	And     (@Entity IS NULL OR (@Entity = 'tService' AND ISNULL(etl.ServiceKey, 0) = @EntityKey))
								
	INSERT #tEstimate(TransactionType, HeaderKey, DetailKey
					, EstimateName, EstimateDate, TaskName, ItemName
					,Hours , LaborNet, LaborGross
					,Quantity, ExpenseNet, ExpenseGross, Contingency)
	SELECT 'ESTIMATE', e.EstimateKey, CAST(e.EstimateKey as VARCHAR(100)), e.EstimateName, e.EstimateDate
	,ISNULL(t.TaskID + '-', '') + t.TaskName, ISNULL(i.ItemName, '')
	,0
	,0
	,0
	,case 
	when e.ApprovedQty = 1 Then ete.Quantity
	when e.ApprovedQty = 2 Then ete.Quantity2
	when e.ApprovedQty = 3 Then ete.Quantity3
	when e.ApprovedQty = 4 Then ete.Quantity4
	when e.ApprovedQty = 5 Then ete.Quantity5
	when e.ApprovedQty = 6 Then ete.Quantity6											 
	end
	 
	,case 
	when e.ApprovedQty = 1 Then ete.TotalCost
	when e.ApprovedQty = 2 Then ete.TotalCost2
	when e.ApprovedQty = 3 Then ete.TotalCost3
	when e.ApprovedQty = 4 Then ete.TotalCost4
	when e.ApprovedQty = 5 Then ete.TotalCost5
	when e.ApprovedQty = 6 Then ete.TotalCost6											 
	end
	,case 
	when e.ApprovedQty = 1 Then ete.BillableCost
	when e.ApprovedQty = 2 Then ete.BillableCost2
	when e.ApprovedQty = 3 Then ete.BillableCost3
	when e.ApprovedQty = 4 Then ete.BillableCost4
	when e.ApprovedQty = 5 Then ete.BillableCost5
	when e.ApprovedQty = 6 Then ete.BillableCost6											 
	end   
	,0
	FROM    vEstimateApproved e (NOLOCK) 
		INNER JOIN tEstimateTaskExpense ete (NOLOCK) ON e.EstimateKey = ete.EstimateKey
		LEFT JOIN tTask t (nolock) on ete.TaskKey = t.TaskKey 
		LEFT JOIN tItem i (NOLOCK) ON ete.ItemKey = i.ItemKey
	WHERE   e.ProjectKey = @ProjectKey
	AND     e.Approved = 1
	AND     e.EstType > 1
	AND     (@ChangeOrder IS NULL OR (e.ChangeOrder = @ChangeOrder))
	And     (@TaskKey IS NULL OR (ISNULL(t.TaskKey, -1) = @TaskKey))
	And     (@Entity IS NULL OR (@Entity = 'tItem' AND ISNULL(ete.ItemKey, 0) = @EntityKey))
		
	-- If by project add the sales tax as separate rows
	-- we cannot show the taxes per line or on the task_money.aspx
	IF @GroupBy = 1
	BEGIN
		INSERT #tEstimate(TransactionType, HeaderKey, DetailKey
						, EstimateName, EstimateDate, TaskName, ItemName
						,Hours , LaborNet, LaborGross
						,Quantity, ExpenseNet, ExpenseGross, SalesTaxAmount)
		SELECT 'ESTIMATE', e.EstimateKey, CAST(e.EstimateKey as VARCHAR(100)), e.EstimateName, e.EstimateDate
				,NULL, 'Sales Taxes'
				,0, 0, 0, 0, 0, 0, ISNULL(e.SalesTaxAmount, 0) + ISNULL(e.SalesTax2Amount, 0) 
		FROM    vEstimateApproved e (NOLOCK) 
		WHERE   e.ProjectKey = @ProjectKey
		AND     e.Approved = 1
		AND     (@ChangeOrder IS NULL OR (e.ChangeOrder = @ChangeOrder))
		AND     (ISNULL(e.SalesTaxAmount, 0) + ISNULL(e.SalesTax2Amount, 0)) <> 0
	END
	
	UPDATE #tEstimate SET #tEstimate.Contingency = (#tEstimate.LaborGross * e.Contingency)/100
	FROM   tEstimate e (NOLOCK)
	WHERE  #tEstimate.HeaderKey = e.EstimateKey
	
	UPDATE #tEstimate 
	SET TotalBudget = ISNULL(LaborGross, 0) + ISNULL(ExpenseGross, 0) + ISNULL(SalesTaxAmount, 0)	
		,TotalBudgetCont = ISNULL(LaborGross, 0) + ISNULL(ExpenseGross, 0) + ISNULL(SalesTaxAmount, 0) + ISNULL(Contingency, 0)
	
	SELECT * FROM #tEstimate
		
	RETURN 1
GO
