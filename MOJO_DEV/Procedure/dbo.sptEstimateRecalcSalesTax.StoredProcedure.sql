USE [MOJo_dev]
GO

/****** Object:  StoredProcedure [dbo].[sptEstimateRecalcSalesTax]    Script Date: 04/29/2016 16:39:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sptEstimateRecalcSalesTax]
	@EstimateKey int
	,@ApprovedQty smallint				-- This quantity is passed from estimate sps 
										-- or passed by the estimate report to show impact of each qty  
	,@oSalesTax1Amount MONEY OUTPUT
	,@oSalesTax2Amount MONEY OUTPUT
	
AS --Encrypt

  /*
  || When     Who Rel     What
  || 07/01/10 GHL 10.531  (84095) Added calculations when labor is taxable by service
  || 08/18/10 GHL 10.534  (86008) Added handling of 'By Project Only' estimate type
  || 11/17/14 GHL 10.586  Added support of labor taxable by title (using tEstimateTaskLaborTitle)
  || 03/05/15 GHL 10.590  Added support of labor taxable by title (using tEstimateTaskLabor.TitleKey)
  */

-- Labor taxable flags
Declare @kLaborNotTaxable int			select @kLaborNotTaxable = 0
Declare @kLaborTaxableByTask int		select @kLaborTaxableByTask = 1
Declare @kLaborTaxableByProject int		select @kLaborTaxableByProject = 2 
Declare @kLaborTaxableByService int		select @kLaborTaxableByService = 3 
Declare @kLaborTaxableByTitle int		select @kLaborTaxableByTitle = 4 

-- Estimate types
declare @kByTaskOnly int				select @kByTaskOnly = 1
declare @kByTaskService int				select @kByTaskService = 2
declare @kByTaskPerson int				select @kByTaskPerson = 3
declare @kByServiceOnly int				select @kByServiceOnly = 4
declare @kBySegmentService int			select @kBySegmentService = 5
declare @kByProjectOnly int             select @kByProjectOnly = 6
declare @kByTitleOnly int				select @kByTitleOnly = 7
declare @kBySegmentTitle int			select @kBySegmentTitle = 8

/*
if Labor is taxable by task

if @kByTaskOnly			calculate tax
if @kByTaskService		calculate tax
if @kByTaskPerson		calculate tax
if @kByServiceOnly		tax = 0
if @kBySegmentService	tax = 0

if Labor is taxable by service

if @kByTaskOnly			tax = 0
if @kByTaskService		calculate tax
if @kByTaskPerson		tax = 0
if @kByServiceOnly		calculate tax
if @kBySegmentService	calculate tax

if Labor is taxable by Title and UseTitle = 1
	calculate tax from tEstimateTaskLaborTitle
else 
	tax = 0


if Labor is taxable by Title and EstType in (@kByTitleOnly, @kBySegmentTitle)
	calculate tax from tEstimateTaskLabor.TitleKey
else 
	tax = 0

*/

Declare	@LaborTaxable tinyint
		,@Contingency decimal(24, 4)
		,@ChangeOrder tinyint
		,@EstType smallint
		,@ApprovedQtyOnEstimate int
		,@UseTitle tinyint 

		,@SalesTax1Key int
		,@SalesTax1Rate DECIMAL(24,4)
	    ,@SalesTax1Amount MONEY
	    ,@SalesTax1PiggyBack tinyint
	    ,@SalesTax2Key int
	    ,@SalesTax2Rate DECIMAL(24,4)
	    ,@SalesTax2Amount MONEY
	    ,@SalesTax2PiggyBack tinyint
	    
		,@SalesTax1LaborAmount money
		,@SalesTax1ExpenseAmount money

		,@SalesTax2LaborAmount money
		,@SalesTax2ExpenseAmount money
		
		,@LaborAmount money
		,@ExpenseAmount money
	
	
-- Get estimate info		
Select  @EstType	    = EstType 
		,@SalesTax1Key	= SalesTaxKey
		,@SalesTax2Key	= SalesTax2Key
		,@LaborTaxable	= LaborTaxable	-- 0 No Tax, 1 Taxable by Task, 2 Taxable By Project, etc...
		,@Contingency	= Contingency
		,@ChangeOrder	= ChangeOrder
		,@ApprovedQtyOnEstimate = ApprovedQty
		,@UseTitle      = isnull(UseTitle, 0) 

		,@oSalesTax1Amount = isnull(SalesTaxAmount, 0)
        ,@oSalesTax2Amount = isnull(SalesTax2Amount, 0)

