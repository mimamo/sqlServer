USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLBudgetGetList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLBudgetGetList]
	@CompanyKey int,
	@ActiveOnly tinyint = 0
AS --Encrypt

/*
|| When      Who Rel     What
|| 1/31/08   CRG 1.0.0.0 Added sorting by Budgetname
|| 3/05/09   RLB 10.0.2.0 Filtering just Active GL Budgets issue (40443)
|| 3/12/09	 CRG 10.0.2.0 Added the ActiveOnly parameter so it'll still show inactive projects on the Budget List
|| 11/27/12  GHL 10.5.6.2 Added Short Name for drop downs
*/
	SELECT	*
	       ,substring(BudgetName, 1, 30) as DDBudgetName -- Short Name for Drop Downs
	FROM	tGLBudget (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		(Active = 1 OR @ActiveOnly = 0)
	ORDER BY BudgetName
		
	RETURN 1
GO
