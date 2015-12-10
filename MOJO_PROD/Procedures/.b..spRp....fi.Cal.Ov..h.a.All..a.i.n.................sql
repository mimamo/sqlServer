USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitCalcOverheadAllocation]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitCalcOverheadAllocation]
	@CompanyKey int,
	@GLCompanyKey int,
	@OfficeKey int,
	@ClassKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@AllocateBy smallint,
	@TotalOverhead50 money OUTPUT,
	@TotalOverhead51 money OUTPUT,
	@TotalOverhead52 money OUTPUT,
	@TotalAGI money OUTPUT,
	@TotalHours decimal(24,4) OUTPUT,
	@TotalLaborCost money OUTPUT,
	@TotalBillings money OUTPUT

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/16/07  CRG 8.5     Created to be used by the Profitability Reports to calculate Overhead Allocation
|| 11/12/07  GWG 8.5     Modified to not include income in the overhead calculation
|| 11/20/07  CRG 8.5     Modified to use the new #tTime temp table to improve performance.
|| 05/21/13  GHL 10.568  (176115) Added @ClassKey param to filter out by class
|| 01/02/14  GHL 10.575  Reading now vHTransaction for home currency amounts
*/

	--overhead allocation, all overhead clients or no client transactions
	select @TotalOverhead50 = 
		isnull((
			select sum(Debit - Credit)
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where t.CompanyKey = @CompanyKey
			and gl.CompanyKey = @CompanyKey
			and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
			and gl.AccountType = 50
			and (isnull(t.Overhead, 0) = 1 or t.ClientKey is null)
			and (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
			and (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			and (@ClassKey is null or ISNULL(t.ClassKey, 0) = @ClassKey)
		), 0)
		
	select @TotalOverhead51 = 
		isnull((
			select sum(Debit - Credit)
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where t.CompanyKey = @CompanyKey
			and gl.CompanyKey = @CompanyKey
			and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
			and gl.AccountType = 51
			and (isnull(t.Overhead, 0) = 1 or t.ClientKey is null)
			and (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
			and (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			and (@ClassKey is null or ISNULL(t.ClassKey, 0) = @ClassKey)
		), 0)
		
	select @TotalOverhead52 = 
		isnull((
			select sum(Debit - Credit)
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where t.CompanyKey = @CompanyKey
			and gl.CompanyKey = @CompanyKey
			and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
			and gl.AccountType = 52
			and (isnull(t.Overhead, 0) = 1 or t.ClientKey is null)
			and (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
			and (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			and (@ClassKey is null or ISNULL(t.ClassKey, 0) = @ClassKey)
		), 0)
	
	--Overhead Allocations
	--by labor (#tTime must be created before calling this SP)
	IF @AllocateBy IN (2, 3)
		SELECT	@TotalHours = ISNULL(SUM(ActualHours), 0),
				@TotalLaborCost = ISNULL(SUM(Cost), 0)
		FROM	#tTime
	
	--by billings			
	if @AllocateBy = 4
		begin 
			select @TotalBillings =
				isnull((
					select isnull(sum(Credit - Debit), 0)
					from vHTransaction t (nolock) 
					inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
					where t.CompanyKey = @CompanyKey
					and gl.CompanyKey = @CompanyKey
					and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
					and gl.AccountType = 40
					and isnull(t.Overhead, 0) = 0
					and t.ClientKey is not null
					and (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
					and (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
					and (@ClassKey is null or ISNULL(t.ClassKey, 0) = @ClassKey)
		
				), 0)
		end
GO