from tEstimate (nolock) 
Where EstimateKey = @EstimateKey
	
-- no need to recalc taxes when the estimate is a grouping of other project estimates
if @EstType = @kByProjectOnly
	return 1

SELECT @oSalesTax1Amount = 0
      ,@oSalesTax2Amount = 0  
	
if ISNULL(@SalesTax1Key, 0) = 0
	Select @SalesTax1Rate = 0
else
	Select @SalesTax1Rate = TaxRate, @SalesTax1PiggyBack = ISNULL(PiggyBackTax, 0) from tSalesTax (nolock) 
	Where SalesTaxKey = @SalesTax1Key
	
if ISNULL(@SalesTax2Key, 0) = 0
	Select @SalesTax2Rate = 0
else
	Select @SalesTax2Rate = TaxRate, @SalesTax2PiggyBack = ISNULL(PiggyBackTax, 0) from tSalesTax (nolock) 
	Where SalesTaxKey = @SalesTax2Key
		
	
IF @SalesTax1Rate = 0 AND @SalesTax2Rate = 0	
	RETURN 1

-- Expenses
IF @SalesTax1Rate = 0 
	BEGIN
		SELECT @SalesTax1ExpenseAmount = 0
	END
	ELSE
	BEGIN
		IF @SalesTax1PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
		BEGIN
				
			IF @EstType > 1 Or (@EstType = 1 And @ApprovedQty <> @ApprovedQtyOnEstimate)
				SELECT @SalesTax1ExpenseAmount = SUM(
							 (CASE 
							 WHEN @ApprovedQty = 1 THEN ISNULL(BillableCost, 0)
							 WHEN @ApprovedQty = 2 THEN ISNULL(BillableCost2, 0)
							 WHEN @ApprovedQty = 3 THEN ISNULL(BillableCost3, 0)
							 WHEN @ApprovedQty = 4 THEN ISNULL(BillableCost4, 0)
							 WHEN @ApprovedQty = 5 THEN ISNULL(BillableCost5, 0)
							 WHEN @ApprovedQty = 6 THEN ISNULL(BillableCost6, 0)
							 END								  
							 )
					         * ISNULL(ete.Taxable, 0) * @SalesTax1Rate / 100)
				FROM   tEstimateTaskExpense ete (NOLOCK)
				WHERE  ete.EstimateKey = @EstimateKey
			ELSE				
				SELECT @SalesTax1ExpenseAmount = SUM(ISNULL(et.EstExpenses, 0) * ISNULL(t.Taxable, 0) * @SalesTax1Rate / 100)
				FROM   tEstimateTask et (NOLOCK)
					INNER JOIN tTask t (NOLOCK) ON et.TaskKey = t.TaskKey
				WHERE  et.EstimateKey = @EstimateKey			
		END
		ELSE
		BEGIN
		
			IF @EstType > 1 Or (@EstType = 1 And @ApprovedQty <> @ApprovedQtyOnEstimate) 
				SELECT @SalesTax1ExpenseAmount = SUM(
						( 
							 (CASE 
							 WHEN @ApprovedQty = 1 THEN ISNULL(BillableCost, 0)
							 WHEN @ApprovedQty = 2 THEN ISNULL(BillableCost2, 0)
							 WHEN @ApprovedQty = 3 THEN ISNULL(BillableCost3, 0)
							 WHEN @ApprovedQty = 4 THEN ISNULL(BillableCost4, 0)
							 WHEN @ApprovedQty = 5 THEN ISNULL(BillableCost5, 0)
							 WHEN @ApprovedQty = 6 THEN ISNULL(BillableCost6, 0)
							 END
							 )								  
							 + (
								(CASE 
								WHEN @ApprovedQty = 1 THEN ISNULL(BillableCost, 0)
								WHEN @ApprovedQty = 2 THEN ISNULL(BillableCost2, 0)
								WHEN @ApprovedQty = 3 THEN ISNULL(BillableCost3, 0)
								WHEN @ApprovedQty = 4 THEN ISNULL(BillableCost4, 0)
								WHEN @ApprovedQty = 5 THEN ISNULL(BillableCost5, 0)
								WHEN @ApprovedQty = 6 THEN ISNULL(BillableCost6, 0)
								END								  
								) * ISNULL(ete.Taxable2, 0) * @SalesTax2Rate / 100
							  )
						)
					    * ISNULL(ete.Taxable, 0) * @SalesTax1Rate / 100)
				FROM   tEstimateTaskExpense ete (NOLOCK)
				WHERE  ete.EstimateKey = @EstimateKey
			ELSE				
				SELECT @SalesTax1ExpenseAmount = SUM(
				(ISNULL(et.EstExpenses, 0) 
				+ (ISNULL(et.EstExpenses, 0) * ISNULL(t.Taxable2, 0) * @SalesTax2Rate / 100)
				)
					* ISNULL(t.Taxable, 0) * @SalesTax1Rate / 100)
				FROM   tEstimateTask et (NOLOCK)
					INNER JOIN tTask t (NOLOCK) ON et.TaskKey = t.TaskKey
				WHERE  et.EstimateKey = @EstimateKey			
		END
	END

