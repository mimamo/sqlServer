USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLaborBudgetGetList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLaborBudgetGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tLaborBudget (nolock)
		WHERE
		CompanyKey = @CompanyKey
		Order By BudgetName

	RETURN 1
GO
