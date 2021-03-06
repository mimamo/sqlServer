USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskExpenseToQuoteAll]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskExpenseToQuoteAll]
	(
		@EstimateKey INT
		,@UserKey INT
	)
AS -- Encrypt

/*
|| When     Who Rel     What
|| 07/10/07 BSH 8.5     (9659)Added GLCompanyKey, OfficeKey(from project)
||                       and DepartmentKey(from item). 
|| 10/22/08 GHL 10.5    (37963) Added CompanyAddressKey on quote
|| 02/12/10 GHL 10.518   Added left join with tProject, return of quote detail key in temp 
|| 03/01/10 GHL 10.519  Added  QuoteKey so that flash screen can load it PO
|| 06/08/11 GHL 10.545 Getting now CompanyAddressKey from tGLCompany
|| 08/12/11 RLB 10.547 (116589) Added some logic in for Display Order getting passed into Quote
|| 05/22/12 GHL 10.556 (143227) Added update of tQuote.EstimateKey 
*/

	SET NOCOUNT ON

	declare @RetVal int
			,@QuoteKey int
			,@CompanyKey int
			,@RequireClasses int
			,@ProjectKey int
			,@QuoteDate smalldatetime
			,@QuoteNumber int
			,@MultipleQty tinyint
			,@Option1 varchar(100)
			,@Option2 varchar(100)
			,@Option3 varchar(100)
			,@Option4 varchar(100)
			,@Option5 varchar(100)
			,@Option6 varchar(100)
			,@Subject varchar(200)
			,@Description varchar(1000)
			,@GLCompanyKey int
			,@CompanyAddressKey int

	DECLARE @TaskKey int
			,@QuoteDetailKey int
			,@ItemKey int
			,@ClassKey int
			,@ShortDescription varchar(200)
			,@LongDescription varchar(6000)
			,@Quantity decimal(24, 4)
			,@UnitDescription varchar(30)
			,@Quantity2 decimal(24, 4)
			,@UnitDescription2 varchar(30)
			,@Quantity3 decimal(24, 4)
			,@UnitDescription3 varchar(30)
			,@Quantity4 decimal(24, 4)
			,@UnitDescription4 varchar(30)
			,@Quantity5 decimal(24, 4)
			,@UnitDescription5 varchar(30)
			,@Quantity6 decimal(24, 4)
			,@UnitDescription6 varchar(30)
			,@OfficeKey int
			,@DepartmentKey int
			,@DisplayOrder int
			,@OneLine tinyint
			


		Select @OneLine = Case When count(*) <= 1 then 1 Else 0 end from #tExpense
	-- Get a clean date wo hr and min
	SELECT 	@QuoteDate =  CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101))
		   
	-- Assume done 
	-- CREATE TABLE #tExpense (EstimateTaskExpenseKey int null, QuoteKey int null, QuoteDetailKey int null, QuoteNumber int null)
		  
	-- Get a clean date wo hr and min
	SELECT 	@QuoteDate =  CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101))
			
	SELECT @EstimateKey = e.EstimateKey
		  ,@CompanyKey = e.CompanyKey
		  ,@GLCompanyKey = p.GLCompanyKey
		  ,@OfficeKey = p.OfficeKey
		  ,@RequireClasses = isnull(pref.RequireClasses, 0)
		  ,@ProjectKey = e.ProjectKey
	      ,@MultipleQty = e.MultipleQty
	      ,@Option1 = e.Expense1
	      ,@Option2 = e.Expense2
	      ,@Option3 = e.Expense3
	      ,@Option4 = e.Expense4
	      ,@Option5 = e.Expense5
	      ,@Option6 = e.Expense6
		  ,@Subject = e.EstimateName 
		  ,@Description = CONVERT(varchar(1000), e.EstDescription)
		  ,@CompanyAddressKey = glc.AddressKey
	FROM   tEstimate e (NOLOCK)
	LEFT JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey
	INNER JOIN tPreference pref (NOLOCK) ON e.CompanyKey = pref.CompanyKey
	LEFT OUTER JOIN tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey
	WHERE  e.EstimateKey = @EstimateKey
	AND    e.InternalStatus <> 4	-- Should not be approved

	IF @@ROWCOUNT = 0
		RETURN -1

	IF (SELECT COUNT(*) FROM #tExpense ) = 0
		RETURN -2
		
	-- We must have 1 item without quote				
	IF NOT EXISTS (SELECT 1
					   FROM   tEstimateTaskExpense ete (NOLOCK)
							INNER JOIN #tExpense b ON ete.EstimateTaskExpenseKey = b.EstimateTaskExpenseKey
							LEFT OUTER JOIN tItem i (NOLOCK) ON ete.ItemKey = i.ItemKey
					   WHERE  ete.EstimateKey = @EstimateKey
					   AND    isnull(ete.QuoteDetailKey, 0) = 0
					   )
					   RETURN -3
				
	-- We must have a Class				
	IF @RequireClasses = 1
		IF NOT EXISTS (SELECT 1
					   FROM   tEstimateTaskExpense ete (NOLOCK)
							INNER JOIN #tExpense b ON ete.EstimateTaskExpenseKey = b.EstimateTaskExpenseKey					   
							LEFT OUTER JOIN tItem i (NOLOCK) ON ete.ItemKey = i.ItemKey
					   WHERE  ete.EstimateKey = @EstimateKey
					   AND    isnull(ete.QuoteDetailKey, 0) = 0
					   AND    isnull(ete.ClassKey, 0) > 0
					   )
					   RETURN -4
		
	-- Create Quote header
	exec @RetVal = sptQuoteInsert @CompanyKey
		,0			--	@PurchaseOrderTypeKey 
		,@ProjectKey
		,@Subject
		,@QuoteDate
		,NULL		-- @DueDate 
		,@Description 
		,0			-- @ApprovedReplyKey 
		,1			-- @Status 
		,0			-- @CustomFieldKey 
		,@UserKey	-- @SendRepliesTo 
		,0			-- @HeaderTextKey 
		,0			-- @FooterTextKey
		,NULL		-- @TaskKey
		,NULL		-- @ItemKey
		,@MultipleQty 
		,@Option1, @Option2, @Option3, @Option4, @Option5, @Option6, @GLCompanyKey, @CompanyAddressKey, @QuoteKey output
	
	IF @RetVal <> 1
		RETURN -5	
	
	IF @QuoteKey IS NULL
		RETURN -5
	
	update tQuote set EstimateKey = @EstimateKey where QuoteKey = @QuoteKey

	SELECT @QuoteNumber = QuoteNumber
	FROM   tQuote (nolock)
	WHERE  QuoteKey = @QuoteKey
					   
	-- For the Loops
	DECLARE	@EstimateTaskExpenseKey INT
	SELECT @EstimateTaskExpenseKey = -1
		  
	WHILE (1=1)
	BEGIN
		SELECT @EstimateTaskExpenseKey = MIN(ete.EstimateTaskExpenseKey)
		FROM tEstimateTaskExpense ete (NOLOCK)
			INNER JOIN #tExpense b ON ete.EstimateTaskExpenseKey = b.EstimateTaskExpenseKey
		WHERE  ete.EstimateKey = @EstimateKey  
		AND    ete.EstimateTaskExpenseKey > @EstimateTaskExpenseKey 
		AND    ISNULL(ete.QuoteDetailKey, 0) = 0
		AND    (@RequireClasses = 0 OR (@RequireClasses = 1 AND  isnull(ete.ClassKey, 0) > 0)) 
		
		IF @EstimateTaskExpenseKey IS NULL
			BREAK
				
		SELECT	@QuoteDetailKey = QuoteDetailKey
			,@TaskKey = TaskKey
			,@ItemKey = ItemKey
			,@ClassKey = ClassKey
			,@ShortDescription = ShortDescription
			,@LongDescription = LongDescription
			,@Quantity = Quantity
			,@UnitDescription = UnitDescription
			,@Quantity2 = Quantity2
			,@UnitDescription2 = UnitDescription2
			,@Quantity3 = Quantity3
			,@UnitDescription3 = UnitDescription3
			,@Quantity4 = Quantity4
			,@UnitDescription4 = UnitDescription4
			,@Quantity5 = Quantity5
			,@UnitDescription5 = UnitDescription5
			,@Quantity6 = Quantity6
			,@UnitDescription6 = UnitDescription6
			,@DisplayOrder = Case  When @OneLine = 1 Then 0 Else DisplayOrder End
		FROM    tEstimateTaskExpense (NOLOCK)
		WHERE   EstimateTaskExpenseKey = @EstimateTaskExpenseKey
		
		SELECT @DepartmentKey = DepartmentKey
		FROM   tItem i (NOLOCK)
		WHERE  i.ItemKey = @ItemKey
		
		exec @RetVal = sptQuoteDetailInsert @QuoteKey, @ProjectKey, @TaskKey, @ItemKey, @ClassKey, 
			@ShortDescription, @LongDescription, @Quantity, @UnitDescription, @Quantity2, @UnitDescription2, 
			@Quantity3, @UnitDescription3, @Quantity4, @UnitDescription4, @Quantity5, @UnitDescription5, 
			@Quantity6, @UnitDescription6
			,0 --@CustomFieldKey = 0
			,@OfficeKey, @DepartmentKey, @DisplayOrder
			,@QuoteDetailKey output
		
		IF @RetVal <> 1
			RETURN -6
			
		IF @QuoteDetailKey IS NULL
			RETURN -6
			
		UPDATE tEstimateTaskExpense 
		SET		QuoteDetailKey = @QuoteDetailKey	
		WHERE	EstimateTaskExpenseKey = @EstimateTaskExpenseKey

		IF @@ERROR <> 0
		BEGIN
			RETURN -7 
		END 			

		UPDATE #tExpense
		SET		QuoteKey = @QuoteKey, QuoteDetailKey = @QuoteDetailKey, QuoteNumber = @QuoteNumber	
		WHERE	EstimateTaskExpenseKey = @EstimateTaskExpenseKey

	END						   
	
	RETURN 1
GO
