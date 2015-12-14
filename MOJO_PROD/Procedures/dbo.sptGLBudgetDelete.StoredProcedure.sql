USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetDelete]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetDelete]
	@GLBudgetKey int

AS --Encrypt

	DELETE
	FROM tGLBudgetDetail
	WHERE
		GLBudgetKey = @GLBudgetKey 

	DELETE
	FROM tGLBudget
	WHERE
		GLBudgetKey = @GLBudgetKey 

	RETURN 1
GO
