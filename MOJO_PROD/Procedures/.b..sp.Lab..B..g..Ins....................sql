USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLaborBudgetInsert]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLaborBudgetInsert]
	@CompanyKey int,
	@BudgetName varchar(200),
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tLaborBudget
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