IF @SalesTax2Rate = 0 
	BEGIN
		SELECT @SalesTax2ExpenseAmount = 0
	END
	ELSE
	BEGIN
		IF @SalesTax2PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
		BEGIN
			IF @EstType > 1 Or (@EstType = 1 And @ApprovedQty <> @ApprovedQtyOnEstimate)
				SELECT @SalesTax2ExpenseAmount = SUM(
							 (CASE 
							 WHEN @ApprovedQty = 1 THEN ISNULL(BillableCost, 0)
							 WHEN @ApprovedQty = 2 THEN ISNULL(BillableCost2, 0)
							 WHEN @ApprovedQty = 3 THEN ISNULL(BillableCost3, 0)
							 WHEN @ApprovedQty = 4 THEN ISNULL(BillableCost4, 0)
							 WHEN @ApprovedQty = 5 THEN ISNULL(BillableCost5, 0)
							 WHEN @ApprovedQty = 6 THEN ISNULL(BillableCost6, 0)
							 END								  
							 )
					         * ISNULL(ete.Taxable2, 0) * @SalesTax2Rate / 100)
				FROM   tEstimateTaskExpense ete (NOLOCK)
				WHERE  ete.EstimateKey = @EstimateKey
			ELSE
				SELECT @SalesTax2ExpenseAmount = SUM(ISNULL(et.EstExpenses, 0) * ISNULL(t.Taxable2, 0) * @SalesTax2Rate / 100)
				FROM   tEstimateTask et (NOLOCK)
					INNER JOIN tTask t (NOLOCK) ON et.TaskKey = t.TaskKey
				WHERE  et.EstimateKey = @EstimateKey			
			
		END
		ELSE
		BEGIN
			IF @EstType > 1 Or (@EstType = 1 And @ApprovedQty <> @ApprovedQtyOnEstimate)
				SELECT @SalesTax2ExpenseAmount = SUM(
						(
							 (CASE 
							 WHEN @ApprovedQty = 1 THEN ISNULL(BillableCost, 0)
							 WHEN @ApprovedQty = 2 THEN ISNULL(BillableCost2, 0)
							 WHEN @ApprovedQty = 3 THEN ISNULL(BillableCost3, 0)
							 WHEN @ApprovedQty = 4 THEN ISNULL(BillableCost4, 0)
							 WHEN @ApprovedQty = 5 THEN ISNULL(BillableCost5, 0)
							 WHEN @ApprovedQty = 6 THEN ISNULL(BillableCost6, 0)
							 END								  
							 )
							 + (
								(CASE 
								WHEN @ApprovedQty = 1 THEN ISNULL(BillableCost, 0)
								WHEN @ApprovedQty = 2 THEN ISNULL(BillableCost2, 0)
								WHEN @ApprovedQty = 3 THEN ISNULL(BillableCost3, 0)
								WHEN @ApprovedQty = 4 THEN ISNULL(BillableCost4, 0)
								WHEN @ApprovedQty = 5 THEN ISNULL(BillableCost5, 0)
								WHEN @ApprovedQty = 6 THEN ISNULL(BillableCost6, 0)
								END								  
								) * ISNULL(ete.Taxable, 0) * @SalesTax1Rate / 100
							 )
						)
					    * ISNULL(ete.Taxable2, 0) * @SalesTax2Rate / 100)
				FROM   tEstimateTaskExpense ete (NOLOCK)
				WHERE  ete.EstimateKey = @EstimateKey
			ELSE
				SELECT @SalesTax2ExpenseAmount = SUM(
				(ISNULL(et.EstExpenses, 0) 
				+ (ISNULL(et.EstExpenses, 0) * ISNULL(t.Taxable, 0) * @SalesTax1Rate / 100)
				)	* ISNULL(t.Taxable2, 0) * @SalesTax2Rate / 100)
				FROM   tEstimateTask et (NOLOCK)
					INNER JOIN tTask t (NOLOCK) ON et.TaskKey = t.TaskKey
				WHERE  et.EstimateKey = @EstimateKey			
				
		END
	END

