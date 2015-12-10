USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricWorkingCapital]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricWorkingCapital]
		@CompanyKey int,
		@NbrPeriods int,
		@GLCompanyKey int,
		@UserKey int

AS --Encrypt

  /*
  || When     Who Rel       What
  || 09/17/12 RLB 10.5.6.0  (154424) Added CC account to liability pull
   */

declare @EndRangeDate datetime
declare @FromDate datetime
declare @ToDate datetime
declare @LiabilityAmtCredit decimal(24,4)
declare @LiabilityAmtDebit decimal(24,4)
declare @LiabilityAmt decimal(24,4)
declare @AssetAmtCredit decimal(24,4)
declare @AssetAmtDebit decimal(24,4)
declare @AssetAmt decimal(24,4)
declare @EquityAmt decimal(24,4)
declare @Periods int

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

create table #tMetric (MonthNum int null, MetricVal decimal(24,4))

select @EndRangeDate = cast(cast(datepart(mm,getdate()) as varchar(2)) + '/01/' + cast(datepart(yyyy,getdate()) as varchar(4)) as datetime)
select @Periods = @NbrPeriods * -1
select @FromDate = dateadd(mm,@Periods,@EndRangeDate)
select @ToDate = dateadd(mm,1,@FromDate)

while 1=1
	begin 
		if @ToDate > @EndRangeDate
			break
		
		--AR
		select @AssetAmtDebit = isnull(sum(isnull(Debit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType in (10,11,12)  -- Bank, Receivable, Current Asset Accounts
		and TransactionDate < @ToDate
		
		select @AssetAmtCredit = isnull(sum(isnull(Credit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType in (10,11,12)  -- Bank, Receivable, Current Asset Accounts
		and TransactionDate < @ToDate
		
		select @AssetAmt = @AssetAmtDebit - @AssetAmtCredit
		
		-- AP
		select @LiabilityAmtCredit = isnull(sum(isnull(Credit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType in (20,21,23)  -- Payable, Short Term Liabiblity Accounts
		and TransactionDate < @ToDate
		
		select @LiabilityAmtDebit = isnull(sum(isnull(Debit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType in (20,21,23)  -- Payable, Short Term Liabiblity Accounts
		and TransactionDate < @ToDate
		
		select @LiabilityAmt = @LiabilityAmtCredit - @LiabilityAmtDebit
		
		if @LiabilityAmt = 0 
			select @EquityAmt = 0
		else
			select @EquityAmt = round(@AssetAmt-@LiabilityAmt,0)
		
		insert #tMetric values (datepart(mm,@FromDate),@EquityAmt)
		
		select @FromDate = dateadd(mm,1,@FromDate)
		select @ToDate = dateadd(mm,1,@ToDate)
	end

-- return calculations in recordset
select * from #tMetric
GO
