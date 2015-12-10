USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricVulnerabilityToLoss]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricVulnerabilityToLoss]
	(
	@CompanyKey int
	,@CalcMode int -- 0 Billing, 1 AGI
	,@DateRangeIndex int
	,@StartDate datetime
	,@EndDate datetime
	,@GLCompanyKey int
	,@UserKey int
	)
AS
	SET NOCOUNT ON

  /*
  || When     Who Rel     What
  || 06/14/11 GHL 10.545  (113801) Creation for new Vulnerality To Loss option (AGI)
  || 08/08/12 MFT 10.558  Added @GLCompanyKey & @UserKey params and GL Company restrictions
  || 03/13/14 GHL 10.578  Using now vHTransaction
  || 03/04/14 GHL 10.5.7.8 Added conversion to home currency
  */

------------------------------------------------------------
--GL Company restrictions
DECLARE @RestrictToGLCompany tinyint
DECLARE @tGLCompanies table (GLCompanyKey int)
SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey

IF ISNULL(@GLCompanyKey, 0) > 0
	INSERT INTO @tGLCompanies VALUES(@GLCompanyKey)
ELSE
	BEGIN --No @GLCompanyKey passed in
		IF @RestrictToGLCompany = 0
			BEGIN --@RestrictToGLCompany = 0
			 	--All GLCompanyKeys + 0 to get NULLs
				INSERT INTO @tGLCompanies VALUES(0)
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tGLCompany (nolock)
					WHERE CompanyKey = @CompanyKey
			END --@RestrictToGLCompany = 0
		ELSE
			BEGIN --@RestrictToGLCompany = 1
				 --Only GLCompanyKeys @UserKey has access to
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tUserGLCompanyAccess (nolock)
					WHERE UserKey = @UserKey
			END --@RestrictToGLCompany = 1
	END --No @GLCompanyKey passed in
--GL Company restrictions
------------------------------------------------------------

create table #VulnerabilityToLoss(ClientKey int null, CustomerID VARCHAR(50) NULL, CompanyName VARCHAR(200) NULL
	, IncomeAmount MONEY NULL, TotalCompanyAmount MONEY NULL) 

if @CalcMode = 0
	begin
		-- By Billing
		if @DateRangeIndex > 0 
			insert #VulnerabilityToLoss (ClientKey, CustomerID, CompanyName, IncomeAmount, TotalCompanyAmount)
			
			SELECT i.ClientKey, c.CustomerID, c.CompanyName, SUM(i.TotalNonTaxAmount * isnull(i.ExchangeRate, 1)) , 0  
			FROM
				tInvoice i (nolock)
				INNER JOIN tCompany c (NOLOCK) ON i.ClientKey = c.CompanyKey
				INNER JOIN @tGLCompanies gl ON ISNULL(i.GLCompanyKey, 0) = gl.GLCompanyKey
			WHERE
				i.AdvanceBill = 0
				and i.CompanyKey = @CompanyKey
				AND i.InvoiceDate >= @StartDate and i.InvoiceDate <= @EndDate
			GROUP BY i.ClientKey, c.CustomerID, c.CompanyName
		else
			insert #VulnerabilityToLoss (ClientKey, CustomerID, CompanyName, IncomeAmount, TotalCompanyAmount)
			
			SELECT i.ClientKey, c.CustomerID, c.CompanyName, SUM(i.TotalNonTaxAmount * isnull(i.ExchangeRate, 1)) , 0
			FROM
				tInvoice i (nolock)
				INNER JOIN tCompany c (NOLOCK) ON i.ClientKey = c.CompanyKey
				INNER JOIN @tGLCompanies gl ON ISNULL(i.GLCompanyKey, 0) = gl.GLCompanyKey
			WHERE
				i.AdvanceBill = 0
				and i.CompanyKey = @CompanyKey
			GROUP BY i.ClientKey, c.CustomerID, c.CompanyName

			update #VulnerabilityToLoss set IncomeAmount = round(IncomeAmount, 2)
	end
else
	begin
		-- By AGI = Income - COGS - Expenses
		if @DateRangeIndex > 0
			begin
				insert #VulnerabilityToLoss (ClientKey, CustomerID, CompanyName, IncomeAmount, TotalCompanyAmount)
				
				select  t.ClientKey, c.CustomerID, c.CompanyName, sum(t.Credit - t.Debit), 0
				from
					vHTransaction t (nolock)
					inner join tGLAccount gla (nolock) on t.GLAccountKey = gla.GLAccountKey
					inner join tCompany c (nolock) on t.ClientKey = c.CompanyKey
					INNER JOIN @tGLCompanies gl ON ISNULL(t.GLCompanyKey, 0) = gl.GLCompanyKey
				where
					t.CompanyKey = @CompanyKey
					and   t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
					and   gla.AccountType = 40 -- Income
				group by t.ClientKey, c.CustomerID, c.CompanyName
				
				update #VulnerabilityToLoss
				set    #VulnerabilityToLoss.IncomeAmount = isnull(#VulnerabilityToLoss.IncomeAmount, 0)
					- isnull((
					select sum(t.Debit - t.Credit)
					from
						vHTransaction t (nolock)
						inner join tGLAccount gla (nolock) on t.GLAccountKey = gla.GLAccountKey
						INNER JOIN @tGLCompanies gl ON ISNULL(t.GLCompanyKey, 0) = gl.GLCompanyKey
					where t.CompanyKey = @CompanyKey
					and   t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
					and   gla.AccountType in ( 50, 51) -- COGS, Expense
					and   t.ClientKey = #VulnerabilityToLoss.ClientKey
					),0)
		end
	else
		begin
			insert #VulnerabilityToLoss (ClientKey, CustomerID, CompanyName, IncomeAmount, TotalCompanyAmount)
			
			select  t.ClientKey, c.CustomerID, c.CompanyName, sum(t.Credit - t.Debit), 0
			from
				vHTransaction t (nolock)
				inner join tGLAccount gla (nolock) on t.GLAccountKey = gla.GLAccountKey
				inner join tCompany c (nolock) on t.ClientKey = c.CompanyKey
				INNER JOIN @tGLCompanies gl ON ISNULL(t.GLCompanyKey, 0) = gl.GLCompanyKey
			where
				t.CompanyKey = @CompanyKey
				and   gla.AccountType = 40 -- Income
			group by t.ClientKey, c.CustomerID, c.CompanyName
			
			update #VulnerabilityToLoss
			set    #VulnerabilityToLoss.IncomeAmount = isnull(#VulnerabilityToLoss.IncomeAmount, 0)
				- isnull((
				select sum(t.Debit - t.Credit)
				from
					vHTransaction t (nolock)
					inner join tGLAccount gla (nolock) on t.GLAccountKey = gla.GLAccountKey
					INNER JOIN @tGLCompanies gl ON ISNULL(t.GLCompanyKey, 0) = gl.GLCompanyKey
				where t.CompanyKey = @CompanyKey
				and   gla.AccountType in ( 50, 51) -- COGS, Expense
				and   t.ClientKey = #VulnerabilityToLoss.ClientKey
				),0)
		end
	end

update #VulnerabilityToLoss
set    TotalCompanyAmount = (select sum(IncomeAmount) from #VulnerabilityToLoss)

select * from #VulnerabilityToLoss order by IncomeAmount desc

RETURN 1
GO
