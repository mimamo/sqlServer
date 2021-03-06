USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLaborBudgetGetActiveList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLaborBudgetGetActiveList]

	@CompanyKey int,
	@LaborBudgetKey int = NULL

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
*/

		SELECT	*
		FROM	tLaborBudget (nolock)
		WHERE	CompanyKey = @CompanyKey 
		AND		(Active = 1 OR LaborBudgetKey = @LaborBudgetKey)
		Order By BudgetName

	RETURN 1
GO