/**************
*    Labor
***************/

IF @LaborTaxable = 0 -- Not Taxable
	SELECT @SalesTax1LaborAmount = 0
	      ,@SalesTax2LaborAmount = 0 

IF @LaborTaxable = @kLaborTaxableByProject  -- Taxable by project
BEGIN

	IF @EstType > @kByTaskOnly 
		SELECT @LaborAmount = SUM(round(ISNULL(etl.Hours, 0)  * ISNULL(etl.Rate, 0),2) )
		FROM   tEstimateTaskLabor etl (NOLOCK)
		WHERE  EstimateKey = @EstimateKey	
	ELSE
		SELECT @LaborAmount = SUM(ISNULL(et.EstLabor, 0) )
		FROM   tEstimateTask et (NOLOCK)
		WHERE  EstimateKey = @EstimateKey

	-- Double protection against null
	SELECT @LaborAmount = ISNULL(@LaborAmount, 0)

	IF @SalesTax1Rate = 0 
	BEGIN
		SELECT @SalesTax1LaborAmount = 0
	END
	ELSE
	BEGIN
		IF @SalesTax1PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
			SELECT @SalesTax1LaborAmount = 	@LaborAmount * @SalesTax1Rate / 100	
		ELSE
			SELECT @SalesTax1LaborAmount = (@LaborAmount + @LaborAmount * @SalesTax2Rate / 100 )* @SalesTax1Rate / 100
		
	END
	
	IF @SalesTax2Rate = 0 
	BEGIN
		SELECT @SalesTax2LaborAmount = 0
	END
	ELSE
	BEGIN
		IF @SalesTax2PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
			SELECT @SalesTax2LaborAmount = 	@LaborAmount * @SalesTax2Rate / 100	
		ELSE
			SELECT @SalesTax2LaborAmount = (@LaborAmount + @LaborAmount * @SalesTax1Rate / 100 )* @SalesTax2Rate / 100
	END
	
END

