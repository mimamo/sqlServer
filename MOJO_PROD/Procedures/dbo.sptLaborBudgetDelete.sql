USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLaborBudgetDelete]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLaborBudgetDelete]
	@LaborBudgetKey int

AS --Encrypt

	DELETE
	FROM tLaborBudgetDetail
	WHERE
		LaborBudgetKey = @LaborBudgetKey 

	DELETE
	FROM tLaborBudget
	WHERE
		LaborBudgetKey = @LaborBudgetKey 

	RETURN 1
GO
