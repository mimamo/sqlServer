USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCBGenerateBatch]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCBGenerateBatch]
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
			
	-- Get batch info
	SELECT @CompanyKey = CompanyKey 
		  ,@StartDate = StartDate 
		  ,@EndDate = EndDate
		  ,@Adjusted = Adjusted	
	FROM   tCBBatch (NOLOCK)
	WHERE  CBBatchKey = @CBBatchKey

	IF @Adjusted = 1
		RETURN -1
		
	-- Undo previous posting
	BEGIN TRANSACTION
	
	DELETE tCBPosting WHERE CBBatchKey = @CBBatchKey

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END
	
	UPDATE tMiscCost 
	SET    tMiscCost.WIPPostingInKey = 0 
	FROM   tProject p (NOLOCK)	
	WHERE  tMiscCost.ProjectKey = p.ProjectKey
	AND    p.CompanyKey = @CompanyKey
	AND	   tMiscCost.WIPPostingInKey = @CBBatchKey

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END
	
	UPDATE tTime 
	SET    tTime.WIPPostingInKey = 0 
	FROM   tProject p (NOLOCK)	
	WHERE  tTime.ProjectKey = p.ProjectKey
	AND    p.CompanyKey = @CompanyKey
	AND	   tTime.WIPPostingInKey = @CBBatchKey

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END

	COMMIT TRANSACTION
		
	-- Get qualifying transactions
	CREATE TABLE #tTran (ProjectKey INT NULL
						,MiscCostKey INT NULL
						,ItemKey INT NULL
						,TimeKey UNIQUEIDENTIFIER NULL
						,ServiceKey INT NULL
						,GLAccountKey INT NULL
						,Amount MONEY NULL)

	/* Assume done in web page
	CREATE TABLE #tProj (ProjectKey INT NULL
						,Amount MONEY NULL
						,TotalPercentage DECIMAL(24,4) NULL)
	*/
												
	INSERT #tTran (ProjectKey, MiscCostKey, ItemKey, GLAccountKey, Amount)
	SELECT	mc.ProjectKey, mc.MiscCostKey, mc.ItemKey, ISNULL(i.SalesAccountKey, 0), mc.BillableCost
	FROM	tMiscCost mc (NOLOCK)
		INNER JOIN tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tItem i (NOLOCK) ON mc.ItemKey = i.ItemKey	
	WHERE   p.CompanyKey = @CompanyKey
	AND     ISNULL(p.NonBillable, 0) = 0	-- Added at Lenda's request on 11/04/2005
	AND		mc.ExpenseDate >= @StartDate
	AND		mc.ExpenseDate <= @EndDate					
	AND		ISNULL(mc.WIPPostingInKey, 0) = 0
	--AND     (mc.WriteOff IS NULL OR mc.WriteOff = 0) -- Needed here?
		
	INSERT #tTran (ProjectKey, TimeKey, ServiceKey, GLAccountKey, Amount)
	SELECT	t.ProjectKey, t.TimeKey, t.ServiceKey, ISNULL(s.GLAccountKey, 0), ROUND(t.ActualHours * t.ActualRate, 2)
	FROM	tTime t (NOLOCK)
		INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
		INNER JOIN tTimeSheet ts (NOLOCK) ON t.TimeSheetKey = ts.TimeSheetKey
		LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey	
	WHERE   p.CompanyKey = @CompanyKey
	AND     ISNULL(p.NonBillable, 0) = 0	-- Added at Lenda's request on 11/04/2005
	AND		ts.Status = 4	-- Approved
	AND		t.WorkDate >= @StartDate
	AND		t.WorkDate <= @EndDate					
	AND		ISNULL(t.WIPPostingInKey, 0) = 0
	--AND     (t.WriteOff IS NULL OR t.WriteOff = 0) -- Needed here?

	INSERT #tProj (ProjectKey, Amount)
	SELECT ProjectKey, SUM(Amount)
	FROM   #tTran
	GROUP BY ProjectKey

	-- Validate Item, Service, the GL Accounts and the Percentage on the projects
	UPDATE #tProj
	SET    TotalPercentage = (SELECT SUM(b.Percentage)
							  FROM   tCBCodePercent b (NOLOCK)
							  WHERE  b.Entity = 'tProject' AND b.EntityKey = #tProj.ProjectKey) 		
		
	UPDATE #tProj
	SET    TotalPercentage = ISNULL(TotalPercentage, 0)
		
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
	IF EXISTS (SELECT 1
				FROM  #tProj
				WHERE ISNULL(TotalPercentage, 0) <> 100)
		RETURN -6
				
	IF (SELECT COUNT(*) FROM #tTran) = 0
		RETURN -7
					
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
	
	
	/* Initital code causing rounding errors
	UPDATE tCBPosting
	SET    tCBPosting.Debit = ROUND(
		(tCBPosting.Debit * 
			(SELECT b.Amount FROM #tProj b WHERE tCBPosting.ProjectKey = b.ProjectKey)) / CAST(100 AS SMALLMONEY)  
								, 3)
	WHERE  tCBPosting.CBBatchKey = @CBBatchKey	

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END

	*/
	
	UPDATE tCBPosting 
	SET    tCBPosting.Validated = 0
	FROM   tCBCode c (NOLOCK) 
	WHERE  tCBPosting.CBCodeKey = c.CBCodeKey
	AND	   tCBPosting.CBBatchKey = @CBBatchKey
	AND	   c.Active = 0	   
		
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END
			
	-- Mark transactions
	UPDATE tMiscCost 
	SET    tMiscCost.WIPPostingInKey = @CBBatchKey
	FROM   #tTran b (NOLOCK)	
	WHERE  tMiscCost.MiscCostKey = b.MiscCostKey

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END

	UPDATE tTime 
	SET    tTime.WIPPostingInKey = @CBBatchKey
	FROM   #tTran b (NOLOCK)	
	WHERE  tTime.TimeKey = b.TimeKey
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -100			-- Unexpected error
	END

	-- Do we update Billed Fields in transactions?

	COMMIT TRANSACTION
	
	RETURN 1
GO
