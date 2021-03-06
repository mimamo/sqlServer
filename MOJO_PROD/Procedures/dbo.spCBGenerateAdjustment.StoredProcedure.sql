USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCBGenerateAdjustment]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCBGenerateAdjustment]
	(
		@CBBatchKey INT
	)
AS --Encrypt

/*
|| When      Who Rel     What
|| 03/07/08  GHL 8.5.0.6 LLNL 2008 CBCode to Project/Task conversion
||                       Removed validation of GL accounts since they are not used anymore in the Feeder file
*/
	SET NOCOUNT ON
	
	
	DECLARE @CompanyKey INT
			,@StartDate SMALLDATETIME
			,@EndDate SMALLDATETIME
			,@Adjusted INT
			,@LaborRateSheetKey INT
			,@ExpRateSheetKey INT
						
	SELECT @CompanyKey = CompanyKey 
		  ,@StartDate = StartDate 
		  ,@EndDate = EndDate
		  ,@Adjusted = Adjusted
		  ,@LaborRateSheetKey = LaborRateSheetKey	
		  ,@ExpRateSheetKey = ExpRateSheetKey
	FROM   tCBBatch (NOLOCK)
	WHERE  CBBatchKey = @CBBatchKey

	IF @Adjusted = 1
		RETURN -1

	-- Undo previous posting
	DELETE tCBPosting WHERE CBBatchKey = @CBBatchKey
	
	UPDATE tCBBatch
	SET    Adjusted = 0
	WHERE  CBBatchKey IN (SELECT BatchKey FROM tCBBatchAdjustment (NOLOCK) WHERE AdjustmentBatchKey = @CBBatchKey)
	AND    CBBatchKey NOT IN (SELECT BatchKey FROM tCBBatchAdjustment (NOLOCK) WHERE AdjustmentBatchKey <> @CBBatchKey)
	
	DELETE tCBBatchAdjustment WHERE AdjustmentBatchKey = @CBBatchKey

	-- Update all existing projects to use the new rates	
	UPDATE tProject
	SET	   GetRateFrom = 5,
		   TimeRateSheetKey = @LaborRateSheetKey,
		   GetMarkupFrom = 4,
		   ItemRateSheetKey = @ExpRateSheetKey
	WHERE  CompanyKey = @CompanyKey	
	
	-- Update any unbilled transactions with the new rates
	/*
	Note to John Koenig from LLNL
	
	I was using an existing field in our tables called WIPPostingInKey 
	This is set when generating a regular batch to the CBBatchKey (in spCBGenerateBatch)
	By removing from the where clause the check below we will update all past transactions with the new rates
	(i.e. not only the unbilled transactions)
	
	*/
	
	UPDATE tMiscCost 
	SET    tMiscCost.Markup = irsd.Markup
		  ,tMiscCost.BillableCost = 
		  CASE 
			WHEN ISNULL(tMiscCost.Billable, 0) = 0 THEN 0
			WHEN irsd.Markup IS NULL THEN tMiscCost.BillableCost
			ELSE (tMiscCost.TotalCost * (1 + irsd.Markup / 100)) 
		  END
	FROM   tProject p (NOLOCK)	
		  ,tItemRateSheetDetail irsd (NOLOCK) 
	WHERE  tMiscCost.ProjectKey = p.ProjectKey
	AND    p.CompanyKey = @CompanyKey
	AND    tMiscCost.ItemKey = irsd.ItemKey
	AND    irsd.ItemRateSheetKey = @ExpRateSheetKey
	AND	   tMiscCost.ExpenseDate >= @StartDate
	AND	   tMiscCost.ExpenseDate <= @EndDate	
	--AND	   ISNULL(tMiscCost.WIPPostingInKey, 0) = 0 -- Removed at John Koenig's request on 6/16/06
	
	
	UPDATE tTime 
	SET    tTime.ActualRate = 
		CASE WHEN tTime.RateLevel = 1 THEN trsd.HourlyRate1
			 WHEN tTime.RateLevel = 2 THEN trsd.HourlyRate2
			 WHEN tTime.RateLevel = 3 THEN trsd.HourlyRate3
			 WHEN tTime.RateLevel = 4 THEN trsd.HourlyRate4
			 WHEN tTime.RateLevel = 5 THEN trsd.HourlyRate5
			 ELSE trsd.HourlyRate1
		END	
	FROM   tProject p (NOLOCK)	
		  ,tTimeRateSheetDetail trsd (NOLOCK)	
	WHERE  tTime.ProjectKey = p.ProjectKey
	AND    p.CompanyKey = @CompanyKey
	AND    tTime.ServiceKey = trsd.ServiceKey
	AND    trsd.TimeRateSheetKey = @LaborRateSheetKey
	AND	   tTime.WorkDate >= @StartDate
	AND	   tTime.WorkDate <= @EndDate	
	--AND	   ISNULL(tTime.WIPPostingInKey, 0) = 0 -- Removed at John Koenig's request on 6/16/06


	-- Get batches to adjust
	BEGIN TRANSACTION

	INSERT tCBBatchAdjustment (AdjustmentBatchKey, BatchKey)
	SELECT @CBBatchKey, CBBatchKey
	FROM   tCBBatch (NOLOCK)
	WHERE  EndDate <= @EndDate
	AND    StartDate >= @StartDate		 
	AND    CBBatchKey <> @CBBatchKey		

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END
	
	UPDATE tCBBatch
	SET    Adjusted = 1
	WHERE  CBBatchKey IN (SELECT BatchKey FROM tCBBatchAdjustment (NOLOCK) WHERE AdjustmentBatchKey = @CBBatchKey)

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END

	COMMIT TRANSACTION
	
	-- Get transactions involved in adjusted batches
	CREATE TABLE #tTran (ProjectKey INT NULL
						,MiscCostKey INT NULL
						,ItemKey INT NULL
						,TimeKey UNIQUEIDENTIFIER NULL
						,ServiceKey INT NULL
						,GLAccountKey INT NULL
						,RateLevel INT NULL
						,ActualHours DECIMAL(24, 4) NULL
						,Amount MONEY NULL)
	
	/* Assume done in web page
	CREATE TABLE #tProj (ProjectKey INT NULL
						,Amount MONEY NULL
						,TotalPercentage DECIMAL(24,4) NULL)
	*/
												
	INSERT  #tTran (ProjectKey, MiscCostKey, ItemKey, GLAccountKey, Amount)
	SELECT	mc.ProjectKey, mc.MiscCostKey, mc.ItemKey, ISNULL(i.SalesAccountKey, 0), 
		CASE WHEN mc.Billable = 0 THEN 0 ELSE mc.TotalCost END 
	FROM    tCBBatchAdjustment ba (NOLOCK)			
		INNER JOIN tMiscCost mc (NOLOCK) ON mc.WIPPostingInKey = ba.BatchKey
		INNER JOIN tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tItem i (NOLOCK) ON mc.ItemKey = i.ItemKey	
	WHERE   ba.AdjustmentBatchKey = @CBBatchKey
	AND     p.CompanyKey = @CompanyKey
	AND     ISNULL(p.NonBillable, 0) = 0	-- Added at Lenda's request on 11/04/2005
 
	INSERT  #tTran (ProjectKey, TimeKey, ServiceKey, GLAccountKey, RateLevel, ActualHours, Amount)
	SELECT	t.ProjectKey, t.TimeKey, t.ServiceKey, ISNULL(s.GLAccountKey, 0), t.RateLevel, t.ActualHours, 0
	FROM    tCBBatchAdjustment ba (NOLOCK)			
		INNER JOIN tTime t (NOLOCK) ON t.WIPPostingInKey = ba.BatchKey
		INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey	
	WHERE   ba.AdjustmentBatchKey = @CBBatchKey
	AND     p.CompanyKey = @CompanyKey
	AND     ISNULL(p.NonBillable, 0) = 0	-- Added at Lenda's request on 11/04/2005


