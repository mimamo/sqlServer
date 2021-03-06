USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGetWithTranInfo]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountGetWithTranInfo]

	(
		@GLAccountKey int,
		@StartDate smalldatetime,
		@CashBasis int = 0
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/1/09    GHL 10.024   Added CashBasis so that this sp can be used on gl/journal.aspx in accrual or cash basis mode
|| 7/8/09    GHL 10.503   Added support of AccountTypeCash
*/

Declare @AccountType smallint
Declare @AccountTypeCash smallint
Declare @BeginningBal money

Select @AccountType = AccountType
       ,@AccountTypeCash = AccountTypeCash 
from tGLAccount (nolock) 
Where GLAccountKey = @GLAccountKey


if @CashBasis = 0
begin
    -- Accrual Basis
	if @StartDate is null
		Select @BeginningBal = 0
	else
		if @AccountType >= 40
			Select @BeginningBal = 0
		else
			if @AccountType IN (10 , 11 , 12 , 13 , 14)
				Select @BeginningBal = Sum(Debit - Credit) from tTransaction (nolock) Where GLAccountKey = @GLAccountKey and TransactionDate < @StartDate
			else
				Select @BeginningBal = Sum(Credit - Debit) from tTransaction (nolock) Where GLAccountKey = @GLAccountKey and TransactionDate < @StartDate
end
else
begin
	-- Cash Basis
    SELECT @AccountType = ISNULL(@AccountTypeCash, @AccountType)

	if @StartDate is null
		Select @BeginningBal = 0
	else
		if @AccountType >= 40
			Select @BeginningBal = 0
		else
			if @AccountType IN (10 , 11 , 12 , 13 , 14)
				Select @BeginningBal = Sum(Debit - Credit) from tCashTransaction (nolock) Where GLAccountKey = @GLAccountKey and TransactionDate < @StartDate
			else
				Select @BeginningBal = Sum(Credit - Debit) from tCashTransaction (nolock) Where GLAccountKey = @GLAccountKey and TransactionDate < @StartDate
end
			
Select
	GLAccountKey
	,AccountNumber
	,AccountName
	,AccountType
	,ISNULL(@BeginningBal, 0) as BeginningBal
from
	tGLAccount (nolock)
Where
	GLAccountKey = @GLAccountKey
GO
