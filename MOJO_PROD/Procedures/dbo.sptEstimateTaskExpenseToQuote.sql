USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskExpenseToQuote]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskExpenseToQuote]
	(
		@EstimateTaskExpenseKey int
		,@UserKey INT
		,@oQuoteKey INT OUTPUT
		,@oQuoteDetailKey INT OUTPUT
	)

AS	-- Encrypt

/*
|| When     Who Rel     What
|| 07/10/07 BSH 8.5     (9659)Added GLCompanyKey, OfficeKey(from project)
||                       and DepartmentKey(from item). 
|| 10/22/08 GHL 10.5    (37963) Added CompanyAddressKey on quote
|| 03/01/10 GHL 10.519 Removed inner join between tEstimate.ProjectKey and tProject.ProjectKey
|| 06/08/11 GHL 10.545 Getting now CompanyAddressKey from tGLCompany
|| 08/12/11 RLB 10.547 (116589) change made to get cmp to work
|| 05/22/12 GHL 10.556 (143227) Added update of tQuote.EstimateKey 
*/

	SET NOCOUNT ON 
	
	declare @RetVal int
			,@QuoteKey int
			,@EstimateKey int
			,@CompanyKey int
			,@RequireClasses int
			,@ProjectKey int
			,@QuoteDate smalldatetime
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
		INNER JOIN tEstimateTaskExpense ete (NOLOCK) ON ete.EstimateKey = e.EstimateKey
		LEFT OUTER JOIN tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey
	WHERE  ete.EstimateTaskExpenseKey = @EstimateTaskExpenseKey
	AND    e.InternalStatus <> 4	-- Should not be approved

	IF @@ROWCOUNT = 0
		RETURN -1
		
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
	FROM    tEstimateTaskExpense (NOLOCK)
	WHERE   EstimateTaskExpenseKey = @EstimateTaskExpenseKey
	
	SELECT @DepartmentKey = DepartmentKey
	FROM   tItem i (NOLOCK)
	WHERE  i.ItemKey = @ItemKey
	
	IF ISNULL(@QuoteDetailKey, 0) > 0
		RETURN -2

	IF @RequireClasses = 1 AND ISNULL(@ClassKey, 0) = 0
		RETURN -3
	
		
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
		RETURN -4
		
	IF @QuoteKey IS NULL
		RETURN -4
				
	update tQuote set EstimateKey = @EstimateKey where QuoteKey = @QuoteKey

	exec @RetVal = sptQuoteDetailInsert @QuoteKey, @ProjectKey, @TaskKey, @ItemKey, @ClassKey, 
		@ShortDescription, @LongDescription, @Quantity, @UnitDescription, @Quantity2, @UnitDescription2, 
		@Quantity3, @UnitDescription3, @Quantity4, @UnitDescription4, @Quantity5, @UnitDescription5, 
		@Quantity6, @UnitDescription6
		,0 --@CustomFieldKey = 0
		,@OfficeKey, @DepartmentKey, 0
		,@QuoteDetailKey output
	
	IF @RetVal <> 1
		RETURN -5
		
	IF @QuoteDetailKey IS NULL
		RETURN -5
		
	UPDATE tEstimateTaskExpense 
	SET		QuoteDetailKey = @QuoteDetailKey	
	WHERE	EstimateTaskExpenseKey = @EstimateTaskExpenseKey
		
	IF @@ERROR <> 0
		RETURN -6 
				
	SELECT @oQuoteDetailKey = @QuoteDetailKey 
		   ,@oQuoteKey = @QuoteKey
		   				
	RETURN 1
GO