--select 'Initial Trans'
--select * from #tTran

	-- Validate Item, service and GL accounts
	IF EXISTS (SELECT 1
				FROM  #tTran
				WHERE TimeKey IS NOT NULL
				AND   ISNULL(ServiceKey, 0) = 0)
		RETURN -2

/*		
	IF EXISTS (SELECT 1
				FROM  #tTran
				WHERE TimeKey IS NOT NULL 
				AND   ISNULL(ServiceKey, 0) > 0
				AND   ISNULL(GLAccountKey, 0) = 0 )
		RETURN -3
*/
		
	IF EXISTS (SELECT 1
				FROM  #tTran
				WHERE MiscCostKey > 0 
				AND   ISNULL(ItemKey, 0) = 0)
		RETURN -4

/*		
	IF EXISTS (SELECT 1
				FROM  #tTran
				WHERE MiscCostKey > 0 
				AND   ISNULL(ItemKey, 0) > 0
				AND   ISNULL(GLAccountKey, 0) = 0 )
		RETURN -5
*/
	 
	-- Now get new rates for these transactions
	UPDATE #tTran
	SET    #tTran.Amount = (#tTran.Amount * (1 + irsd.Markup / 100))
	FROM   tItemRateSheetDetail irsd (NOLOCK)
	WHERE  irsd.ItemRateSheetKey = @ExpRateSheetKey
	AND    #tTran.ItemKey = irsd.ItemKey

	UPDATE #tTran 
	SET    #tTran.Amount = 
		CASE WHEN #tTran.RateLevel = 1 THEN ROUND(trsd.HourlyRate1 * #tTran.ActualHours, 2)
			 WHEN #tTran.RateLevel = 2 THEN ROUND(trsd.HourlyRate2 * #tTran.ActualHours, 2)
			 WHEN #tTran.RateLevel = 3 THEN ROUND(trsd.HourlyRate3 * #tTran.ActualHours, 2)
			 WHEN #tTran.RateLevel = 4 THEN ROUND(trsd.HourlyRate4 * #tTran.ActualHours, 2)
			 WHEN #tTran.RateLevel = 5 THEN ROUND(trsd.HourlyRate5 * #tTran.ActualHours, 2)
			 ELSE ROUND(trsd.HourlyRate1 * #tTran.ActualHours, 2)
		END	
	FROM   tTimeRateSheetDetail trsd (NOLOCK)	
	WHERE  trsd.TimeRateSheetKey = @LaborRateSheetKey
	AND    #tTran.ServiceKey = trsd.ServiceKey


--select 'Trans with new amounts'
--select * from #tTran

	INSERT #tProj (ProjectKey, Amount)
	SELECT ProjectKey, SUM(Amount)
	FROM   #tTran
	GROUP BY ProjectKey

	-- Validate the Percentage on the projects
	UPDATE #tProj
	SET    TotalPercentage = (SELECT SUM(b.Percentage)
							  FROM   tCBCodePercent b (NOLOCK)
							  WHERE  b.Entity = 'tProject' AND b.EntityKey = #tProj.ProjectKey) 		
	
	UPDATE #tProj
	SET    TotalPercentage = ISNULL(TotalPercentage, 0)
		
	IF EXISTS (SELECT 1
				FROM  #tProj
				WHERE ISNULL(TotalPercentage, 0) <> 100)
		RETURN -6
	
	-- Create posted table outside of the SQL tran	
	CREATE TABLE #tPosted(ProjectKey INT NULL
						,GLAccountKey INT NULL
						,CBCodeKey INT NULL
						,Debit MONEY NULL
						,Credit MONEY NULL
						,Found INT NULL)
	
	-- Inserts into posting table
	BEGIN TRANSACTION
	
	INSERT tCBPosting (CBBatchKey, ProjectKey, GLAccountKey, Credit, Debit)
	SELECT @CBBatchKey, ProjectKey, GLAccountKey, ROUND(SUM(Amount), 2), 0
	FROM   #tTran
	WHERE ISNULL(GLAccountKey, 0) > 0
	GROUP BY ProjectKey, GLAccountKey
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END
	
	INSERT tCBPosting (CBBatchKey, ProjectKey, CBCodeKey, Credit, Debit)
	SELECT DISTINCT @CBBatchKey, b.ProjectKey, cp.CBCodeKey, 0, CAST(cp.Percentage AS MONEY) 
	FROM   #tTran b
		INNER JOIN tCBCodePercent cp (NOLOCK) ON b.ProjectKey = cp.EntityKey AND cp.Entity = 'tProject' 

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END
	
		-- Loop to garantee no rounding error
	DECLARE @ProjectKey INT
	       ,@CBCodeKey INT
		 ,@NumCodes INT
		   ,@CodeIdx INT
		   ,@ProjectAmount MONEY
		   ,@CodeAmount MONEY
		
	SELECT 	@ProjectKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ProjectKey = MIN(ProjectKey)
		FROM   #tProj
		WHERE  ProjectKey > @ProjectKey
		
		IF @ProjectKey IS NULL
			BREAK
			
		SELECT @NumCodes = COUNT(CBCodeKey)
		FROM   tCBPosting (NOLOCK)
		WHERE  CBBatchKey = @CBBatchKey
		AND    ProjectKey = @ProjectKey
				
		-- Get the amounts from tCBPosting, they are already rounded
		SELECT @ProjectAmount = SUM(Credit)
		FROM   tCBPosting (NOLOCK)
		WHERE  CBBatchKey = @CBBatchKey
		AND    ProjectKey = @ProjectKey
			
		SELECT @CodeIdx = 1
			  ,@CBCodeKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @CBCodeKey = MIN(CBCodeKey)
			FROM   tCBPosting (NOLOCK)
			WHERE  CBBatchKey = @CBBatchKey
			AND    ProjectKey = @ProjectKey
			AND    CBCodeKey > @CBCodeKey
			
			IF @CBCodeKey IS NULL
				BREAK
			
			IF @CodeIdx < @NumCodes
			BEGIN
				-- Not at the end, apply percentage, round at 2 digits since this is what goes in the Feeder File
				SELECT @CodeAmount = (@ProjectAmount * Debit) / CAST(100 AS MONEY) 
				FROM   tCBPosting (NOLOCK)
				WHERE  CBBatchKey = @CBBatchKey
				AND    ProjectKey = @ProjectKey
				AND    CBCodeKey = @CBCodeKey
				
				SELECT @CodeAmount = ROUND(@CodeAmount, 2)		
		
				UPDATE tCBPosting 
				SET    Debit = @CodeAmount 
				WHERE  CBBatchKey = @CBBatchKey
				AND    ProjectKey = @ProjectKey
				AND    CBCodeKey = @CBCodeKey
						
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION
					RETURN -100			-- Unexpected error
				END
						
			END 
			ELSE
			BEGIN
				-- Last code, do not apply percentage to prevent rounding errors
				-- Code Amount = Project Amount - Sum of other code amounts
				SELECT @CodeAmount = NULL
				
				SELECT @CodeAmount = SUM(Debit)
				FROM   tCBPosting (NOLOCK)
				WHERE  CBBatchKey = @CBBatchKey
				AND    ProjectKey = @ProjectKey
				AND    CBCodeKey <> @CBCodeKey 
				
				-- Do not round here
				IF @CodeAmount IS NULL
					SELECT 	@CodeAmount = @ProjectAmount							
				ELSE
					SELECT 	@CodeAmount = @ProjectAmount - @CodeAmount
					
				UPDATE tCBPosting 
				SET    Debit = @CodeAmount 
				WHERE  CBBatchKey = @CBBatchKey
				AND    ProjectKey = @ProjectKey
				AND    CBCodeKey = @CBCodeKey
						
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION
					RETURN -100			-- Unexpected error
				END
					 
			END 
			
			-- update loop counter
			SELECT @CodeIdx = @CodeIdx + 1
		END
	
	END
	
--	select 'Initial posting details'
--	select * from tCBPosting where CBBatchKey = @CBBatchKey

	/* Initial Code causes rounding errors 
	UPDATE tCBPosting
	SET    tCBPosting.Debit = ROUND(
		(tCBPosting.Debit * 
		(SELECT b.Amount FROM #tProj b WHERE tCBPosting.ProjectKey = b.ProjectKey)) / CAST(100 AS MONEY)  
		, 3)
	WHERE tCBPosting.CBBatchKey = @CBBatchKey	
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END
	*/
	 			
	 			
				
	-- Now Subtract the posted amounts from original batches	
	INSERT #tPosted(ProjectKey, GLAccountKey, Debit, Credit, Found)
	SELECT cp.ProjectKey, cp.GLAccountKey, 0, SUM(cp.Credit), 0
	FROM   tCBPosting cp (NOLOCK)
		INNER JOIN tCBBatchAdjustment ba (NOLOCK) ON ba.BatchKey = cp.CBBatchKey
	WHERE ba.AdjustmentBatchKey = @CBBatchKey
	AND   isnull(cp.GLAccountKey, 0) > 0 	-- Added 5/5/2006
	GROUP BY cp.ProjectKey, cp.GLAccountKey	

	INSERT #tPosted(ProjectKey, CBCodeKey, Debit, Credit, Found)
	SELECT cp.ProjectKey, cp.CBCodeKey, SUM(cp.Debit), 0, 0
	FROM   tCBPosting cp (NOLOCK)
		INNER JOIN tCBBatchAdjustment ba (NOLOCK) ON ba.BatchKey = cp.CBBatchKey
	WHERE ba.AdjustmentBatchKey = @CBBatchKey
	AND   isnull(cp.CBCodeKey, 0) > 0	-- Added 5/5/2006
	GROUP BY cp.ProjectKey, cp.CBCodeKey	
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END
	
	
	UPDATE tCBPosting
	SET    tCBPosting.Credit = tCBPosting.Credit -
		ISNULL((
			SELECT b.Credit FROM #tPosted b  
			WHERE b.GLAccountKey =	tCBPosting.GLAccountKey 
			AND   b.ProjectKey =	tCBPosting.ProjectKey	
		), 0)	 
	WHERE  tCBPosting.CBBatchKey = @CBBatchKey

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END
	
	UPDATE tCBPosting
	SET    tCBPosting.Debit = tCBPosting.Debit -
		ISNULL((
			SELECT b.Debit FROM #tPosted b  
			WHERE b.CBCodeKey = tCBPosting.CBCodeKey 
			AND   b.ProjectKey =	tCBPosting.ProjectKey	
		), 0)	 
	WHERE  tCBPosting.CBBatchKey = @CBBatchKey

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END

	-- Some GL or CB Codes may have been changed, they may not be in tCBPosting but not in #tPosted, so add them
	UPDATE #tPosted
	SET    #tPosted.Found = 1
	FROM   tCBPosting b (NOLOCK)
	WHERE  b.CBBatchKey = @CBBatchKey
	AND    #tPosted.ProjectKey = b.ProjectKey
	AND    #tPosted.GLAccountKey = b.GLAccountKey
	
	UPDATE #tPosted
	SET    #tPosted.Found = 1
	FROM   tCBPosting b (NOLOCK)
	WHERE  b.CBBatchKey = @CBBatchKey
	AND    #tPosted.ProjectKey = b.ProjectKey
	AND    #tPosted.CBCodeKey = b.CBCodeKey
		
--select 'Already posted trans'		
--select * from #tPosted
		
	INSERT tCBPosting (CBBatchKey, ProjectKey, GLAccountKey, Credit, Debit)
	SELECT @CBBatchKey, ProjectKey, GLAccountKey, -Credit, 0
	FROM   #tPosted
	WHERE  Found = 0
	AND   isnull(GLAccountKey, 0) > 0	-- Added 5/5/2006

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END
	
	INSERT tCBPosting (CBBatchKey, ProjectKey, CBCodeKey, Credit, Debit)
	SELECT @CBBatchKey, ProjectKey, CBCodeKey, 0, -Debit
	FROM   #tPosted
	WHERE  Found = 0
	AND   isnull(CBCodeKey, 0) > 0	-- Added 5/5/2006

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END


	DELETE tCBPosting
	WHERE  CBBatchKey = @CBBatchKey
	AND    Debit = 0
	AND	   Credit = 0

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END

--	select 'Final posting details'
--	select * from tCBPosting where CBBatchKey = @CBBatchKey
	
	COMMIT TRANSACTION
				
	RETURN 1
GO
