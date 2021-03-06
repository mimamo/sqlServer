USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptStatementOfCashFlowAdjustments]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptStatementOfCashFlowAdjustments]
	(@CompanyKey int
	,@StartDate smalldatetime
	,@BalanceDate smalldatetime
	,@GLCompanyKey int -- -1 All, 0 NULL, >0 valid GLCompany
	,@UserKey int = null
)
AS  -- Encrypt

/*
|| When      Who Rel     What
|| 10/18/07  CRG 8.5     Added GLCompanyKey parameter.
|| 07/1/07   GWG 10.0.0.4 Moved current liability to operating activities
|| 02/10/09  GHL 10.018  (37631) Changed logic for GLCompany to match change in the UI
|| 10/13/11  GHL 10.459  Added support of credit card charges (liability) AccountType = 23
|| 04/12/12  GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 01/06/14  GHL 10.576  Using now vHTransaction (Debit mapped to HDebit)
|| 09/26/14  GHL 10.584  (230656) Calling spRptStatementOfCashFlowAdjustmentsCurrency for multi currency
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
	exec spRptStatementOfCashFlowAdjustmentsCurrency @CompanyKey,@StartDate,@BalanceDate,@GLCompanyKey,@UserKey
	return 1
end

	Create table #GLTran
	(
		CompanyKey int null,
		GLAccountKey int null,
		TransactionDate smalldatetime null,
		Debit money null,
		Credit money null
	)
	
	Insert Into #GLTran (GLAccountKey, TransactionDate, Debit, Credit)
	Select	GLAccountKey, TransactionDate, Debit, Credit 
	From	vHTransaction (nolock) 
	Where	CompanyKey = @CompanyKey
	And		TransactionDate >= @StartDate
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(GLCompanyKey, 0)) )
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey <> -1 AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)
		

	Select 
		GLAccountKey
		,AccountNumber
		,AccountName
		,ISNULL(ParentAccountKey, 0) as ParentAccountKey
		,DisplayOrder
		,DisplayLevel
		,Rollup
		,Case -- 1 Operating activity, 2 investing, 3 financial
			When AccountType = 11 then 1
			When AccountType = 12 then 1
			When AccountType = 13 then 2
			When AccountType = 14 then 2
			When AccountType = 20 then 1
			When AccountType = 21 then 1 -- Current liability
			When AccountType = 22 then 3 -- Long term liability
			When AccountType = 23 then 3 -- Credit Card 
			When AccountType = 30 then 3
			When AccountType = 31 then 3
			When AccountType = 32 then 3			 
		 end as MajorGroup
		,ISNULL((Select Sum(Credit - Debit) from #GLTran t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				and		TransactionDate >= @StartDate
				and		TransactionDate <= @BalanceDate), 0)
			As PeriodAmount
		,Cast(0 as Money) as PeriodAmountRollup
	From
		tGLAccount gl (nolock)
	Where
		CompanyKey = @CompanyKey 
	and AccountType > 10 
	and AccountType < 33 
	Order By MajorGroup, DisplayOrder
	
	RETURN
GO
