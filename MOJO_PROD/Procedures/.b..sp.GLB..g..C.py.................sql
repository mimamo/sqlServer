USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetCopy]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetCopy]
	@GLBudgetKey int,
	@NewName varchar(100)
AS --Encrypt

/*
|| When      Who Rel     What
|| 7/2/07    CRG 8.5     Created for Enhancement 9562.
|| 12/18/14  GHL 10.587  (239993) do not propagate duplicate details
*/

	DECLARE	@NewGLBudgetKey int
	
	INSERT	tGLBudget
			(CompanyKey,
			BudgetType,
			BudgetName,
			Active)
	SELECT	CompanyKey,
			BudgetType,
			@NewName,
			1
	FROM	tGLBudget (nolock)
	WHERE	GLBudgetKey = @GLBudgetKey
	
	SELECT	@NewGLBudgetKey = @@IDENTITY
	
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
	SELECT	@NewGLBudgetKey, 
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
			
	-- do not propagate duplicates, fix them here
	exec sptGLBudgetFixDuplicateRowsSummary @NewGLBudgetKey

	RETURN @NewGLBudgetKey
GO
