USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGetPLList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountGetPLList]
	@CompanyKey int
	,@UseCashBasisAccountType int = 0
AS

/*
|| When      Who Rel     What
|| 9/20/07   CRG 8.5     Created for Corporate P&L
|| 6/11/09   GHL 10.027  Added UseCashBasisAccountType to support cash basis accounting
*/

if @UseCashBasisAccountType = 0

	SELECT	GLAccountKey,
			AccountNumber,
			AccountName,
			ISNULL(AccountNumber, '') + ' - ' + ISNULL(AccountName, '') AS AccountNumberName,
			AccountType,
			ISNULL(ParentAccountKey, 0) as ParentAccountKey,
			DisplayOrder,
			DisplayLevel,
			Rollup,
			Active,
			Case When AccountType = 40 then 1
				When AccountType = 50 then 2
				When AccountType = 51 then 3
				When AccountType = 41 then 4
				When AccountType = 52 then 5 end as MinorGroup
	FROM	tGLAccount gl (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		AccountType in (40, 41, 50, 51, 52)
	ORDER BY MinorGroup, DisplayOrder
	
else

	SELECT	GLAccountKey,
			AccountNumber,
			AccountName,
			ISNULL(AccountNumber, '') + ' - ' + ISNULL(AccountName, '') AS AccountNumberName,
			AccountType,
			ISNULL(ParentAccountKey, 0) as ParentAccountKey,
			DisplayOrder,
			DisplayLevel,
			Rollup,
			Active,
			Case When AccountType = 40 then 1
				When AccountType = 50 then 2
				When AccountType = 51 then 3
				When AccountType = 41 then 4
				When AccountType = 52 then 5 end as MinorGroup
	FROM	vGLAccountCash gl (nolock)  -- get the account types from that view
	WHERE	CompanyKey = @CompanyKey
	AND		AccountType in (40, 41, 50, 51, 52)
	ORDER BY MinorGroup, DisplayOrder
GO