IF @LaborTaxable = @kLaborTaxableByTask  -- Labor Taxable by task
BEGIN
	IF @EstType in (@kByTaskService, @kByTaskPerson)
	BEGIN
		-- 2 = By Task/Service, 3 = By Task/Person
		-- Use tEstimateTaskLabor
		
		IF @SalesTax1Rate = 0
		BEGIN
			SELECT @SalesTax1LaborAmount = 0
		END
		ELSE
		BEGIN
			IF @SalesTax1PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
				SELECT @SalesTax1LaborAmount = SUM(
					(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * ISNULL(t.Taxable, 0) * @SalesTax1Rate / 100
					)
				FROM   tEstimateTaskLabor etl (NOLOCK)
					INNER JOIN tTask t (NOLOCK) ON etl.TaskKey = t.TaskKey
				WHERE etl.EstimateKey = @EstimateKey	
			ELSE
				SELECT @SalesTax1LaborAmount = SUM(
						((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) 
						+ (
							(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0))
							* ISNULL(t.Taxable2, 0) * @SalesTax2Rate / 100
						  )) * ISNULL(t.Taxable, 0) * @SalesTax1Rate / 100
					    )
				FROM   tEstimateTaskLabor etl (NOLOCK)
					INNER JOIN tTask t (NOLOCK) ON etl.TaskKey = t.TaskKey
				WHERE etl.EstimateKey = @EstimateKey					
		END
	
		IF @SalesTax2Rate = 0
		BEGIN
			SELECT @SalesTax2LaborAmount = 0
		END
		ELSE
		BEGIN
			IF @SalesTax2PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
				SELECT @SalesTax2LaborAmount = SUM(
					(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * ISNULL(t.Taxable2, 0) * @SalesTax2Rate / 100
					)
				FROM   tEstimateTaskLabor etl (NOLOCK)
					INNER JOIN tTask t (NOLOCK) ON etl.TaskKey = t.TaskKey
				WHERE etl.EstimateKey = @EstimateKey	
			ELSE
				SELECT @SalesTax2LaborAmount = SUM(
						((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) 
						+ (
							(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0))
							* ISNULL(t.Taxable, 0) * @SalesTax1Rate / 100
						  )) * ISNULL(t.Taxable2, 0) * @SalesTax2Rate / 100
					    )
				FROM   tEstimateTaskLabor etl (NOLOCK)
					INNER JOIN tTask t (NOLOCK) ON etl.TaskKey = t.TaskKey
				WHERE etl.EstimateKey = @EstimateKey				
		END
	END -- EstType > 1
	
	IF @EstType = @kByTaskOnly
	BEGIN
		-- EstType = 1, By Task Only
		-- Use tEstimateTask
		
		IF @SalesTax1Rate = 0
		BEGIN
			SELECT @SalesTax1LaborAmount = 0
		END
		ELSE
		BEGIN
			IF @SalesTax1PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
				SELECT @SalesTax1LaborAmount = SUM(
					(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * ISNULL(t.Taxable, 0) * @SalesTax1Rate / 100
					)
				FROM   tEstimateTask etl (NOLOCK)
					INNER JOIN tTask t (NOLOCK) ON etl.TaskKey = t.TaskKey
				WHERE etl.EstimateKey = @EstimateKey	
			ELSE
				SELECT @SalesTax1LaborAmount = SUM(
						((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) 
						+ (
							(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0))
							* ISNULL(t.Taxable2, 0) * @SalesTax2Rate / 100
						  )) * ISNULL(t.Taxable, 0) * @SalesTax1Rate / 100
					    )
				FROM   tEstimateTask etl (NOLOCK)
					INNER JOIN tTask t (NOLOCK) ON etl.TaskKey = t.TaskKey
				WHERE etl.EstimateKey = @EstimateKey					
		END
	
		IF @SalesTax2Rate = 0
		BEGIN
			SELECT @SalesTax2LaborAmount = 0
		END
		ELSE
		BEGIN
			IF @SalesTax2PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
				SELECT @SalesTax2LaborAmount = SUM(
					(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * ISNULL(t.Taxable2, 0) * @SalesTax2Rate / 100
					)
				FROM   tEstimateTask etl (NOLOCK)
					INNER JOIN tTask t (NOLOCK) ON etl.TaskKey = t.TaskKey
				WHERE etl.EstimateKey = @EstimateKey	
			ELSE
				SELECT @SalesTax2LaborAmount = SUM(
						((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) 
						+ (
							(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0))
							* ISNULL(t.Taxable, 0) * @SalesTax1Rate / 100
						  )) * ISNULL(t.Taxable2, 0) * @SalesTax2Rate / 100
					    )
				FROM   tEstimateTask etl (NOLOCK)
					INNER JOIN tTask t (NOLOCK) ON etl.TaskKey = t.TaskKey
				WHERE etl.EstimateKey = @EstimateKey				
		END
		
	END -- By Task only

	IF @EstType in (@kByServiceOnly, @kBySegmentService)
	BEGIN
			SELECT @SalesTax1LaborAmount = 0
			SELECT @SalesTax2LaborAmount = 0
	END

END -- Labor taxable by task


