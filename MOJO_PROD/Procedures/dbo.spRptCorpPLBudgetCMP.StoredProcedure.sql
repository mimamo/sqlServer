USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCorpPLBudgetCMP]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptCorpPLBudgetCMP]
	@CompanyKey int,
	@GLCompanyKey int,
	@OfficeKey int,
	@ClassKey int,
	@DepartmentKey int,
	@GLBudgetKey int,
	@Month int,
	@UseCashBasisAccountType int = 0
	
AS --Encrypt

/*
|| When      Who Rel      What
|| 12/7/09   CRG 10.5.1.5 (46327) Created so that the old SP can be modified for WMJ, but the CMP logic can remain the same
*/

IF @GLCompanyKey = 0
	SELECT @GLCompanyKey = -1
	
IF @OfficeKey = 0
	SELECT @OfficeKey = -1
	
IF @ClassKey = 0
	SELECT @ClassKey = -1

IF @DepartmentKey = 0
	SELECT @DepartmentKey = -1
	
IF @UseCashBasisAccountType = 0

SELECT	GLAccountKey,
		ISNULL(ParentAccountKey, 0) AS ParentAccountKey,
		DisplayOrder,
		DisplayLevel,
		Rollup,
		CASE AccountType
			WHEN 40 THEN 1
			WHEN 50 THEN 2
			WHEN 51 THEN 3
			WHEN 41 THEN 4
			WHEN 52 THEN 5 
		END AS MinorGroup,
		ISNULL(
			(SELECT	SUM(
					CASE @Month
						WHEN -1 THEN ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0)
									+ ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0)
									+ ISNULL(bd.Month11, 0) + ISNULL(bd.Month12, 0)
						WHEN 1 THEN bd.Month1
						WHEN 2 THEN bd.Month2
						WHEN 3 THEN bd.Month3
						WHEN 4 THEN bd.Month4
						WHEN 5 THEN bd.Month5
						WHEN 6 THEN bd.Month6
						WHEN 7 THEN bd.Month7
						WHEN 8 THEN bd.Month8
						WHEN 9 THEN bd.Month9
						WHEN 10 THEN bd.Month10
						WHEN 11 THEN bd.Month11
						WHEN 12 THEN bd.Month12
					END)
			FROM	tGLBudgetDetail bd (nolock)
			WHERE	bd.GLAccountKey = gl.GLAccountKey
			AND		bd.GLBudgetKey = @GLBudgetKey
			AND		(ISNULL(bd.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND		(ISNULL(bd.OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
			AND		(ISNULL(bd.ClassKey, 0) = @ClassKey OR @ClassKey IS NULL)
			AND		(ISNULL(bd.DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL))
		, 0) AS Amount
FROM	tGLAccount gl (nolock)
WHERE	CompanyKey = @CompanyKey
AND		AccountType IN (40, 41, 50, 51, 52)
ORDER BY MinorGroup, DisplayOrder	

ELSE

SELECT	GLAccountKey,
		ISNULL(ParentAccountKey, 0) AS ParentAccountKey,
		DisplayOrder,
		DisplayLevel,
		Rollup,
		CASE AccountType
			WHEN 40 THEN 1
			WHEN 50 THEN 2
			WHEN 51 THEN 3
			WHEN 41 THEN 4
			WHEN 52 THEN 5 
		END AS MinorGroup,
		ISNULL(
			(SELECT	SUM(
					CASE @Month
						WHEN -1 THEN ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0)
									+ ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0)
									+ ISNULL(bd.Month11, 0) + ISNULL(bd.Month12, 0)
						WHEN 1 THEN bd.Month1
						WHEN 2 THEN bd.Month2
						WHEN 3 THEN bd.Month3
						WHEN 4 THEN bd.Month4
						WHEN 5 THEN bd.Month5
						WHEN 6 THEN bd.Month6
						WHEN 7 THEN bd.Month7
						WHEN 8 THEN bd.Month8
						WHEN 9 THEN bd.Month9
						WHEN 10 THEN bd.Month10
						WHEN 11 THEN bd.Month11
						WHEN 12 THEN bd.Month12
					END)
			FROM	tGLBudgetDetail bd (nolock)
			WHERE	bd.GLAccountKey = gl.GLAccountKey
			AND		bd.GLBudgetKey = @GLBudgetKey
			AND		(ISNULL(bd.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND		(ISNULL(bd.OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
			AND		(ISNULL(bd.ClassKey, 0) = @ClassKey OR @ClassKey IS NULL)
			AND		(ISNULL(bd.DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL))
		, 0) AS Amount
FROM	vGLAccountCash gl (nolock)
WHERE	CompanyKey = @CompanyKey
AND		AccountType IN (40, 41, 50, 51, 52)
ORDER BY MinorGroup, DisplayOrder
GO
