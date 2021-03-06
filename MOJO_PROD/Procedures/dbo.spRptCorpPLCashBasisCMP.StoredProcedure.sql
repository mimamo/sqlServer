USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCorpPLCashBasisCMP]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptCorpPLCashBasisCMP]
	@CompanyKey int,
	@GLCompanyKey int,
	@OfficeKey int,
	@ClassKey int,
	@DepartmentKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime
AS --Encrypt

/*
|| When      Who Rel      What
|| 12/7/09   CRG 10.5.1.5 (46327) Created so that the old SP can be modified for WMJ, but the CMP logic can remain the same
*/

SELECT	GLAccountKey,
		isnull(ParentAccountKey, 0) as ParentAccountKey,
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
			CASE 
				WHEN AccountType IN (40, 41) THEN
					(SELECT SUM(Credit - Debit) 
					FROM	tCashTransaction t (nolock) 
					WHERE	t.GLAccountKey = gl.GLAccountKey
					--If we pass in 0 for GLCompany, Office, Class, or Department, we want rows where that value is NULL.
					--If we pass in NULL, we want all rows.					
					AND		(ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
					AND		(ISNULL(t.OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
					AND		(ISNULL(t.ClassKey, 0) = @ClassKey OR @ClassKey IS NULL)
					AND		(ISNULL(t.DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
					AND		t.TransactionDate >= @StartDate
					AND		t.TransactionDate <= @EndDate)
				ELSE
					(SELECT SUM(Debit - Credit) 
					FROM	tCashTransaction t (nolock) 
					WHERE	t.GLAccountKey = gl.GLAccountKey
					AND		(ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
					AND		(ISNULL(t.OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
					AND		(ISNULL(t.ClassKey, 0) = @ClassKey OR @ClassKey IS NULL)
					AND		(ISNULL(t.DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
					AND		t.TransactionDate >= @StartDate
					AND		t.TransactionDate <= @EndDate)
			END
		, 0) AS Amount
FROM	vGLAccountCash gl (nolock)
WHERE	CompanyKey = @CompanyKey 
AND		AccountType IN (40, 41, 50, 51, 52)
ORDER BY MinorGroup, DisplayOrder
GO