IF @LaborTaxable = @kLaborTaxableByService   -- Labor Taxable by service
BEGIN
	IF @EstType in (@kByTaskService, @kByServiceOnly, @kBySegmentService)
	BEGIN
		-- Use tEstimateTaskLabor
		
		IF @SalesTax1Rate = 0
		BEGIN
			SELECT @SalesTax1LaborAmount = 0
		END
		ELSE
		BEGIN
			IF @SalesTax1PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
				SELECT @SalesTax1LaborAmount = SUM(
					(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * ISNULL(s.Taxable, 0) * @SalesTax1Rate / 100
					)
				FROM   tEstimateTaskLabor etl (NOLOCK)
					INNER JOIN tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey
				WHERE etl.EstimateKey = @EstimateKey	
			ELSE
				SELECT @SalesTax1LaborAmount = SUM(
						((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) 
						+ (
							(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0))
							* ISNULL(s.Taxable2, 0) * @SalesTax2Rate / 100
						  )) * ISNULL(s.Taxable, 0) * @SalesTax1Rate / 100
					    )
				FROM   tEstimateTaskLabor etl (NOLOCK)
					INNER JOIN tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey
				WHERE etl.EstimateKey = @EstimateKey					
		END
	
		IF @SalesTax2Rate = 0
		BEGIN
			SELECT @SalesTax2LaborAmount = 0
		END
		ELSE
		BEGIN
			IF @SalesTax2PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
				SELECT @SalesTax2LaborAmount = SUM(
					(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * ISNULL(s.Taxable2, 0) * @SalesTax2Rate / 100
					)
				FROM   tEstimateTaskLabor etl (NOLOCK)
					INNER JOIN tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey
				WHERE etl.EstimateKey = @EstimateKey	
			ELSE
				SELECT @SalesTax2LaborAmount = SUM(
						((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) 
						+ (
							(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0))
							* ISNULL(s.Taxable, 0) * @SalesTax1Rate / 100
						  )) * ISNULL(s.Taxable2, 0) * @SalesTax2Rate / 100
					    )
				FROM   tEstimateTaskLabor etl (NOLOCK)
					INNER JOIN tService s (NOLOCK) ON etl.ServiceKey = s.ServiceKey
				WHERE etl.EstimateKey = @EstimateKey				
		END
	END 
	

	IF @EstType in (@kByTaskOnly, @kByTaskPerson)
	BEGIN
			SELECT @SalesTax1LaborAmount = 0
			SELECT @SalesTax2LaborAmount = 0
	END

END -- Labor taxable by service

IF @LaborTaxable = @kLaborTaxableByTitle   -- Labor Taxable by title
BEGIN
	IF @UseTitle = 1
	BEGIN
		-- Use tEstimateTaskLabor
		
		IF @SalesTax1Rate = 0
		BEGIN
			SELECT @SalesTax1LaborAmount = 0
		END
		ELSE
		BEGIN
			IF @SalesTax1PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
				SELECT @SalesTax1LaborAmount = SUM(
					(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * ISNULL(t.Taxable, 0) * @SalesTax1Rate / 100
					)
				FROM   tEstimateTaskLaborTitle etl (NOLOCK)
					INNER JOIN tTitle t (NOLOCK) ON etl.TitleKey = t.TitleKey
				WHERE etl.EstimateKey = @EstimateKey	
			ELSE
				SELECT @SalesTax1LaborAmount = SUM(
						((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) 
						+ (
							(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0))
							* ISNULL(t.Taxable2, 0) * @SalesTax2Rate / 100
						  )) * ISNULL(t.Taxable, 0) * @SalesTax1Rate / 100
					    )
				FROM   tEstimateTaskLaborTitle etl (NOLOCK)
					INNER JOIN tTitle t (NOLOCK) ON etl.TitleKey = t.TitleKey
				WHERE etl.EstimateKey = @EstimateKey					
		END
	
		IF @SalesTax2Rate = 0
		BEGIN
			SELECT @SalesTax2LaborAmount = 0
		END
		ELSE
		BEGIN
			IF @SalesTax2PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
				SELECT @SalesTax2LaborAmount = SUM(
					(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * ISNULL(t.Taxable2, 0) * @SalesTax2Rate / 100
					)
				FROM   tEstimateTaskLaborTitle etl (NOLOCK)
					INNER JOIN tTitle t (NOLOCK) ON etl.TitleKey = t.TitleKey
				WHERE etl.EstimateKey = @EstimateKey	
			ELSE
				SELECT @SalesTax2LaborAmount = SUM(
						((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) 
						+ (
							(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0))
							* ISNULL(t.Taxable, 0) * @SalesTax1Rate / 100
						  )) * ISNULL(t.Taxable2, 0) * @SalesTax2Rate / 100
					    )
				FROM   tEstimateTaskLaborTitle etl (NOLOCK)
					INNER JOIN tTitle t (NOLOCK) ON etl.TitleKey = t.TitleKey
				WHERE etl.EstimateKey = @EstimateKey				
		END
	END 
	

	IF @UseTitle = 0
	BEGIN
			SELECT @SalesTax1LaborAmount = 0
			SELECT @SalesTax2LaborAmount = 0
	END

