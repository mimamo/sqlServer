USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetInsert]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetInsert]
	@CompanyKey int,
	@BudgetName varchar(100),
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tGLBudget
		(
		CompanyKey,
		BudgetName,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@BudgetName,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
