USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetFixDuplicateRowsSummary]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetFixDuplicateRowsSummary]
	@GLBudgetKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 12/18/14  GHL 10.587   Created. The logic is similar to sptGLBudgetFixDuplicateRows but the duplicate rows are summarized
||                        Also if ClientKey = -1 make it 0 
*/
	SET NOCOUNT ON
	
	CREATE TABLE #tGLBudgetDetailSumm
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
		
	INSERT	#tGLBudgetDetailSumm
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

	-- use opposite logic for Client (should not be -1 but 0)
	UPDATE	#tGLBudgetDetailSumm
	SET		ClientKey = 0
	WHERE	ClientKey = -1

	-- for the others (should not be 0 but -1)
	UPDATE	#tGLBudgetDetailSumm
	SET		ClassKey = -1
	WHERE	ClassKey = 0

	UPDATE	#tGLBudgetDetailSumm
	SET		GLCompanyKey = -1
	WHERE	GLCompanyKey = 0

	UPDATE	#tGLBudgetDetailSumm
	SET		OfficeKey = -1
	WHERE	OfficeKey = 0

	UPDATE	#tGLBudgetDetailSumm
	SET		DepartmentKey = -1
	WHERE	DepartmentKey = 0

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
	SELECT  @GLBudgetKey,
			GLAccountKey,
			ClassKey,
			SUM(Month1),
			SUM(Month2),
			SUM(Month3),
			SUM(Month4),
			SUM(Month5),
			SUM(Month6),
			SUM(Month7),
			SUM(Month8),
			SUM(Month9),
			SUM(Month10),
			SUM(Month11),
			SUM(Month12),
			ClientKey,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey
	FROM    #tGLBudgetDetailSumm
	GROUP   BY  GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey

	RETURN 1
GO
