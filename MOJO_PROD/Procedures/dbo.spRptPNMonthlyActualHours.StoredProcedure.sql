USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptPNMonthlyActualHours]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptPNMonthlyActualHours]
	@CompanyKey int,
	@RetainerKey int,
	@ClientKey int,
	@StartingYear int,
	@StartingMonth smallint
AS --Encrypt

/*
|| When      Who Rel     What
|| 03/15/07  CRG 8.4.0.7 Changed Pieces to decimal(24,4)  
|| 03/28/07  GWG 8.4.1   Changed the OOP to only get for the date range
|| 03/30/07  CRG 8.4.1   Changed Marketing Division to: 'MktDiv'
|| 04/23/07  GHL 8.4.2   Increased size of ABC from 1 to 35 which is the display size of the custom field 
|| 10/14/08  GHL 10.010  (37455) Added Labor Gross
|| 12/05/08  GHL 10.014  (41133) Added Total Estimate
|| 1/20/09   GWG 10.017  Moidified Pieces to be varchar to protect against non numeric data.
|| 2/10/09   RTC 10.018  Removed query hint on tTime for better performance.
|| 02/24/10  GHL 10.519  (73337) Added ClientProjectNumber
|| 11/01/11  RLB 10.549  (124676) Added for enhancement
*/

	DECLARE	@Month smallint,
			@Year smallint, 
			@StartDate smalldatetime,
			@EndDate smalldatetime
			
	Select @StartDate = Cast(Cast(@StartingMonth as varchar) + '/1/' + Cast(@StartingYear as varchar) as smalldatetime)
	Select @EndDate = DATEADD(yy, 1, @StartDate)

	CREATE TABLE #Projects
		(ProjectKey int null,
		CustomFieldKey int null,
		ClientKey int null,
		ClientName varchar(200) null,
		RetainerKey int null,
		RetainerTitle varchar(200),
		ClientProductKey int null,
		ProductName varchar(300) null,
		ClientDivision varchar(200) null,
		ProjectNumber varchar(50) null,
		ProjectName varchar(100) null,
		ClientProjectNumber varchar(200) null,
		BillingContact int null,
		PrimaryContact varchar(100) null,
		ABC varchar(35) null,
		Closed tinyint null,
		Active varchar(6) null,
		Pieces varchar(50) null,
		Month1 decimal(24,4) null,
		Month2 decimal(24,4) null,
		Month3 decimal(24,4) null,
		Month4 decimal(24,4) null,
		Month5 decimal(24,4) null,
		Month6 decimal(24,4) null,
		Month7 decimal(24,4) null,
		Month8 decimal(24,4) null,
		Month9 decimal(24,4) null,
		Month10 decimal(24,4) null,
		Month11 decimal(24,4) null,
		Month12 decimal(24,4) null,
		LGMonth1 money null,
		LGMonth2 money null,
		LGMonth3 money null,
		LGMonth4 money null,
		LGMonth5 money null,
		LGMonth6 money null,
		LGMonth7 money null,
		LGMonth8 money null,
		LGMonth9 money null,
		LGMonth10 money null,
		LGMonth11 money null,
		LGMonth12 money null,
		ProjectTotal decimal(24,4) null,
		LaborGross money null,
		LaborGrossMonthTotal money null,
		OOP money null,
		TotalEstimate money null)
		
	INSERT	#Projects
			(ProjectKey, ClientKey, ClientProductKey, CustomFieldKey, ProjectNumber, ProjectName, ClientProjectNumber
			, BillingContact, Closed, RetainerKey, TotalEstimate)	
	SELECT	ProjectKey, ClientKey, ClientProductKey, CustomFieldKey, ProjectNumber, ProjectName, ClientProjectNumber
			, BillingContact, Closed, RetainerKey,
			ISNULL(ApprovedCOLabor, 0) + ISNULL(ApprovedCOExpense, 0)
			+ISNULL(EstLabor, 0) + ISNULL(EstExpenses, 0)
	FROM	tProject (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	AND		ISNULL(RetainerKey, 0) > 0 --Must have a retainer
	AND		(RetainerKey = @RetainerKey OR ISNULL(@RetainerKey, 0) = 0)
	AND		(ClientKey = @ClientKey OR ISNULL(@ClientKey, 0) = 0)
	
	UPDATE	#Projects
	SET		ClientName = c.CompanyName
	FROM	tCompany c (NOLOCK)
	WHERE	#Projects.ClientKey = c.CompanyKey
	
	UPDATE	#Projects
	SET		RetainerTitle = r.Title
	FROM	tRetainer r (NOLOCK)
	WHERE	#Projects.RetainerKey = r.RetainerKey
	
	UPDATE	#Projects
	SET		ProductName = cp.ProductName
	FROM	tClientProduct cp (NOLOCK)
	WHERE	#Projects.ClientProductKey = cp.ClientProductKey
	
	UPDATE	#Projects
	SET		ClientDivision = FieldValue
	FROM	vCFValues v
	WHERE	v.FieldName = 'MktDiv'
	AND		v.Entity = 'General'
	AND		v.EntityKey = @CompanyKey
	AND		#Projects.CustomFieldKey = v.CustomFieldKey
	
	UPDATE	#Projects
	SET		PrimaryContact = v.UserName
	FROM	vUserName v
	WHERE	#Projects.BillingContact = v.UserKey
	
	UPDATE	#Projects
	SET		ABC = SUBSTRING(FieldValue, 1, 35)
	FROM	vCFValues v
	WHERE	v.FieldName = 'Rating'
	AND		v.Entity = 'General'
	AND		v.EntityKey = @CompanyKey
	AND		#Projects.CustomFieldKey = v.CustomFieldKey
	
	UPDATE	#Projects
	SET		Active = 
				CASE Closed
					WHEN 1 THEN 'Closed'
					ELSE 'Active'
				END

	UPDATE	#Projects
	SET		Pieces = FieldValue
	FROM	vCFValues v
	WHERE	v.FieldName = 'Pieces'
	AND		v.Entity = 'General'
	AND		v.EntityKey = @CompanyKey
	AND		#Projects.CustomFieldKey = v.CustomFieldKey

	SELECT @Month = @StartingMonth
	SELECT @Year = @StartingYear

	UPDATE	#Projects
	SET		Month1 = 
				ISNULL((SELECT SUM(t.ActualHours)
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	UPDATE	#Projects
	SET		LGMonth1 = 
				ISNULL((SELECT SUM(ROUND(t.ActualHours * t.ActualRate, 2))
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	SELECT	@Month = @Month + 1
	IF @Month = 13
	BEGIN
		SELECT @Month = 1
		SELECT @Year = @Year + 1
	END
	
	UPDATE	#Projects
	SET		Month2 = 
				ISNULL((SELECT SUM(t.ActualHours)
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	UPDATE	#Projects
	SET		LGMonth2 = 
				ISNULL((SELECT SUM(ROUND(t.ActualHours * t.ActualRate, 2))
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)
	
	SELECT	@Month = @Month + 1
	IF @Month = 13
	BEGIN
		SELECT @Month = 1
		SELECT @Year = @Year + 1
	END
	
	UPDATE	#Projects
	SET		Month3 = 
				ISNULL((SELECT SUM(t.ActualHours)
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	UPDATE	#Projects
	SET		LGMonth3 = 
				ISNULL((SELECT SUM(ROUND(t.ActualHours * t.ActualRate, 2))
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	SELECT	@Month = @Month + 1
	IF @Month = 13
	BEGIN
		SELECT @Month = 1
		SELECT @Year = @Year + 1
	END
	
	UPDATE	#Projects
	SET		Month4 = 
				ISNULL((SELECT SUM(t.ActualHours)
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	UPDATE	#Projects
	SET		LGMonth4 = 
				ISNULL((SELECT SUM(ROUND(t.ActualHours * t.ActualRate, 2))
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)
	
	SELECT	@Month = @Month + 1
	IF @Month = 13
	BEGIN
		SELECT @Month = 1
		SELECT @Year = @Year + 1
	END
	
	UPDATE	#Projects
	SET		Month5 = 
				ISNULL((SELECT SUM(t.ActualHours)
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	UPDATE	#Projects
	SET		LGMonth5 = 
				ISNULL((SELECT SUM(ROUND(t.ActualHours * t.ActualRate, 2))
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)
	
	SELECT	@Month = @Month + 1
	IF @Month = 13
	BEGIN
		SELECT @Month = 1
		SELECT @Year = @Year + 1
	END
	
	UPDATE	#Projects
	SET		Month6 = 
				ISNULL((SELECT SUM(t.ActualHours)
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	UPDATE	#Projects
	SET		LGMonth6 = 
				ISNULL((SELECT SUM(ROUND(t.ActualHours * t.ActualRate, 2))
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)
	
	SELECT	@Month = @Month + 1
	IF @Month = 13
	BEGIN
		SELECT @Month = 1
		SELECT @Year = @Year + 1
	END
	
	UPDATE	#Projects
	SET		Month7 = 
				ISNULL((SELECT SUM(t.ActualHours)
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	UPDATE	#Projects
	SET		LGMonth7 = 
				ISNULL((SELECT SUM(ROUND(t.ActualHours * t.ActualRate, 2))
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)
	
	SELECT	@Month = @Month + 1
	IF @Month = 13
	BEGIN
		SELECT @Month = 1
		SELECT @Year = @Year + 1
	END
	
	UPDATE	#Projects
	SET		Month8 = 
				ISNULL((SELECT SUM(t.ActualHours)
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	UPDATE	#Projects
	SET		LGMonth8 = 
				ISNULL((SELECT SUM(ROUND(t.ActualHours * t.ActualRate, 2))
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)
	
	SELECT	@Month = @Month + 1
	IF @Month = 13
	BEGIN
		SELECT @Month = 1
		SELECT @Year = @Year + 1
	END
	
	UPDATE	#Projects
	SET		Month9 = 
				ISNULL((SELECT SUM(t.ActualHours)
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	UPDATE	#Projects
	SET		LGMonth9 = 
				ISNULL((SELECT SUM(ROUND(t.ActualHours * t.ActualRate, 2))
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)
	
	SELECT	@Month = @Month + 1
	IF @Month = 13
	BEGIN
		SELECT @Month = 1
		SELECT @Year = @Year + 1
	END
	
	UPDATE	#Projects
	SET		Month10 = 
				ISNULL((SELECT SUM(t.ActualHours)
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	UPDATE	#Projects
	SET		LGMonth10 = 
				ISNULL((SELECT SUM(ROUND(t.ActualHours * t.ActualRate, 2))
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)
	
	SELECT	@Month = @Month + 1
	IF @Month = 13
	BEGIN
		SELECT @Month = 1
		SELECT @Year = @Year + 1
	END
	
	UPDATE	#Projects
	SET		Month11 = 
				ISNULL((SELECT SUM(t.ActualHours)
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	UPDATE	#Projects
	SET		LGMonth11 = 
				ISNULL((SELECT SUM(ROUND(t.ActualHours * t.ActualRate, 2))
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)
	
	SELECT	@Month = @Month + 1
	IF @Month = 13
	BEGIN
		SELECT @Month = 1
		SELECT @Year = @Year + 1
	END
	
	UPDATE	#Projects
	SET		Month12 = 
				ISNULL((SELECT SUM(t.ActualHours)
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)

	UPDATE	#Projects
	SET		LGMonth12 = 
				ISNULL((SELECT SUM(ROUND(t.ActualHours * t.ActualRate, 2))
				FROM	tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		MONTH(WorkDate) = @Month
				AND		YEAR(WorkDate) = @Year), 0)
				
	UPDATE	#Projects
	SET		ProjectTotal = Month1 + Month2 + Month3 + Month4 + Month5 + Month6 + Month7 + Month8 + Month9 + Month10 + Month11 + Month12

	UPDATE	#Projects
	SET		LaborGrossMonthTotal = LGMonth1 + LGMonth2 + LGMonth3 + LGMonth4 + LGMonth5 + LGMonth6 + LGMonth7 + LGMonth8 + LGMonth9 + LGMonth10 + LGMonth11 + LGMonth12
	
	UPDATE	#Projects
	SET		OOP = 
				ISNULL((SELECT SUM(v.BillableCost)
				FROM	vProjectCosts v
				WHERE	v.ProjectKey = #Projects.ProjectKey
				AND		Type IN ('VOUCHER', 'EXPRPT', 'MISCCOST')
				AND		v.TransactionDate >= @StartDate
				AND		v.TransactionDate < @EndDate
				AND		ISNULL(v.InvoiceLineKey, 0) > 0), 0)
				

	UPDATE  #Projects
	SET     LaborGross =
			ISNULL((
				SELECT SUM(ROUND(t.ActualHours * t.ActualRate, 2))
				FROM   tTime t (NOLOCK)
				WHERE	t.ProjectKey = #Projects.ProjectKey
				AND		t.WorkDate >= @StartDate
				AND		t.WorkDate < @EndDate
			),0)	
	
	
	SELECT	*
	FROM	#Projects
	ORDER BY ClientName, RetainerTitle, ProductName, ClientDivision, ProjectNumber
GO
