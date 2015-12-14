USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTransactionGetList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTransactionGetList]

	(
		@GLAccountKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@CashBasis tinyint,
		@CashBasisLegacy int = 1
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/10/07   CRG 8.4.3   (8874) Added @CashBasis parameter to get the Transaction list from the new cash basis view: vTransactionCash
|| 5/1/09    GHL 10.024   Added CashBasisLegacy so that this sp can be used on gl/journal.aspx called from:
||                        - the old income statement or reports/acct_gl_pl_html.aspx in legacy mode
||                        - the GL listing or gl/GLAccount.aspx in real cash basis mode  
*/

	IF @CashBasis = 1
		IF @CashBasisLegacy = 1
			IF @StartDate IS NULL
				Select	*,
						PostingDate as TransactionDate, -- convert to TransactionDate for common sorts on grid 
						CASE
							WHEN AccountType in (10, 11, 12, 13, 14, 50, 51, 52) THEN Debit - Credit
							ELSE Credit - Debit 
						END AS Amount
				from	vTransactionCash (NOLOCK) 
				Where	GLAccountKey = @GLAccountKey
			ELSE
				Select	*,
						PostingDate as TransactionDate, -- convert to TransactionDate for common sorts on grid
						CASE
							WHEN AccountType in (10, 11, 12, 13, 14, 50, 51, 52) THEN Debit - Credit
							ELSE Credit - Debit 
						END AS Amount 
				from	vTransactionCash (NOLOCK) 
				Where	GLAccountKey = @GLAccountKey
				and		PostingDate >= @StartDate
				and		PostingDate <= @EndDate			
		ELSE
			IF @StartDate IS NULL
				Select	*,
						CASE
							WHEN AccountType in (10, 11, 12, 13, 14, 50, 51, 52) THEN Debit - Credit
							ELSE Credit - Debit 
						END AS Amount
				from	vTransactionCashBasis (NOLOCK) 
				Where	GLAccountKey = @GLAccountKey
			ELSE
				Select	*,
						CASE
							WHEN AccountType in (10, 11, 12, 13, 14, 50, 51, 52) THEN Debit - Credit
							ELSE Credit - Debit 
						END AS Amount 
				from	vTransactionCashBasis (NOLOCK) 
				Where	GLAccountKey = @GLAccountKey
				and		TransactionDate >= @StartDate
				and		TransactionDate <= @EndDate			

	ELSE
		if @StartDate is null
			Select	* 
			from	vTransaction (NOLOCK) 
			Where	GLAccountKey = @GLAccountKey
		else
			Select	* 
			from	vTransaction (NOLOCK) 
			Where	GLAccountKey = @GLAccountKey
			and		TransactionDate >= @StartDate
			and		TransactionDate <= @EndDate
GO
