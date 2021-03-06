USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetGetActiveList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetGetActiveList]

	@CompanyKey int,
	@GLBudgetKey int = NULL


AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
*/

	SELECT	*
	FROM	tGLBudget (nolock)
	WHERE	CompanyKey = @CompanyKey 
	AND		(Active = 1 OR GLBudgetKey = @GLBudgetKey)
	Order By BudgetName

	RETURN 1
GO
