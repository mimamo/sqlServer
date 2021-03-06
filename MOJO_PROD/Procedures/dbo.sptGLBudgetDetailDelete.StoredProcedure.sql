USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetDetailDelete]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetDetailDelete]
	@GLBudgetKey int,
	@GLAccountKey int,
	@ClassKey int,
	@ClientKey int,
	@GLCompanyKey int,
	@OfficeKey int,
	@DepartmentKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 6/27/07   CRG 8.5	 Created for Enhancement 9562.
*/

	DELETE	tGLBudgetDetail
	WHERE	GLBudgetKey = @GLBudgetKey
	AND		GLAccountKey = @GLAccountKey
	AND		ClassKey = @ClassKey
	AND		ClientKey = @ClientKey
	AND		GLCompanyKey = @GLCompanyKey
	AND		OfficeKey = @OfficeKey
	AND		DepartmentKey = @DepartmentKey
GO
