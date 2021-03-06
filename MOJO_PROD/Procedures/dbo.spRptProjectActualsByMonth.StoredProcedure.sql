USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectActualsByMonth]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectActualsByMonth]
	(
		@CompanyKey INT
		,@ClientKey INT
		,@ProjectStatusKey INT -- -3 All, -1 All Active, -2 All Inactive, + other values 
		,@AccountManager INT
		,@StartingMonth INT
		,@StartingYear INT
		,@CurrencyID VARCHAR(10)
		,@LaborExpense INT -- 1 Labor + Expense, 2 Labor Only, 3 Expense Only, 0 Show Hours
		,@IncludeNonBillable INT
		,@IncludeDoNotPostWIP INT
		,@UserKey INT = null
	)
AS
	/*
	|| When			Who		Rel		What
	|| 08/24/2005	GHL		7.95	Added split lines ( 1 for labor and 2 for expense) when @LaborExpense = 1 
	|| 04/06/2006	GHL		8.3		Loaded costs into temp table rather than repeatedly reading #vProjectCosts 
	||								to incr perfo
	|| 02/01/08     GHL     8.5     (20123) Added logic for expense reports on vouchers
	|| 02/25/09     MAS     10.0.1.9(47410) Added the ApprovedCOHours column to the Hours total
	|| 01/12/10     GHL     10.516  (71962) Replaced queries in vProjectCosts by direct queries in tran tables
	|| 04/17/12     GHL     10.555  Added UserKey for UserGLCompanyAccess
	|| 01/21/14     GHL     10.576  Reading now PTotalCost vs TotalCost on orders
	||                              Added CurrencyID
	|| 04/22/14     WDF     10.579  (209808) Added criteria @IncludeNonBillable and @IncludeDoNotPostWIP
	*/

	SET NOCOUNT ON
	
	DECLARE @kLaborAndExpense INT	SELECT @kLaborAndExpense = 1	
	DECLARE @kLaborOnly INT			SELECT @kLaborOnly = 2
	DECLARE @kExpenseOnly INT		SELECT @kExpenseOnly = 3	
	DECLARE @kShowHours INT			SELECT @kShowHours = 0
	
	DECLARE @IsActive INT
	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME
	DECLARE @YearStartDate DATETIME
	DECLARE @YearEndDate DATETIME
	DECLARE @Loop INTEGER	

	IF @ProjectStatusKey = -1
		SELECT @IsActive = 1
			  ,@ProjectStatusKey = NULL
	IF @ProjectStatusKey = -2
		SELECT @IsActive = 0
			  ,@ProjectStatusKey = NULL
	IF @ProjectStatusKey = -3
		SELECT @ProjectStatusKey = NULL
		
	IF ISNULL(@ClientKey, 0) = 0
		SELECT @ClientKey = NULL
		 			
	IF ISNULL(@AccountManager, 0) = 0
		SELECT @AccountManager = NULL
		
	Declare @RestrictToGLCompany int
	Declare @MultiCurrency int

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
		  ,@MultiCurrency = isnull(MultiCurrency, 0)
		from tUser u (nolock)
		inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		Where u.UserKey = @UserKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
	select @MultiCurrency = isnull(@MultiCurrency, 0)


	CREATE TABLE #ProjActuals (ProjectKey INT NULL, ProjectTitle VARCHAR(250) NULL, Client VARCHAR(250) NULL
		,ProjectType VARCHAR(250) NULL, AccountManager VARCHAR(250) NULL
		, ProjectStatus VARCHAR(250) NULL, CurrencyID VARCHAR(10) NULL 

		,Budget MONEY NULL, Remaining MONEY NULL, Billed MONEY NULL
		,Month1 MONEY NULL, Month2 MONEY NULL, Month3 MONEY NULL, Month4 MONEY NULL, Month5 MONEY NULL, Month6 MONEY NULL
		,Month7 MONEY NULL, Month8 MONEY NULL, Month9 MONEY NULL, Month10 MONEY NULL, Month11 MONEY NULL, Month12 MONEY NULL

		,Budget_2 MONEY NULL, Remaining_2 MONEY NULL, Billed_2 MONEY NULL
		,Month1_2 MONEY NULL, Month2_2 MONEY NULL, Month3_2 MONEY NULL, Month4_2 MONEY NULL, Month5_2 MONEY NULL, Month6_2 MONEY NULL
		,Month7_2 MONEY NULL, Month8_2 MONEY NULL, Month9_2 MONEY NULL, Month10_2 MONEY NULL, Month11_2 MONEY NULL, Month12_2 MONEY NULL
		)
			
	INSERT #ProjActuals
	SELECT  p.ProjectKey
			,RTRIM(p.ProjectNumber) + ' - ' + p.ProjectName 
			,c.CustomerID + ' - ' + c.CompanyName
			,pt.ProjectTypeName
			,am.FirstName + ' ' + am.LastName -- Add Middle Name?
			,ps.ProjectStatus
			,p.CurrencyID
			,CASE 
				WHEN @LaborExpense = 0 THEN -- Display Hours
				ISNULL(EstHours, 0) + ISNULL(ApprovedCOHours, 0)		
				WHEN @LaborExpense = 1 THEN -- Labor And Expense: show first bucket with labor
				ISNULL(EstLabor, 0) + ISNULL(ApprovedCOLabor, 0) + ISNULL(Contingency, 0)
				WHEN @LaborExpense = 2 THEN -- Labor Only 
				ISNULL(EstLabor, 0) + ISNULL(ApprovedCOLabor, 0) + ISNULL(Contingency, 0)
				WHEN @LaborExpense = 3 THEN -- Expense Only
				ISNULL(EstExpenses, 0) + ISNULL(ApprovedCOExpense, 0) 
				ELSE
				ISNULL(EstLabor, 0) + ISNULL(EstExpenses, 0) + ISNULL(ApprovedCOLabor, 0) + ISNULL(ApprovedCOExpense, 0) + ISNULL(Contingency, 0)
			END							-- Budget
			,0,0						-- Remaining, Billed
			,0,0,0,0,0,0,0,0,0,0,0,0	-- 12 months

			,CASE 
				WHEN @LaborExpense = 1 THEN -- Labor And Expense: show second bucket with expense
				ISNULL(EstExpenses, 0) + ISNULL(ApprovedCOExpense, 0)
				ELSE 0
			END							-- Budget_2 
			,0,0						-- Remaining_2, Billed_2
			,0,0,0,0,0,0,0,0,0,0,0,0	-- 12 months

	FROM	tProject p (NOLOCK)
		INNER JOIN tCompany c (NOLOCK) ON p.ClientKey = c.CompanyKey
		INNER JOIN tProjectStatus ps (NOLOCK) ON p.ProjectStatusKey = ps.ProjectStatusKey
		LEFT OUTER JOIN tProjectType pt (NOLOCK) ON p.ProjectTypeKey = pt.ProjectTypeKey
		LEFT OUTER JOIN tUser am (NOLOCK) ON p.AccountManager = am.UserKey
	WHERE p.CompanyKey = @CompanyKey
	AND   (@ProjectStatusKey IS NULL OR p.ProjectStatusKey = @ProjectStatusKey)
	AND   (@IsActive IS NULL OR ps.IsActive = @IsActive)
	AND   (@AccountManager IS NULL OR am.UserKey = @AccountManager)
	AND   (@ClientKey IS NULL OR c.CompanyKey = @ClientKey)	
	AND   (p.NonBillable IS NULL OR p.NonBillable = 0 OR  p.NonBillable = @IncludeNonBillable)
	AND   (p.DoNotPostWIP IS NULL OR p.DoNotPostWIP = 0 OR  p.DoNotPostWIP = @IncludeDoNotPostWIP)
	AND   (@RestrictToGLCompany = 0 
		OR p.GLCompanyKey IN (SELECT GLCompanyKey 
			FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )

	If @MultiCurrency = 1
		DELETE #ProjActuals
		WHERE  ISNULL(CurrencyID, '') <> ISNULL(@CurrencyID, '') 

	CREATE TABLE #vProjectCosts(Type VARCHAR(50) NULL, ProjectKey INT NULL, AmountBilled MONEY NULL
								,BillableCost MONEY NULL, TransactionDate DATETIME NULL)
							 

	-- Set dates to capture 1 year of data
	SELECT @YearStartDate = CAST(CAST(@StartingMonth AS VARCHAR(2))+'/1/'+CAST(@StartingYear AS VARCHAR(4)) AS DATETIME) 
	SELECT @YearEndDate = DATEADD(Year, 1, @YearStartDate)
	SELECT @YearEndDate = DATEADD(Day, -1, @YearEndDate)
				
	/* Replaced 01/12/2010 by direct calls to speed up perfo			
	INSERT #vProjectCosts (Type, ProjectKey, AmountBilled, BillableCost, TransactionDate, LinkVoucherDetailKey)
	SELECT b.Type, b.ProjectKey, b.AmountBilled, b.BillableCost, b.TransactionDate, b.LinkVoucherDetailKey 
	FROM   vProjectCosts b (NOLOCK)
			INNER JOIN tProject p (NOLOCK) ON b.ProjectKey = p.ProjectKey
	WHERE  p.CompanyKey = @CompanyKey
	AND    @YearStartDate <= b.TransactionDate 
	AND    b.TransactionDate <= @YearEndDate	
	*/
			
	IF @LaborExpense in (@kLaborAndExpense, @kLaborOnly)
	BEGIN
		INSERT #vProjectCosts (Type, ProjectKey, BillableCost, TransactionDate)
		SELECT 'LABOR', t.ProjectKey, ROUND(t.ActualHours * t.ActualRate, 2), t.WorkDate
		FROM   tTime t (nolock)
		INNER  JOIN #ProjActuals p ON t.ProjectKey = p.ProjectKey
		WHERE  t.WorkDate >= @YearStartDate  
		AND    t.WorkDate <= @YearEndDate	
		AND    t.TransferToKey is null  -- not required, but same as vProjectCosts
	END		 
	
	IF @LaborExpense in (@kLaborAndExpense, @kExpenseOnly)
	BEGIN
		INSERT #vProjectCosts (Type, ProjectKey, BillableCost, TransactionDate)
		SELECT 'EXPRPT', er.ProjectKey, er.BillableCost, er.ExpenseDate
		FROM   tExpenseReceipt er (nolock) 
		INNER  JOIN #ProjActuals p ON er.ProjectKey = p.ProjectKey
		WHERE  er.ExpenseDate >= @YearStartDate  
		AND    er.ExpenseDate <= @YearEndDate
		AND    er.TransferToKey is null  
		AND    er.VoucherDetailKey is null
		
		INSERT #vProjectCosts (Type, ProjectKey, BillableCost, TransactionDate)
		SELECT 'MISCCOST', mc.ProjectKey, mc.BillableCost, mc.ExpenseDate
		FROM   tMiscCost mc (nolock)
		INNER  JOIN #ProjActuals p ON mc.ProjectKey = p.ProjectKey
		WHERE  mc.ExpenseDate >= @YearStartDate  
		AND    mc.ExpenseDate <= @YearEndDate
		AND    mc.TransferToKey is null  
			
		INSERT #vProjectCosts (Type, ProjectKey, BillableCost, TransactionDate)
		SELECT 'VOUCHER', vd.ProjectKey, vd.BillableCost, v.InvoiceDate
		FROM   tVoucherDetail vd (nolock) 
			INNER  JOIN #ProjActuals p ON vd.ProjectKey = p.ProjectKey
			INNER  JOIN tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey 
		WHERE  v.InvoiceDate >= @YearStartDate  
		AND    v.InvoiceDate <= @YearEndDate
		AND    vd.TransferToKey is null  

		INSERT #vProjectCosts (Type, ProjectKey, BillableCost, TransactionDate)
		SELECT 'ORDER', pod.ProjectKey 
		,CASE po.BillAt 
		WHEN 0 THEN ISNULL(pod.BillableCost, 0)
		WHEN 1 THEN ISNULL(pod.PTotalCost,0)
		WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
		END
		,po.PODate
		FROM   tPurchaseOrderDetail pod (nolock) 
			INNER  JOIN #ProjActuals p ON pod.ProjectKey = p.ProjectKey
			INNER  JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey 
		WHERE  po.PODate >= @YearStartDate  
		AND    po.PODate <= @YearEndDate
		AND    pod.TransferToKey is null  
		AND    po.POKind = 0
		AND    (pod.InvoiceLineKey > 0 or (ISNULL(pod.AppliedCost, 0) = 0 and pod.Closed = 0)) -- like in vProjectCosts

		INSERT #vProjectCosts (Type, ProjectKey, BillableCost, TransactionDate)
		SELECT 'ORDER', pod.ProjectKey 
		,CASE po.BillAt 
		WHEN 0 THEN ISNULL(pod.BillableCost, 0)
		WHEN 1 THEN ISNULL(pod.PTotalCost,0)
		WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
		END
		,pod.DetailOrderDate
		FROM   tPurchaseOrderDetail pod (nolock) 
			INNER  JOIN #ProjActuals p ON pod.ProjectKey = p.ProjectKey
			INNER  JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey 
		WHERE  pod.DetailOrderDate >= @YearStartDate  
		AND    pod.DetailOrderDate <= @YearEndDate
		AND    pod.TransferToKey is null  
		AND    po.POKind > 0
		AND    (pod.InvoiceLineKey > 0 or (ISNULL(pod.AppliedCost, 0) = 0 and pod.Closed = 0)) -- like in vProjectCosts
			
	END

	IF @LaborExpense = @kShowHours
	BEGIN
		INSERT #vProjectCosts (Type, ProjectKey, BillableCost, TransactionDate)
		SELECT 'LABOR', t.ProjectKey, t.ActualHours, t.WorkDate
		FROM   tTime t (nolock)
		INNER  JOIN #ProjActuals p ON t.ProjectKey = p.ProjectKey
		WHERE  t.WorkDate >= @YearStartDate  
		AND    t.WorkDate <= @YearEndDate	
		AND    t.TransferToKey is null  -- not required, but same as vProjectCosts
	END		 
			
	SELECT @Loop = 1
	WHILE (@Loop <= 12)
	BEGIN
		-- Set dates to calculate 1 month of data
		SELECT @StartDate = CAST(CAST(@StartingMonth AS VARCHAR(2))+'/1/'+CAST(@StartingYear AS VARCHAR(4)) AS DATETIME) 
		SELECT @EndDate = DATEADD(Month, 1, @StartDate)
		SELECT @EndDate = DATEADD(Day, -1, @EndDate)
	
		IF @LaborExpense = @kLaborAndExpense
		BEGIN
			IF @Loop = 1
				UPDATE #ProjActuals
				SET    Month1 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type = 'LABOR')	
			ELSE IF @Loop = 2
				UPDATE #ProjActuals
				SET    Month2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type = 'LABOR')
			ELSE IF @Loop = 3
				UPDATE #ProjActuals
				SET    Month3 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type = 'LABOR')
			ELSE IF @Loop = 4
				UPDATE #ProjActuals
				SET    Month4 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type = 'LABOR')
			ELSE IF @Loop = 5
				UPDATE #ProjActuals
				SET    Month5 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type = 'LABOR')
			ELSE IF @Loop = 6
				UPDATE #ProjActuals
				SET    Month6 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type = 'LABOR')
			ELSE IF @Loop = 7
				UPDATE #ProjActuals
				SET    Month7 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type = 'LABOR')
			ELSE IF @Loop = 8
				UPDATE #ProjActuals
				SET    Month8 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type = 'LABOR')
			ELSE IF @Loop = 9
				UPDATE #ProjActuals
				SET    Month9 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND  b.TransactionDate <= @EndDate
				AND	   b.Type = 'LABOR')
			ELSE IF @Loop = 10
				UPDATE #ProjActuals
				SET    Month10 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type = 'LABOR')
			ELSE IF @Loop = 11
				UPDATE #ProjActuals
				SET    Month11 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type = 'LABOR')
			ELSE IF @Loop = 12
				UPDATE #ProjActuals
				SET    Month12 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type = 'LABOR')
		
			IF @Loop = 1
				UPDATE #ProjActuals
				SET    Month1_2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type <> 'LABOR'
				)	
			ELSE IF @Loop = 2
				UPDATE #ProjActuals
				SET    Month2_2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type <> 'LABOR'
				)
			ELSE IF @Loop = 3
				UPDATE #ProjActuals
				SET    Month3_2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type <> 'LABOR'
				)
			ELSE IF @Loop = 4
				UPDATE #ProjActuals
				SET    Month4_2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type <> 'LABOR'
				)
			ELSE IF @Loop = 5
				UPDATE #ProjActuals
				SET    Month5_2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type <> 'LABOR'
				)
			ELSE IF @Loop = 6
				UPDATE #ProjActuals
				SET    Month6_2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type <> 'LABOR'
				)
			ELSE IF @Loop = 7
				UPDATE #ProjActuals
				SET    Month7_2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type <> 'LABOR'
				)
			ELSE IF @Loop = 8
				UPDATE #ProjActuals
				SET    Month8_2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND   @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type <> 'LABOR'
				)
			ELSE IF @Loop = 9
				UPDATE #ProjActuals
				SET    Month9_2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type <> 'LABOR'
				)
			ELSE IF @Loop = 10
				UPDATE #ProjActuals
				SET    Month10_2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type <> 'LABOR'
				)
			ELSE IF @Loop = 11
				UPDATE #ProjActuals
				SET    Month11_2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type <> 'LABOR'
				)
			ELSE IF @Loop = 12
				UPDATE #ProjActuals
				SET    Month12_2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				AND	   b.Type <> 'LABOR'
				)

				
		END
	
		IF @LaborExpense IN ( @kLaborOnly, @kExpenseOnly, @kShowHours)
		BEGIN
			IF @Loop = 1
				UPDATE #ProjActuals
				SET    Month1 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				)	
			ELSE IF @Loop = 2
				UPDATE #ProjActuals
				SET    Month2 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				)
			ELSE IF @Loop = 3
				UPDATE #ProjActuals
				SET    Month3 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				)
			ELSE IF @Loop = 4
				UPDATE #ProjActuals
				SET    Month4 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				)
			ELSE IF @Loop = 5
				UPDATE #ProjActuals
				SET    Month5 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				)
			ELSE IF @Loop = 6
				UPDATE #ProjActuals
				SET    Month6 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				)
			ELSE IF @Loop = 7
				UPDATE #ProjActuals
				SET    Month7 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				)
			ELSE IF @Loop = 8
				UPDATE #ProjActuals
				SET    Month8 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				)
			ELSE IF @Loop = 9
				UPDATE #ProjActuals
				SET    Month9 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				)
			ELSE IF @Loop = 10
				UPDATE #ProjActuals
				SET    Month10 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				)
			ELSE IF @Loop = 11
				UPDATE #ProjActuals
				SET    Month11 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				)
			ELSE IF @Loop = 12
				UPDATE #ProjActuals
				SET    Month12 = (SELECT ISNULL(SUM(b.BillableCost), 0)
				FROM   #vProjectCosts b (NOLOCK)
				WHERE  #ProjActuals.ProjectKey = b.ProjectKey
				AND    @StartDate <= b.TransactionDate 
				AND    b.TransactionDate <= @EndDate
				)
		END
			
		-- Update the loop indexes
		SELECT @StartingMonth = @StartingMonth + 1
		IF @StartingMonth > 12
			SELECT @StartingMonth = 1
				,@StartingYear = @StartingYear + 1

		SELECT @Loop = @Loop + 1	
		
	END

	UPDATE #ProjActuals
	SET    #ProjActuals.Billed = 0
		  ,#ProjActuals.Billed_2 = 0
		   
	IF @LaborExpense = @kLaborAndExpense
	BEGIN
		-- we need to separate labor from expenses
		UPDATE #ProjActuals
		SET    #ProjActuals.Billed = ISNULL(( 
			SELECT SUM(ROUND(t.BilledHours * t.BilledRate, 2))
			FROM   tTime t (nolock)
			WHERE  t.ProjectKey = #ProjActuals.ProjectKey
			AND    t.WorkDate <= @YearEndDate	
			AND    t.TransferToKey is null  
		), 0)
		
		UPDATE #ProjActuals
		SET    #ProjActuals.Billed_2 = ISNULL(#ProjActuals.Billed_2, 0) + ISNULL(( 
		SELECT SUM(er.AmountBilled)
		FROM   tExpenseReceipt er (nolock) 
		WHERE  er.ProjectKey = #ProjActuals.ProjectKey
		AND    er.ExpenseDate <= @YearEndDate
		AND    er.TransferToKey is null  
		AND    er.VoucherDetailKey is null
		), 0)
		
		UPDATE #ProjActuals
		SET    #ProjActuals.Billed_2 = ISNULL(#ProjActuals.Billed_2, 0) + ISNULL(( 
		SELECT SUM(mc.AmountBilled)
		FROM   tMiscCost mc (nolock)
		WHERE  mc.ProjectKey = #ProjActuals.ProjectKey
		AND    mc.ExpenseDate <= @YearEndDate
		AND    mc.TransferToKey is null  
		), 0)
		
			
		UPDATE #ProjActuals
		SET    #ProjActuals.Billed_2 = ISNULL(#ProjActuals.Billed_2, 0) + ISNULL(( 
		SELECT SUM(vd.AmountBilled)
		FROM   tVoucherDetail vd (nolock) 
			INNER  JOIN tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey 
		WHERE  vd.ProjectKey = #ProjActuals.ProjectKey
		AND    v.InvoiceDate <= @YearEndDate
		AND    vd.TransferToKey is null  
		), 0)
			
		UPDATE #ProjActuals
		SET    #ProjActuals.Billed_2 = ISNULL(#ProjActuals.Billed_2, 0) + ISNULL(( 
		SELECT SUM(pod.AmountBilled)
		FROM   tPurchaseOrderDetail pod (nolock) 
			INNER  JOIN #ProjActuals p ON pod.ProjectKey = p.ProjectKey
			INNER  JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey 
		WHERE  pod.ProjectKey = #ProjActuals.ProjectKey
		AND    po.PODate <= @YearEndDate
		AND    pod.TransferToKey is null  
		AND    po.POKind = 0
		AND    (pod.InvoiceLineKey > 0 or (ISNULL(pod.AppliedCost, 0) = 0 and pod.Closed = 0)) -- like in vProjectCosts
		), 0)
		
		UPDATE #ProjActuals
		SET    #ProjActuals.Billed_2 = ISNULL(#ProjActuals.Billed_2, 0) + ISNULL(( 
		SELECT SUM(pod.AmountBilled)
		FROM   tPurchaseOrderDetail pod (nolock) 
			INNER  JOIN #ProjActuals p ON pod.ProjectKey = p.ProjectKey
			INNER  JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey 
		WHERE  pod.ProjectKey = #ProjActuals.ProjectKey
		AND    pod.DetailOrderDate <= @YearEndDate
		AND    pod.TransferToKey is null  
		AND    po.POKind > 0
		AND    (pod.InvoiceLineKey > 0 or (ISNULL(pod.AppliedCost, 0) = 0 and pod.Closed = 0)) -- like in vProjectCosts
		), 0)
		
	END		 

	IF @LaborExpense = @kLaborOnly
	BEGIN
		-- we need to separate labor from expenses
		UPDATE #ProjActuals
		SET    #ProjActuals.Billed = ISNULL(( 
			SELECT SUM(ROUND(t.BilledHours * t.BilledRate, 2))
			FROM   tTime t (nolock)
			WHERE  t.ProjectKey = #ProjActuals.ProjectKey
			AND    t.WorkDate <= @YearEndDate	
			AND    t.TransferToKey is null  
		), 0)

	END
		
	IF @LaborExpense = @kExpenseOnly
	BEGIN
		UPDATE #ProjActuals
		SET    #ProjActuals.Billed = ISNULL(#ProjActuals.Billed, 0) + ISNULL(( 
		SELECT SUM(er.AmountBilled)
		FROM   tExpenseReceipt er (nolock) 
		WHERE  er.ProjectKey = #ProjActuals.ProjectKey
		AND    er.ExpenseDate <= @YearEndDate
		AND    er.TransferToKey is null  
		AND    er.VoucherDetailKey is null
		), 0)
		
		UPDATE #ProjActuals
		SET    #ProjActuals.Billed = ISNULL(#ProjActuals.Billed, 0) + ISNULL(( 
		SELECT SUM(mc.AmountBilled)
		FROM   tMiscCost mc (nolock)
		WHERE  mc.ProjectKey = #ProjActuals.ProjectKey
		AND    mc.ExpenseDate <= @YearEndDate
		AND    mc.TransferToKey is null  
		), 0)
		
			
		UPDATE #ProjActuals
		SET    #ProjActuals.Billed = ISNULL(#ProjActuals.Billed, 0) + ISNULL(( 
		SELECT SUM(vd.AmountBilled)
		FROM   tVoucherDetail vd (nolock) 
			INNER  JOIN tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey 
		WHERE  vd.ProjectKey = #ProjActuals.ProjectKey
		AND    v.InvoiceDate <= @YearEndDate
		AND    vd.TransferToKey is null  
		), 0)
			
		UPDATE #ProjActuals
		SET    #ProjActuals.Billed = ISNULL(#ProjActuals.Billed, 0) + ISNULL(( 
		SELECT SUM(pod.AmountBilled)
		FROM   tPurchaseOrderDetail pod (nolock) 
			INNER  JOIN #ProjActuals p ON pod.ProjectKey = p.ProjectKey
			INNER  JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey 
		WHERE  pod.ProjectKey = #ProjActuals.ProjectKey
		AND    po.PODate <= @YearEndDate
		AND    pod.TransferToKey is null  
		AND    po.POKind = 0
		AND    (pod.InvoiceLineKey > 0 or (ISNULL(pod.AppliedCost, 0) = 0 and pod.Closed = 0)) -- like in vProjectCosts
		), 0)
		
		UPDATE #ProjActuals
		SET    #ProjActuals.Billed = ISNULL(#ProjActuals.Billed, 0) + ISNULL(( 
		SELECT SUM(pod.AmountBilled)
		FROM   tPurchaseOrderDetail pod (nolock) 
			INNER  JOIN #ProjActuals p ON pod.ProjectKey = p.ProjectKey
			INNER  JOIN tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey 
		WHERE  pod.ProjectKey = #ProjActuals.ProjectKey
		AND    pod.DetailOrderDate <= @YearEndDate
		AND    pod.TransferToKey is null  
		AND    po.POKind > 0
		AND    (pod.InvoiceLineKey > 0 or (ISNULL(pod.AppliedCost, 0) = 0 and pod.Closed = 0)) -- like in vProjectCosts
		), 0)
			
	END

	IF @LaborExpense = @kShowHours
	BEGIN
		-- we need to separate labor from expenses
		UPDATE #ProjActuals
		SET    #ProjActuals.Billed = ISNULL(( 
			SELECT SUM(t.ActualHours)
			FROM   tTime t (nolock)
			WHERE  t.ProjectKey = #ProjActuals.ProjectKey
			AND    t.WorkDate <= @YearEndDate	
			AND    t.TransferToKey is null  
			AND    t.InvoiceLineKey IS NOT NULL
			AND    t.WriteOff = 0
		), 0)

	END

	/* Replaced 01/12/2010 by direct calls to speed up perfo				
	IF @LaborExpense = 1	
	BEGIN
		UPDATE #ProjActuals
		SET    Billed = (SELECT ISNULL(SUM(b.AmountBilled), 0)
		FROM   vProjectCosts b (NOLOCK)			-- Here, get it from the view
		WHERE  #ProjActuals.ProjectKey = b.ProjectKey
		AND    b.Type = 'LABOR'
		AND    b.TransactionDate <= @YearEndDate 
		)

		UPDATE #ProjActuals
		SET    Billed_2 = (SELECT ISNULL(SUM(b.AmountBilled), 0)
		FROM   vProjectCosts b (NOLOCK)		-- Here, get it from the view
		WHERE  #ProjActuals.ProjectKey = b.ProjectKey
		AND    b.Type <> 'LABOR'
		AND    b.TransactionDate <= @YearEndDate 
		)
		
	END	
	ELSE IF @LaborExpense = 2
		UPDATE #ProjActuals
		SET    Billed = (SELECT ISNULL(SUM(b.AmountBilled), 0)
		FROM   vProjectCosts b (NOLOCK)		-- Here, get it from the view
		WHERE  #ProjActuals.ProjectKey = b.ProjectKey
		AND    b.Type = 'LABOR'
		AND    b.TransactionDate <= @YearEndDate 
		)
	ELSE IF @LaborExpense = 3	
		UPDATE #ProjActuals
		SET    Billed = (SELECT ISNULL(SUM(b.AmountBilled), 0)
		FROM   vProjectCosts b (NOLOCK)
		WHERE  #ProjActuals.ProjectKey = b.ProjectKey
		AND    b.Type <> 'LABOR'
		AND    b.TransactionDate <= @YearEndDate 
		)
	ELSE	


		UPDATE #ProjActuals
		SET    Billed = (SELECT ISNULL(SUM(b.ActualHours), 0)
		FROM   tTime b (NOLOCK)
		WHERE  #ProjActuals.ProjectKey = b.ProjectKey
		AND    b.InvoiceLineKey IS NOT NULL
		AND    b.WriteOff = 0
		AND    b.WorkDate <= @YearEndDate 
		)
	
*/
		
	SELECT * FROM #ProjActuals
	
	RETURN
GO
