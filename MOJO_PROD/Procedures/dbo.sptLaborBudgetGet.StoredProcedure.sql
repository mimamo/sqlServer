USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLaborBudgetGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLaborBudgetGet]
	@LaborBudgetKey int

AS --Encrypt

		SELECT *
		FROM tLaborBudget (nolock)
		WHERE
			LaborBudgetKey = @LaborBudgetKey

	RETURN 1
GO