END -- Labor taxable by Title


IF @LaborTaxable = @kLaborTaxableByTitle and @UseTitle = 0  -- Labor Taxable by title (second method)
BEGIN
	IF @EstType in (@kByTitleOnly, @kBySegmentTitle)
	BEGIN
		-- Use tEstimateTaskLabor
		
		IF @SalesTax1Rate = 0
		BEGIN
			SELECT @SalesTax1LaborAmount = 0
		END
		ELSE
		BEGIN
			IF @SalesTax1PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
				SELECT @SalesTax1LaborAmount = SUM(
					(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * ISNULL(s.Taxable, 0) * @SalesTax1Rate / 100
					)
				FROM   tEstimateTaskLabor etl (NOLOCK)
					INNER JOIN tTitle s (NOLOCK) ON etl.TitleKey = s.TitleKey
				WHERE etl.EstimateKey = @EstimateKey	
			ELSE
				SELECT @SalesTax1LaborAmount = SUM(
						((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) 
						+ (
							(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0))
							* ISNULL(s.Taxable2, 0) * @SalesTax2Rate / 100
						  )) * ISNULL(s.Taxable, 0) * @SalesTax1Rate / 100
					    )
				FROM   tEstimateTaskLabor etl (NOLOCK)
					INNER JOIN tTitle s (NOLOCK) ON etl.TitleKey = s.TitleKey
				WHERE etl.EstimateKey = @EstimateKey					
		END
	
		IF @SalesTax2Rate = 0
		BEGIN
			SELECT @SalesTax2LaborAmount = 0
		END
		ELSE
		BEGIN
			IF @SalesTax2PiggyBack = 0 OR (@SalesTax1PiggyBack = 1 AND @SalesTax2PiggyBack = 1)
				SELECT @SalesTax2LaborAmount = SUM(
					(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) * ISNULL(s.Taxable2, 0) * @SalesTax2Rate / 100
					)
				FROM   tEstimateTaskLabor etl (NOLOCK)
					INNER JOIN tTitle s (NOLOCK) ON etl.TitleKey = s.TitleKey
				WHERE etl.EstimateKey = @EstimateKey	
			ELSE
				SELECT @SalesTax2LaborAmount = SUM(
						((ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0)) 
						+ (
							(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0))
							* ISNULL(s.Taxable, 0) * @SalesTax1Rate / 100
						  )) * ISNULL(s.Taxable2, 0) * @SalesTax2Rate / 100
					    )
				FROM   tEstimateTaskLabor etl (NOLOCK)
					INNER JOIN tTitle s (NOLOCK) ON etl.TitleKey = s.TitleKey
				WHERE etl.EstimateKey = @EstimateKey				
		END
	END 
	

	ELSE
	BEGIN
			SELECT @SalesTax1LaborAmount = 0
			SELECT @SalesTax2LaborAmount = 0
	END

END -- Labor taxable by title (second method)



SELECT @SalesTax1Amount = ISNULL(@SalesTax1ExpenseAmount, 0)
					+ ISNULL(@SalesTax1LaborAmount, 0)			

SELECT @SalesTax2Amount = ISNULL(@SalesTax2ExpenseAmount, 0)
					+ ISNULL(@SalesTax2LaborAmount, 0)			


SELECT @oSalesTax1Amount = ROUND(@SalesTax1Amount, 2)
      ,@oSalesTax2Amount = ROUND(@SalesTax2Amount, 2)  
	

RETURN 1




GO


