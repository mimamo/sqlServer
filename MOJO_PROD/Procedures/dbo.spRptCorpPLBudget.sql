USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCorpPLBudget]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptCorpPLBudget]
	@CompanyKey int,
	@GLBudgetKey int,
	@Month int,
	@UseCashBasisAccountType int = 0,
	@UserKey int = null
	
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/26/07   CRG 8.5      Created for Flex Corporate P&L
|| 3/12/09   CRG 10.0.2.0 Modified to handle the fact that "No Specific" is now saved as -1.
|| 6/12/09   GHL 10.0.2.7 Added UseCashBasisAccountType to support cash basis account types 
|| 12/7/09   CRG 10.5.1.5 (46327) Modified to use a temp table for selected ClassKeys
|| 04/11/12  GHL 10.555   Added UserKey for UserGLCompanyAccess
|| 07/18/12  GHL 10.558   Added support of multiple GL Companies
||                        In tBudgetDetail.GLCompanyKey = -1 No Company Specified (means Blank)
||                        Or it can be a specific company  
|| 8/21/12   CRG 10.5.5.8 (152198) Fixed typo in select of #OfficeKeys and removed the @DepartmentKey parameter
*/

/* Assume Created in VB
	CREATE TABLE #ClassKeys (ClassKey int NULL)
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
from   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

DECLARE	@HasClassKeys int
SELECT	@HasClassKeys = COUNT(*)
FROM	#ClassKeys

DECLARE	@HasGLCompanyKeys int
SELECT	@HasGLCompanyKeys = COUNT(*)
FROM	#GLCompanyKeys
	
DECLARE	@HasOfficeKeys int
SELECT	@HasOfficeKeys = COUNT(*)
FROM	#OfficeKeys

DECLARE	@HasDepartmentKeys int
SELECT	@HasDepartmentKeys = COUNT(*)
FROM	#DepartmentKeys

DECLARE	@ClassKeyContainsZero int
SELECT	@ClassKeyContainsZero = COUNT(*)
FROM	#ClassKeys
WHERE	ClassKey = 0

DECLARE	@GLCompanyKeyContainsZero int
SELECT	@GLCompanyKeyContainsZero = COUNT(*)
FROM	#GLCompanyKeys
WHERE	GLCompanyKey = 0

DECLARE	@OfficeKeyContainsZero int
SELECT	@OfficeKeyContainsZero = COUNT(*)
FROM	#OfficeKeys
WHERE	OfficeKey = 0

DECLARE	@DepartmentKeyContainsZero int
SELECT	@DepartmentKeyContainsZero = COUNT(*)
FROM	#DepartmentKeys
WHERE	DepartmentKey = 0
	
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
				
				AND (
						-- All companies
						(
						@HasGLCompanyKeys = 0 AND
							(
							@RestrictToGLCompany = 0 OR 
							(bd.GLCompanyKey = -1 OR
							bd.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
					-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
					OR
						(
						-- If Blank requested, add -1 values
						(@GLCompanyKeyContainsZero = 1 And bd.GLCompanyKey = -1)
						 OR
						ISNULL(bd.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
						)
					)

				AND (
					-- All offices
					@HasOfficeKeys = 0 
					-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
					OR
						(
						(@OfficeKeyContainsZero = 1 And bd.OfficeKey = -1) OR
						ISNULL(bd.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
						)
					)

				AND		(ISNULL(bd.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) 
						OR @HasClassKeys = 0 
						OR (bd.ClassKey = -1 AND @ClassKeyContainsZero = 1)
						)
				
				AND (
					-- All depts
					@HasDepartmentKeys = 0 
					-- Or specific Departments requested (Is Blank will be 0 in #DepartmentKeys)
					OR
						(
						(@DepartmentKeyContainsZero = 1 And bd.DepartmentKey = -1) OR
						ISNULL(bd.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)	
						)
					)
		
			), 0) AS Amount
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

				AND (
						-- All companies
						(
						@HasGLCompanyKeys = 0 AND
							(
							@RestrictToGLCompany = 0 OR 
							(bd.GLCompanyKey = -1 OR
							bd.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
							)
						)
					-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
					OR
						(
						-- If Blank requested, add -1 values
						(@GLCompanyKeyContainsZero = 1 And bd.GLCompanyKey = -1)
						 OR
						ISNULL(bd.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
						)
					)

				AND (
					-- All offices
					@HasOfficeKeys = 0 
					-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
					OR
						(
						(@OfficeKeyContainsZero = 1 And bd.OfficeKey = -1) OR
						ISNULL(bd.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
						)
					)

				AND		(ISNULL(bd.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) 
				OR @HasClassKeys = 0 
				OR (bd.ClassKey = -1 AND @ClassKeyContainsZero = 1))
				AND (
					-- All depts
					@HasDepartmentKeys = 0 
					-- Or specific Departments requested (Is Blank will be 0 in #DepartmentKeys)
					OR
						(
						(@DepartmentKeyContainsZero = 1 And bd.DepartmentKey = -1) OR
						ISNULL(bd.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)	
						)
					)

			), 0) AS Amount
	FROM	vGLAccountCash gl (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		AccountType IN (40, 41, 50, 51, 52)
	ORDER BY MinorGroup, DisplayOrder
GO
