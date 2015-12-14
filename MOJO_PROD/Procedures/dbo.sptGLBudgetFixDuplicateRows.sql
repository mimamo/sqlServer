USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetFixDuplicateRows]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetFixDuplicateRows]
	@GLBudgetKey int
AS

/*
|| When      Who Rel      What
|| 2/17/09   CRG 10.0.1.9 (46555) Created to fix problem caused by difference in combos between CMP85 flex and WMJ10
*/

	CREATE TABLE #tGLBudgetDetail
		(GLBudgetKey int null,
		GLAccountKey int null,
		ClassKey int null,
		Month1 money null,
		Month2 money null,
		Month3 money null,
		Month4 money null,
		Month5 money null,
		Month6 money null,
		Month7 money null,
		Month8 money null,
		Month9 money null,
		Month10 money null,
		Month11 money null,
		Month12 money null,
		ClientKey int null,
		GLCompanyKey int null,
		OfficeKey int null,
		DepartmentKey int null)
		
	INSERT	#tGLBudgetDetail
			(GLBudgetKey,
			GLAccountKey,
			ClassKey,
			Month1,
			Month2,
			Month3,
			Month4,
			Month5,
			Month6,
			Month7,
			Month8,
			Month9,
			Month10,
			Month11,
			Month12,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey)
	SELECT	GLBudgetKey,
			GLAccountKey,
			ClassKey,
			Month1,
			Month2,
			Month3,
			Month4,
			Month5,
			Month6,
			Month7,
			Month8,
			Month9,
			Month10,
			Month11,
			Month12,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey
	FROM	tGLBudgetDetail (nolock)
	WHERE	GLBudgetKey = @GLBudgetKey
	
	DELETE	tGLBudgetDetail
	WHERE	GLBudgetKey = @GLBudgetKey
	
	INSERT	tGLBudgetDetail
			(GLBudgetKey,
			GLAccountKey,
			ClassKey,
			Month1,
			Month2,
			Month3,
			Month4,
			Month5,
			Month6,
			Month7,
			Month8,
			Month9,
			Month10,
			Month11,
			Month12,
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey)
	SELECT DISTINCT
			@GLBudgetKey,
			GLAccountKey,
			CASE
				WHEN ISNULL(ClassKey, 0) = 0 THEN -1
				ELSE ClassKey
			END AS ClassKey,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			ClientKey,
			CASE
				WHEN ISNULL(GLCompanyKey, 0) = 0 THEN -1
				ELSE GLCompanyKey
			END AS GLCompanyKey,
			CASE
				WHEN ISNULL(OfficeKey, 0) = 0 THEN -1
				ELSE OfficeKey
			END AS OfficeKey,
			CASE
				WHEN ISNULL(DepartmentKey, 0) = 0 THEN -1
				ELSE DepartmentKey
			END AS DepartmentKey
	FROM	#tGLBudgetDetail
	
	UPDATE	#tGLBudgetDetail
	SET		ClassKey = -1
	WHERE	ClassKey = 0

	UPDATE	#tGLBudgetDetail
	SET		GLCompanyKey = -1
	WHERE	GLCompanyKey = 0

	UPDATE	#tGLBudgetDetail
	SET		OfficeKey = -1
	WHERE	OfficeKey = 0

	UPDATE	#tGLBudgetDetail
	SET		DepartmentKey = -1
	WHERE	DepartmentKey = 0
		
	UPDATE	tGLBudgetDetail
	SET		Month1 = tmp.Month1,
			Month2 = tmp.Month2,
			Month3 = tmp.Month3,
			Month4 = tmp.Month4,
			Month5 = tmp.Month5,
			Month6 = tmp.Month6,
			Month7 = tmp.Month7,
			Month8 = tmp.Month8,
			Month9 = tmp.Month9,
			Month10 = tmp.Month10,
			Month11 = tmp.Month11,
			Month12 = tmp.Month12
	FROM	#tGLBudgetDetail tmp
	WHERE	tGLBudgetDetail.GLBudgetKey = tmp.GLBudgetKey
	AND		tGLBudgetDetail.GLAccountKey = tmp.GLAccountKey
	AND		tGLBudgetDetail.ClassKey = tmp.ClassKey
	AND		tGLBudgetDetail.ClientKey = tmp.ClientKey
	AND		tGLBudgetDetail.GLCompanyKey = tmp.GLCompanyKey
	AND		tGLBudgetDetail.OfficeKey = tmp.OfficeKey
	AND		tGLBudgetDetail.DepartmentKey = tmp.DepartmentKey
GO
