USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetUpdate]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetUpdate]
	@GLBudgetKey int,
	@CompanyKey int,
	@BudgetName varchar(100),
	@Active tinyint

AS --Encrypt

	UPDATE
		tGLBudget
	SET
		CompanyKey = @CompanyKey,
		BudgetName = @BudgetName,
		Active = @Active
	WHERE
		GLBudgetKey = @GLBudgetKey 

	RETURN 1
GO
