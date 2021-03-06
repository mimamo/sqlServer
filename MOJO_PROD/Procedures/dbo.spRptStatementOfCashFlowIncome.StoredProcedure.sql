USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptStatementOfCashFlowIncome]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptStatementOfCashFlowIncome]
	(@CompanyKey int
	,@StartDate smalldatetime
	,@BalanceDate smalldatetime
	,@GLCompanyKey int -- -1 All, 0 NULL, >0 valid GLCompany	
	,@UserKey int = null
	,@oNetIncome money output
	,@oBeginCash money output
	,@oEndCash money output
	)

AS  -- Encrypt

/*
|| When      Who Rel     What
|| 10/18/07  CRG 8.5     Added GLCompanyKey parameter.
|| 02/10/09  GHL 10.018  (37631) Changed logic for GLCompany to match change in the UI
|| 08/16/11  GHL 10.546  (118913) Lifted ambiguity about GLCompanyKey
|| 04/12/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/06/14  GHL 10.576  Using now vHTransaction (Debit mapped to HDebit)
|| 09/26/14  GHL 10.584  (230656) Calling spRptStatementOfCashFlowIncomeCurrency for multi currency
*/

	SET NOCOUNT ON
	
Declare @RestrictToGLCompany int, @MultiCurrency int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	  ,@MultiCurrency = ISNULL(MultiCurrency, 0)
from tPreference (nolock) 
Where CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
      ,@MultiCurrency = isnull(@MultiCurrency, 0)

if @MultiCurrency = 1
begin 
	exec spRptStatementOfCashFlowIncomeCurrency @CompanyKey,@StartDate,@BalanceDate,@GLCompanyKey,@UserKey,@oNetIncome output,@oBeginCash output,@oEndCash output
	return 1
end

	declare  @NetIncome As money

	Select @NetIncome =
		(
		select ISNULL(Sum(Credit - Debit), 0) 
		from		vHTransaction t (nolock) 
		inner join	tGLAccount  gl (nolock)
		on			t.GLAccountKey = gl.GLAccountKey
		where		t.CompanyKey = @CompanyKey 
		and			AccountType > 33
		and			TransactionDate >= @StartDate
		and			TransactionDate <= @BalanceDate
		--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(t.GLCompanyKey, 0)) )
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey <> -1 AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)
		)

	declare  @BeginCash As money
			,@EndCash As money 
	
	-- Cash at beginning of period
	Select @BeginCash = Sum(Debit - Credit) 
	from		vHTransaction (nolock) 
	inner join	tGLAccount (nolock) on vHTransaction.GLAccountKey = tGLAccount.GLAccountKey
	Where		tGLAccount.CompanyKey = @CompanyKey 
	and			AccountType = 10  -- Bank
	and			TransactionDate < @StartDate 
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(tTransaction.GLCompanyKey, 0)) 
	
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND vHTransaction.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey <> -1 AND ISNULL(vHTransaction.GLCompanyKey, 0) = @GLCompanyKey)
			)



	-- Cash at end of period
	Select @EndCash = Sum(Debit - Credit) 
	from		vHTransaction (nolock) 
	inner join	tGLAccount (nolock) on vHTransaction.GLAccountKey = tGLAccount.GLAccountKey
	Where		tGLAccount.CompanyKey = @CompanyKey 
	and			AccountType = 10  -- Bank
	and			TransactionDate <= @BalanceDate
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(tTransaction.GLCompanyKey, 0)) )
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND vHTransaction.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey <> -1 AND ISNULL(vHTransaction.GLCompanyKey, 0) = @GLCompanyKey)
			)

	Select	@oNetIncome = ISNULL(@NetIncome, 0)
			,@oBeginCash = ISNULL(@BeginCash, 0)
			,@oEndCash = ISNULL(@EndCash, 0)
	
	RETURN
GO
