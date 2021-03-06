USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricCurrentRatio]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricCurrentRatio]
	@CompanyKey int,
	@NbrPeriods int,
	@GLCompanyKey int,
	@UserKey int

AS --Encrypt

  /*
  || When     Who Rel       What
  || 03/05/08 QMD WMJ 1.0   Modified for initial Release of WMJ
  || 07/31/12 MFT 10.5.5.8  Added @GLCompanyKey & @UserKey params and GL Company restrictions
  || 09/17/12 RLB 10.5.6.0  (154424) Added CC account to liability pull
  || 03/13/14 GHL 10.5.7.8  Using now vHTransaction
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
declare @CurrentRatioAmt decimal(24,4)
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

create table #tMetric (MonthNum int null, MetricVal decimal(9,2))

select @EndRangeDate = cast(cast(datepart(mm,getdate()) as varchar(2)) + '/01/' + cast(datepart(yyyy,getdate()) as varchar(4)) as datetime)
select @Periods = @NbrPeriods * -1
select @FromDate = dateadd(mm,@Periods,@EndRangeDate)
select @ToDate = dateadd(mm,1,@FromDate)
	
while 1=1
	begin 
		if @ToDate > @EndRangeDate
			break
		
		--AR debit
		select @AssetAmtDebit = isnull(sum(isnull(Debit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType in (10,11,12)  -- Bank, Receivable, Current Asset Accounts
		and TransactionDate < @ToDate
		
		--AR credit
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
			select @CurrentRatioAmt = 0
		else
			select @CurrentRatioAmt = round(@AssetAmt/@LiabilityAmt,2)
		
		insert #tMetric values (datepart(mm,@FromDate),@CurrentRatioAmt)
		
		select @FromDate = dateadd(mm,1,@FromDate)
		select @ToDate = dateadd(mm,1,@ToDate)
	end
	
-- return calculations in recordset
select *, Target = 2 from #tMetric
GO
