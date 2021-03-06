USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetCopyFromActuals]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetCopyFromActuals]
	@CompanyKey int,
	@NewName varchar(100),
	@CopyYear int,
	@IncExpOnly tinyint
AS --Encrypt

/*
|| When      Who Rel     What
|| 7/2/07    CRG 8.5     Created for Enhancement 9562.
|| 3/2/11    RLB 10541   (102012) fixed to work with WMJ Class, Department, Office, GL Company need to -1 not 0
|| 8/19/11   GHL 10547   Added company to where clause
|| 12/27/11  RLB 10551   (129419) changed to fix summarize option
|| 03/22/13  MFT 10.566  (172271) Removed unused parameters/code
*/

	DECLARE	@NewGLBudgetKey int,
			@Month smallint,
			@Year int,
			@NextMonth smallint,
			@NextMonthYear int	

	INSERT	tGLBudget
			(CompanyKey,
			BudgetType,
			BudgetName,
			Active)
	VALUES	(@CompanyKey,
			1,
			@NewName,
			1)
	
	SELECT	@NewGLBudgetKey = @@IDENTITY

/* Assume created in VB
	CREATE TABLE #tGLBudgetDetail
		(GLAccountKey int NULL,
		ClassKey int NULL,
		Month1 money NULL,
		Month2 money NULL,
		Month3 money NULL,
		Month4 money NULL,
		Month5 money NULL,
		Month6 money NULL,
		Month7 money NULL,
		Month8 money NULL,
		Month9 money NULL,
		Month10 money NULL,
		Month11 money NULL,
		Month12 money NULL,
		ClientKey int NULL,
		GLCompanyKey int,
		OfficeKey int,
		DepartmentKey int NULL,
		Summarise int)
*/
	--Month 1
	SELECT	@Month = FirstMonth
	FROM	tPreference	(nolock)
	WHERE	CompanyKey = @CompanyKey
	
	SELECT	@Year = @CopyYear
	SELECT	@NextMonthYear = @Year
	
	SELECT	@NextMonth = @Month + 1
	
	IF @NextMonth > 12
	BEGIN
		SELECT	@NextMonth = 1
		SELECT	@NextMonthYear = @NextMonthYear + 1
	END
		
	INSERT	#tGLBudgetDetail
			(GLAccountKey,
			ClassKey,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,
			Month1,
			Summarize)
	SELECT	t.GLAccountKey,
			ISNULL(t.ClassKey, -1),
			ISNULL(t.ClientKey, 0),
			ISNULL(t.GLCompanyKey, -1),
			ISNULL(t.OfficeKey, -1),
			ISNULL(t.DepartmentKey, -1),
			CASE
				WHEN gl.AccountType IN (10, 11, 12, 13, 14, 50, 51, 52) THEN SUM(Debit - Credit)
				ELSE SUM(Credit - Debit)
			END,
			0
	FROM	tTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= CAST(CAST(@Month AS varchar) + '/' + '1/' + CAST(@Year AS varchar) AS smalldatetime)
	AND		t.TransactionDate < CAST(CAST(@NextMonth AS varchar) + '/' + '1/' + CAST(@NextMonthYear AS varchar) AS smalldatetime)
	AND		((@IncExpOnly = 1 AND gl.AccountType IN (40, 41, 50, 51)) OR (@IncExpOnly = 0))
	AND     t.CompanyKey = @CompanyKey
	GROUP BY t.GLAccountKey, t.ClassKey, t.ClientKey, t.GLCompanyKey, t.OfficeKey, t.DepartmentKey, gl.AccountType
	
	--Month 2
	SELECT	@Month = @Month + 1

	IF @Month > 12
	BEGIN
		SELECT	@Month = 1
		SELECT	@Year = @Year + 1
	END
	
	SELECT	@NextMonth = @Month + 1
	
	IF @NextMonth > 12
	BEGIN
		SELECT	@NextMonth = 1
		SELECT	@NextMonthYear = @NextMonthYear + 1
	END
		
	INSERT	#tGLBudgetDetail
			(GLAccountKey,
			ClassKey,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,
			Month2,
			Summarize)
	SELECT	t.GLAccountKey,
			ISNULL(t.ClassKey, -1),
			ISNULL(t.ClientKey, 0),
			ISNULL(t.GLCompanyKey, -1),
			ISNULL(t.OfficeKey, -1),
			ISNULL(t.DepartmentKey, -1),
			CASE
				WHEN gl.AccountType IN (10, 11, 12, 13, 14, 50, 51, 52) THEN SUM(Debit - Credit)
				ELSE SUM(Credit - Debit)
			END,
			0
	FROM	tTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= CAST(CAST(@Month AS varchar) + '/' + '1/' + CAST(@Year AS varchar) AS smalldatetime)
	AND		t.TransactionDate < CAST(CAST(@NextMonth AS varchar) + '/' + '1/' + CAST(@NextMonthYear AS varchar) AS smalldatetime)
	AND		((@IncExpOnly = 1 AND gl.AccountType IN (40, 41, 50, 51)) OR (@IncExpOnly = 0))
	AND     t.CompanyKey = @CompanyKey
	GROUP BY t.GLAccountKey, t.ClassKey, t.ClientKey, t.GLCompanyKey, t.OfficeKey, t.DepartmentKey, gl.AccountType
	
	--Month 3
	SELECT	@Month = @Month + 1

	IF @Month > 12
	BEGIN
		SELECT	@Month = 1
		SELECT	@Year = @Year + 1
	END
	
	SELECT	@NextMonth = @Month + 1
	
	IF @NextMonth > 12
	BEGIN
		SELECT	@NextMonth = 1
		SELECT	@NextMonthYear = @NextMonthYear + 1
	END
		
	INSERT	#tGLBudgetDetail
			(GLAccountKey,
			ClassKey,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,
			Month3,
			Summarize)
	SELECT	t.GLAccountKey,
			ISNULL(t.ClassKey, -1),
			ISNULL(t.ClientKey, 0),
			ISNULL(t.GLCompanyKey, -1),
			ISNULL(t.OfficeKey, -1),
			ISNULL(t.DepartmentKey, -1),
			CASE
				WHEN gl.AccountType IN (10, 11, 12, 13, 14, 50, 51, 52) THEN SUM(Debit - Credit)
				ELSE SUM(Credit - Debit)
			END,
			0
	FROM	tTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= CAST(CAST(@Month AS varchar) + '/' + '1/' + CAST(@Year AS varchar) AS smalldatetime)
	AND		t.TransactionDate < CAST(CAST(@NextMonth AS varchar) + '/' + '1/' + CAST(@NextMonthYear AS varchar) AS smalldatetime)
	AND		((@IncExpOnly = 1 AND gl.AccountType IN (40, 41, 50, 51)) OR (@IncExpOnly = 0))
	AND     t.CompanyKey = @CompanyKey
	GROUP BY t.GLAccountKey, t.ClassKey, t.ClientKey, t.GLCompanyKey, t.OfficeKey, t.DepartmentKey, gl.AccountType
	
	--Month 4
	SELECT	@Month = @Month + 1

	IF @Month > 12
	BEGIN
		SELECT	@Month = 1
		SELECT	@Year = @Year + 1
	END
	
	SELECT	@NextMonth = @Month + 1
	
	IF @NextMonth > 12
	BEGIN
		SELECT	@NextMonth = 1
		SELECT	@NextMonthYear = @NextMonthYear + 1
	END
		
	INSERT	#tGLBudgetDetail
			(GLAccountKey,
			ClassKey,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,
			Month4,
			Summarize)
	SELECT	t.GLAccountKey,
			ISNULL(t.ClassKey, -1),
			ISNULL(t.ClientKey, 0),
			ISNULL(t.GLCompanyKey, -1),
			ISNULL(t.OfficeKey, -1),
			ISNULL(t.DepartmentKey, -1),
			CASE
				WHEN gl.AccountType IN (10, 11, 12, 13, 14, 50, 51, 52) THEN SUM(Debit - Credit)
				ELSE SUM(Credit - Debit)
			END,
			0
	FROM	tTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= CAST(CAST(@Month AS varchar) + '/' + '1/' + CAST(@Year AS varchar) AS smalldatetime)
	AND		t.TransactionDate < CAST(CAST(@NextMonth AS varchar) + '/' + '1/' + CAST(@NextMonthYear AS varchar) AS smalldatetime)
	AND		((@IncExpOnly = 1 AND gl.AccountType IN (40, 41, 50, 51)) OR (@IncExpOnly = 0))
	AND     t.CompanyKey = @CompanyKey
	GROUP BY t.GLAccountKey, t.ClassKey, t.ClientKey, t.GLCompanyKey, t.OfficeKey, t.DepartmentKey, gl.AccountType
	
	--Month 5
	SELECT	@Month = @Month + 1

	IF @Month > 12
	BEGIN
		SELECT	@Month = 1
		SELECT	@Year = @Year + 1
	END
	
	SELECT	@NextMonth = @Month + 1
	
	IF @NextMonth > 12
	BEGIN
		SELECT	@NextMonth = 1
		SELECT	@NextMonthYear = @NextMonthYear + 1
	END
		
	INSERT	#tGLBudgetDetail
			(GLAccountKey,
			ClassKey,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,
			Month5,
			Summarize)
	SELECT	t.GLAccountKey,
			ISNULL(t.ClassKey, -1),
			ISNULL(t.ClientKey, 0),
			ISNULL(t.GLCompanyKey, -1),
			ISNULL(t.OfficeKey, -1),
			ISNULL(t.DepartmentKey, -1),
			CASE
				WHEN gl.AccountType IN (10, 11, 12, 13, 14, 50, 51, 52) THEN SUM(Debit - Credit)
				ELSE SUM(Credit - Debit)
			END,
			0
	FROM	tTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= CAST(CAST(@Month AS varchar) + '/' + '1/' + CAST(@Year AS varchar) AS smalldatetime)
	AND		t.TransactionDate < CAST(CAST(@NextMonth AS varchar) + '/' + '1/' + CAST(@NextMonthYear AS varchar) AS smalldatetime)
	AND		((@IncExpOnly = 1 AND gl.AccountType IN (40, 41, 50, 51)) OR (@IncExpOnly = 0))
	AND     t.CompanyKey = @CompanyKey
	GROUP BY t.GLAccountKey, t.ClassKey, t.ClientKey, t.GLCompanyKey, t.OfficeKey, t.DepartmentKey, gl.AccountType
	
	--Month 6
	SELECT	@Month = @Month + 1

	IF @Month > 12
	BEGIN
		SELECT	@Month = 1
		SELECT	@Year = @Year + 1
	END
	
	SELECT	@NextMonth = @Month + 1
	
	IF @NextMonth > 12
	BEGIN
		SELECT	@NextMonth = 1
		SELECT	@NextMonthYear = @NextMonthYear + 1
	END
		
	INSERT	#tGLBudgetDetail
			(GLAccountKey,
			ClassKey,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,
			Month6,
			Summarize)
	SELECT	t.GLAccountKey,
			ISNULL(t.ClassKey, -1),
			ISNULL(t.ClientKey, 0),
			ISNULL(t.GLCompanyKey, -1),
			ISNULL(t.OfficeKey, -1),
			ISNULL(t.DepartmentKey, -1),
			CASE
				WHEN gl.AccountType IN (10, 11, 12, 13, 14, 50, 51, 52) THEN SUM(Debit - Credit)
				ELSE SUM(Credit - Debit)
			END,
			0
	FROM	tTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= CAST(CAST(@Month AS varchar) + '/' + '1/' + CAST(@Year AS varchar) AS smalldatetime)
	AND		t.TransactionDate < CAST(CAST(@NextMonth AS varchar) + '/' + '1/' + CAST(@NextMonthYear AS varchar) AS smalldatetime)
	AND		((@IncExpOnly = 1 AND gl.AccountType IN (40, 41, 50, 51)) OR (@IncExpOnly = 0))
	AND     t.CompanyKey = @CompanyKey
	GROUP BY t.GLAccountKey, t.ClassKey, t.ClientKey, t.GLCompanyKey, t.OfficeKey, t.DepartmentKey, gl.AccountType
	
	--Month 7
	SELECT	@Month = @Month + 1

	IF @Month > 12
	BEGIN
		SELECT	@Month = 1
		SELECT	@Year = @Year + 1
	END
	
	SELECT	@NextMonth = @Month + 1
	
	IF @NextMonth > 12
	BEGIN
		SELECT	@NextMonth = 1
		SELECT	@NextMonthYear = @NextMonthYear + 1
	END
		
	INSERT	#tGLBudgetDetail
			(GLAccountKey,
			ClassKey,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,
			Month7,
			Summarize)
	SELECT	t.GLAccountKey,
			ISNULL(t.ClassKey, -1),
			ISNULL(t.ClientKey, 0),
			ISNULL(t.GLCompanyKey, -1),
			ISNULL(t.OfficeKey, -1),
			ISNULL(t.DepartmentKey, -1),
			CASE
				WHEN gl.AccountType IN (10, 11, 12, 13, 14, 50, 51, 52) THEN SUM(Debit - Credit)
				ELSE SUM(Credit - Debit)
			END,
			0
	FROM	tTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= CAST(CAST(@Month AS varchar) + '/' + '1/' + CAST(@Year AS varchar) AS smalldatetime)
	AND		t.TransactionDate < CAST(CAST(@NextMonth AS varchar) + '/' + '1/' + CAST(@NextMonthYear AS varchar) AS smalldatetime)
	AND		((@IncExpOnly = 1 AND gl.AccountType IN (40, 41, 50, 51)) OR (@IncExpOnly = 0))
	AND     t.CompanyKey = @CompanyKey
	GROUP BY t.GLAccountKey, t.ClassKey, t.ClientKey, t.GLCompanyKey, t.OfficeKey, t.DepartmentKey, gl.AccountType
	
	--Month 8
	SELECT	@Month = @Month + 1

	IF @Month > 12
	BEGIN
		SELECT	@Month = 1
		SELECT	@Year = @Year + 1
	END
	
	SELECT	@NextMonth = @Month + 1
	
	IF @NextMonth > 12
	BEGIN
		SELECT	@NextMonth = 1
		SELECT	@NextMonthYear = @NextMonthYear + 1
	END
		
	INSERT	#tGLBudgetDetail
			(GLAccountKey,
			ClassKey,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,
			Month8,
			Summarize)
	SELECT	t.GLAccountKey,
			ISNULL(t.ClassKey, -1),
			ISNULL(t.ClientKey, 0),
			ISNULL(t.GLCompanyKey, -1),
			ISNULL(t.OfficeKey, -1),
			ISNULL(t.DepartmentKey, -1),
			CASE
				WHEN gl.AccountType IN (10, 11, 12, 13, 14, 50, 51, 52) THEN SUM(Debit - Credit)
				ELSE SUM(Credit - Debit)
			END,
			0
	FROM	tTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= CAST(CAST(@Month AS varchar) + '/' + '1/' + CAST(@Year AS varchar) AS smalldatetime)
	AND		t.TransactionDate < CAST(CAST(@NextMonth AS varchar) + '/' + '1/' + CAST(@NextMonthYear AS varchar) AS smalldatetime)
	AND		((@IncExpOnly = 1 AND gl.AccountType IN (40, 41, 50, 51)) OR (@IncExpOnly = 0))
	AND     t.CompanyKey = @CompanyKey
	GROUP BY t.GLAccountKey, t.ClassKey, t.ClientKey, t.GLCompanyKey, t.OfficeKey, t.DepartmentKey, gl.AccountType
	
	--Month 9
	SELECT	@Month = @Month + 1

	IF @Month > 12
	BEGIN
		SELECT	@Month = 1
		SELECT	@Year = @Year + 1
	END
	
	SELECT	@NextMonth = @Month + 1
	
	IF @NextMonth > 12
	BEGIN
		SELECT	@NextMonth = 1
		SELECT	@NextMonthYear = @NextMonthYear + 1
	END
		
	INSERT	#tGLBudgetDetail
			(GLAccountKey,
			ClassKey,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,
			Month9,
			Summarize)
	SELECT	t.GLAccountKey,
			ISNULL(t.ClassKey, -1),
			ISNULL(t.ClientKey, 0),
			ISNULL(t.GLCompanyKey, -1),
			ISNULL(t.OfficeKey, -1),
			ISNULL(t.DepartmentKey, -1),
			CASE
				WHEN gl.AccountType IN (10, 11, 12, 13, 14, 50, 51, 52) THEN SUM(Debit - Credit)
				ELSE SUM(Credit - Debit)
			END,
			0
	FROM	tTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= CAST(CAST(@Month AS varchar) + '/' + '1/' + CAST(@Year AS varchar) AS smalldatetime)
	AND		t.TransactionDate < CAST(CAST(@NextMonth AS varchar) + '/' + '1/' + CAST(@NextMonthYear AS varchar) AS smalldatetime)
	AND		((@IncExpOnly = 1 AND gl.AccountType IN (40, 41, 50, 51)) OR (@IncExpOnly = 0))
	AND     t.CompanyKey = @CompanyKey
	GROUP BY t.GLAccountKey, t.ClassKey, t.ClientKey, t.GLCompanyKey, t.OfficeKey, t.DepartmentKey, gl.AccountType
	
	--Month 10
	SELECT	@Month = @Month + 1

	IF @Month > 12
	BEGIN
		SELECT	@Month = 1
		SELECT	@Year = @Year + 1
	END
	
	SELECT	@NextMonth = @Month + 1
	
	IF @NextMonth > 12
	BEGIN
		SELECT	@NextMonth = 1
		SELECT	@NextMonthYear = @NextMonthYear + 1
	END
		
	INSERT	#tGLBudgetDetail
			(GLAccountKey,
			ClassKey,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,
			Month10,
			Summarize)
	SELECT	t.GLAccountKey,
			ISNULL(t.ClassKey, -1),
			ISNULL(t.ClientKey, 0),
			ISNULL(t.GLCompanyKey, -1),
			ISNULL(t.OfficeKey, -1),
			ISNULL(t.DepartmentKey, -1),
			CASE
				WHEN gl.AccountType IN (10, 11, 12, 13, 14, 50, 51, 52) THEN SUM(Debit - Credit)
				ELSE SUM(Credit - Debit)
			END,
			0
	FROM	tTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= CAST(CAST(@Month AS varchar) + '/' + '1/' + CAST(@Year AS varchar) AS smalldatetime)
	AND		t.TransactionDate < CAST(CAST(@NextMonth AS varchar) + '/' + '1/' + CAST(@NextMonthYear AS varchar) AS smalldatetime)
	AND		((@IncExpOnly = 1 AND gl.AccountType IN (40, 41, 50, 51)) OR (@IncExpOnly = 0))
	AND     t.CompanyKey = @CompanyKey
	GROUP BY t.GLAccountKey, t.ClassKey, t.ClientKey, t.GLCompanyKey, t.OfficeKey, t.DepartmentKey, gl.AccountType
	
	--Month 11
	SELECT	@Month = @Month + 1

	IF @Month > 12
	BEGIN
		SELECT	@Month = 1
		SELECT	@Year = @Year + 1
	END
	
	SELECT	@NextMonth = @Month + 1
	
	IF @NextMonth > 12
	BEGIN
		SELECT	@NextMonth = 1
		SELECT	@NextMonthYear = @NextMonthYear + 1
	END
		
	INSERT	#tGLBudgetDetail
			(GLAccountKey,
			ClassKey,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,
			Month11,
			Summarize)
	SELECT	t.GLAccountKey,
			ISNULL(t.ClassKey, -1),
			ISNULL(t.ClientKey, 0),
			ISNULL(t.GLCompanyKey, -1),
			ISNULL(t.OfficeKey, -1),
			ISNULL(t.DepartmentKey, -1),
			CASE
				WHEN gl.AccountType IN (10, 11, 12, 13, 14, 50, 51, 52) THEN SUM(Debit - Credit)
				ELSE SUM(Credit - Debit)
			END,
			0
	FROM	tTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= CAST(CAST(@Month AS varchar) + '/' + '1/' + CAST(@Year AS varchar) AS smalldatetime)
	AND		t.TransactionDate < CAST(CAST(@NextMonth AS varchar) + '/' + '1/' + CAST(@NextMonthYear AS varchar) AS smalldatetime)
	AND		((@IncExpOnly = 1 AND gl.AccountType IN (40, 41, 50, 51)) OR (@IncExpOnly = 0))
	AND     t.CompanyKey = @CompanyKey
	GROUP BY t.GLAccountKey, t.ClassKey, t.ClientKey, t.GLCompanyKey, t.OfficeKey, t.DepartmentKey, gl.AccountType
	
	--Month 12
	SELECT	@Month = @Month + 1

	IF @Month > 12
	BEGIN
		SELECT	@Month = 1
		SELECT	@Year = @Year + 1
	END
	
	SELECT	@NextMonth = @Month + 1
	
	IF @NextMonth > 12
	BEGIN
		SELECT	@NextMonth = 1
		SELECT	@NextMonthYear = @NextMonthYear + 1
	END
		
	INSERT	#tGLBudgetDetail
			(GLAccountKey,
			ClassKey,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,
			Month12,
			Summarize)
	SELECT	t.GLAccountKey,
			ISNULL(t.ClassKey, -1),
			ISNULL(t.ClientKey, 0),
			ISNULL(t.GLCompanyKey, -1),
			ISNULL(t.OfficeKey, -1),
			ISNULL(t.DepartmentKey, -1),
			CASE
				WHEN gl.AccountType IN (10, 11, 12, 13, 14, 50, 51, 52) THEN SUM(Debit - Credit)
				ELSE SUM(Credit - Debit)
			END,
			0
	FROM	tTransaction t (nolock)
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	WHERE	t.TransactionDate >= CAST(CAST(@Month AS varchar) + '/' + '1/' + CAST(@Year AS varchar) AS smalldatetime)
	AND		t.TransactionDate < CAST(CAST(@NextMonth AS varchar) + '/' + '1/' + CAST(@NextMonthYear AS varchar) AS smalldatetime)
	AND		((@IncExpOnly = 1 AND gl.AccountType IN (40, 41, 50, 51)) OR (@IncExpOnly = 0))
	AND     t.CompanyKey = @CompanyKey
	GROUP BY t.GLAccountKey, t.ClassKey, t.ClientKey, t.GLCompanyKey, t.OfficeKey, t.DepartmentKey, gl.AccountType

RETURN @NewGLBudgetKey
GO
