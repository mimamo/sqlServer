USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportEstimateTaskDetail]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportEstimateTaskDetail]
	@EstimateKey int,
	@ProjectKey int,
	@TaskID varchar(50),
	@Hours decimal(9, 3),
	@Rate money,
	@EstLabor money,
	@BudgetExpenses money,
	@Markup decimal(9, 3),
	@EstExpenses money
AS --Encrypt

Declare @TaskKey int

	SELECT	@TaskKey = TaskKey
	FROM	tTask (nolock)
	WHERE	TaskID = @TaskID
	AND		ProjectKey = @ProjectKey
	AND		MoneyTask = 1
	
	if @TaskKey is null
		Return -1
		
	if exists(Select 1 from tEstimateTask (nolock) Where EstimateKey = @EstimateKey and TaskKey = @TaskKey)
		Return -2
		
	INSERT tEstimateTask
		(
		EstimateKey,
		TaskKey,
		Hours,
		Rate,
		EstLabor,
		BudgetExpenses,
		Markup,
		EstExpenses
		)

	VALUES
		(
		@EstimateKey,
		@TaskKey,
		@Hours,
		@Rate,
		@EstLabor,
		@BudgetExpenses,
		@Markup,
		@EstExpenses
		)


Declare @SalesTax1Amount MONEY, @SalesTax2Amount MONEY
Exec sptEstimateRecalcSalesTax @EstimateKey, 1, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
Exec sptEstimateTaskRollupDetail @EstimateKey

	RETURN 1
GO
