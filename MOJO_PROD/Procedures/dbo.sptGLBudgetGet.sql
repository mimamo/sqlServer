USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetGet]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetGet]
	@GLBudgetKey int

AS --Encrypt

		SELECT *
		FROM tGLBudget (nolock)
		WHERE
			GLBudgetKey = @GLBudgetKey

	RETURN 1
GO
