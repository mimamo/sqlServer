USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLaborBudgetUpdate]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLaborBudgetUpdate]
	@LaborBudgetKey int,
	@CompanyKey int,
	@BudgetName varchar(200),
	@Active tinyint

AS --Encrypt

	UPDATE
		tLaborBudget
	SET
		CompanyKey = @CompanyKey,
		BudgetName = @BudgetName,
		Active = @Active
	WHERE
		LaborBudgetKey = @LaborBudgetKey 

	RETURN 1
GO
