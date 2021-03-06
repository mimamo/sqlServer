USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitByClientMulti]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitByClientMulti]
	 @CompanyKey int
	,@GLCompanyKey int
	,@OfficeKey int
	,@ClassKey int
	,@StartDate smalldatetime
	,@EndDate smalldatetime
	,@AllocateBy smallint
	,@IncludeOther tinyint
	,@UserKey int = null
	
AS --Encrypt

  /*
  || When     Who Rel     What
  || 10/17/07 RTC 8.5	    Creation for 85 profit analysis
  || 11/01/07 GHL 8.5     Added error checking
  || 11/11/07 GWG 8.5     Modified for the new layout
  || 11/16/07 CRG 8.5     Modified to make queries more efficient
  || 11/27/07 GHL 8.5     Added WITH for compliance with SQL Server 2005
  || 11/28/07 CRG 8.5     Added Overhead columns for use with the Drilldown
  || 02/08/08 CRG 8.5.0.4 (20497) Restrictions on only projects that have transactions posted 
  ||                      was reinstated.
  || 09/16/08 GHL 10.009  (32478) Time entry regardless of GL transactions must be in
  || 02/10/09 RTC 10.018  Removed query hint for better performance
  || 03/06/09 GHL 10.020  (48226 + 48250) Removed the restriction on projects with posted transactions
  ||                       because now users compare inside labor cost with various allocation methods 
  || 04/27/09 GWG 10.023   Always getting time from raw tables so that labor cost and inside costs always get applied
  || 07/31/09 GHL 10.506  (57578) Changed the way parent clients and clients are displayed
  ||                      See comments below
  || 12/06/09 GHL 10.514  (69687) Added clients with misc costs and ER activity to help with InsideExpenseCost 
  || 03/29/11 RLB 10.542  (107171) Added Account Manager to report columns  
  || 03/07/12 GHL 10.554  (132698) Added Client ID + Name
  || 04/10/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
  || 09/12/12 MFT 10.560  Added ParentClientDivision
  || 12/13/12 GHL 10.563  (162438) Added Class Param
  || 05/21/13 GHL 10.568  (176115) Added Class param when calculating overhead allocation
  || 07/17/13 RLB 10.570  (183577) Added Company Owner from ContactOwnerKey
  || 09/27/13 GHL 10.572  (188701) In the NO CLIENT row, remove the overhead transactions
  || 01/02/14 GHL 10.575  Reading now vHTransaction for home currency amount
  || 03/16/15 RLB 10.590  (239144) Added option to group by Company Type
  */

	-- Check # of records  
/*
	DECLARE @RecMax INT
	SELECT @RecMax = 1000 -- change as desired, must be >= 100
	
	IF (SELECT COUNT(*) FROM #tRpt) > @RecMax
		RETURN -1 * @RecMax
*/		
	declare @TotalRevenue money
	declare @TotalOutsideCosts money
	declare @TotalOverhead50 money
	declare @TotalOverhead51 money
	declare @TotalOverhead52 money
	declare @TotalAGI money
	declare @TotalHours decimal (24,4)
	declare @TotalLaborCost money
	declare @TotalBillings money

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


	if @IncludeOther = 1
	BEGIN
		IF EXISTS(
				SELECT TOP 1 NULL
				From tTransaction t (nolock)
				inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
				--Where (isnull(t.Overhead, 0) = 1 or t.ClientKey is null)
				Where t.ClientKey is null -- 188701
				and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
				and (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
				and (@ClassKey is null or ISNULL(t.ClassKey, 0) = @ClassKey)
				--and (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)

				AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				)

				and gl.AccountType in (40, 41) 
				and	t.CompanyKey = @CompanyKey)
			INSERT	#tRpt (ClientKey, Client)
			VALUES (-1, '- NONE - No Client Specified')		
	END

	
		-- Added 09/05/08 Time Entry regardless of GL transactions must be in
		Insert #tRpt(ClientKey)
		Select Distinct p.ClientKey
		From tTime t (nolock) 
			inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
			INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
			INNER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
			WHERE	ts.CompanyKey = @CompanyKey
				AND		t.WorkDate >= @StartDate AND t.WorkDate <= @EndDate
				AND		ts.Status = 4
				AND		ISNULL(c.Overhead, 0) = 0
				AND		(@OfficeKey IS NULL or ISNULL(p.OfficeKey, 0) = @OfficeKey)
				and     (@ClassKey is null or ISNULL(p.ClassKey, 0) = @ClassKey)
				--AND		(@GLCompanyKey IS NULL or ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
				
				AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
				)
				
				and p.ClientKey not in (select ClientKey from #tRpt)
	
		-- Added 12/06/09 Needed for InsideExpenseCost
		Insert #tRpt(ClientKey)
		Select Distinct p.ClientKey
		From tMiscCost mc (nolock) 
			INNER JOIN tProject p (nolock) ON mc.ProjectKey = p.ProjectKey
			INNER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
			WHERE	p.CompanyKey = @CompanyKey
				AND	mc.ExpenseDate >= @StartDate AND mc.ExpenseDate <= @EndDate
				AND	ISNULL(c.Overhead, 0) = 0
				AND	(@OfficeKey IS NULL or ISNULL(p.OfficeKey, 0) = @OfficeKey)
				and (@ClassKey is null or ISNULL(p.ClassKey, 0) = @ClassKey)
				--AND	(@GLCompanyKey IS NULL or ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
				
				AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
				)

				and p.ClientKey not in (select ClientKey from #tRpt)

		-- Added 12/06/09 Needed for InsideExpenseCost
		Insert #tRpt(ClientKey)
		Select Distinct p.ClientKey
		From tExpenseReceipt er (nolock) 
			INNER JOIN tProject p (nolock) ON er.ProjectKey = p.ProjectKey
			inner join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
			INNER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
			WHERE	p.CompanyKey = @CompanyKey
				and ee.Status = 4
				and er.VoucherDetailKey is null --not converted to an invoice yet
				AND	er.ExpenseDate >= @StartDate AND er.ExpenseDate <= @EndDate
				AND	ISNULL(c.Overhead, 0) = 0
				AND	(@OfficeKey IS NULL or ISNULL(p.OfficeKey, 0) = @OfficeKey)
				and (@ClassKey is null or ISNULL(p.ClassKey, 0) = @ClassKey)
				--AND	(@GLCompanyKey IS NULL or ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
				AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
				)
				and p.ClientKey not in (select ClientKey from #tRpt)


		CREATE TABLE #tTime
			(ClientKey int null,
			ActualHours decimal(24,4) null,
			Cost money null)
		
		/*	
		INSERT	#tTime
		SELECT	p.ClientKey,
				ISNULL(SUM(ISNULL(t.ActualHours, 0)), 0),
				ISNULL(SUM(ISNULL(ActualHours, 0) * ISNULL(CostRate,0)), 0)
		FROM	tTime t WITH (index=IX_tTime_2, nolock) 
		INNER JOIN tTimeSheet ts (nolock) ON t.TimeSheetKey = ts.TimeSheetKey
		INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
		INNER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
--This inner join has been added for 20497
		inner join (Select Distinct ProjectKey From tTransaction (nolock) 
				inner join tGLAccount on tTransaction.GLAccountKey = tGLAccount.GLAccountKey
				Where TransactionDate >= @StartDate and TransactionDate <= @EndDate
						and tGLAccount.AccountType in (40, 41, 50, 51, 52)
						and (@OfficeKey is null or ISNULL(tTransaction.OfficeKey, 0) = @OfficeKey)
						and (@GLCompanyKey is null or ISNULL(tTransaction.GLCompanyKey, 0) = @GLCompanyKey)
						and tTransaction.CompanyKey = @CompanyKey) as pKeys on p.ProjectKey = pKeys.ProjectKey
		WHERE	ts.CompanyKey = @CompanyKey
		AND		t.WorkDate >= @StartDate AND t.WorkDate <= @EndDate
		AND		ts.Status = 4
		AND		ISNULL(c.Overhead, 0) = 0
		AND		(@OfficeKey IS NULL or ISNULL(p.OfficeKey, 0) = @OfficeKey)
		AND		(@GLCompanyKey IS NULL or ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
		GROUP BY p.ClientKey
		*/
		
		-- Modified 09/05/08, no joins with tTransaction but #tRpt	
		INSERT	#tTime
		SELECT	p.ClientKey,
				ISNULL(SUM(ISNULL(t.ActualHours, 0)), 0),
				ISNULL(SUM(ISNULL(ActualHours, 0) * ISNULL(HCostRate,0)), 0)
		FROM	tTime t (nolock) 
		INNER JOIN tTimeSheet ts (nolock) ON t.TimeSheetKey = ts.TimeSheetKey
		INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
		INNER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
         INNER JOIN (SELECT DISTINCT  ClientKey FROM #tRpt)
				as pKeys on p.ClientKey = pKeys.ClientKey
		WHERE	ts.CompanyKey = @CompanyKey
		AND		t.WorkDate >= @StartDate AND t.WorkDate <= @EndDate
		AND		ts.Status = 4
		AND		ISNULL(c.Overhead, 0) = 0
		AND		(@OfficeKey IS NULL or ISNULL(p.OfficeKey, 0) = @OfficeKey)
		and     (@ClassKey is null or ISNULL(p.ClassKey, 0) = @ClassKey)
		--AND		(@GLCompanyKey IS NULL or ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
		
		AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
				)
		GROUP BY p.ClientKey
		
		INSERT	#tRpt (ClientKey)
		SELECT	ClientKey
		FROM	#tTime
		WHERE	ClientKey NOT IN (SELECT ClientKey FROM #tRpt)

	
	--init numeric columns
	update #tRpt
	set  Revenue = 0 -- Revenue for the client. specific to type 40
		,RevenuePercent = 0 -- percentage of total revenue
		,OutsideCostsDirect = 0 -- 
		,OutsideCostsAllocated = 0 
		,OutsideCosts = 0
		,AdjustedGrossIncome = 0
		,LaborHours = 0
		,InsideCostsDirect = 0
		,InsideLaborCost = 0
		,InsideExpenseCost = 0
		,TotalInsideCosts = 0
		,OverheadAllocation = 0
		,NetProfit = 0
		,NetProfitPercentAGI = 0
		,InvoiceAmount = 0
		,OutsideCostsPercentRevenue = 0
		,AdjustedGrossIncomePercentRevenue = 0
		,InsideLaborCostPercentRevenue = 0
		,InsideExpenseCostPercentRevenue = 0
		,TotalInsideCostsPercentRevenue = 0
		,OverheadAllocationPercentRevenue = 0
		,OtherIncomeDirect = 0
		,OtherCostsDirect = 0
		,OtherCostsAllocated = 0
		,OtherCosts = 0
		,NetProfitPercentRevenue = 0
		,InsideLaborCostPercentAGI = 0
		,InsideExpenseCostPercentAGI = 0
		,TotalInsideCostsPercentAGI = 0
		,OverheadAllocationPercentAGI = 0
		,OrdinaryIncome = 0
		,OrdinaryIncomePercentRevenue = 0
		,OrdinaryIncomePercentAGI = 0
		,TotalOverhead = 0
		,TotalAGI = 0
		,TotalHours = 0
		,TotalLaborCost = 0
		,TotalInvoice = 0
		,AGIPercent = 0
		,HoursPercent = 0
		,LaborCostPercent = 0
		,InvoicePercent = 0
   
	--update client related columns	
	/*
	(57578) This statement will organize the clients as follows:
	
	No Parent
		Client 1
		Client 2
	Parent Client 1
		Parent Client 1
		Client 3
		Client 4	
	
	*/
	update #tRpt
	set  ParentClientKey = cl.ParentCompanyKey 

		,ParentClient = 
		case 
			when cl.ParentCompany = 1 
			then ISNULL(cl.CustomerID + '-', '') + ISNULL(cl.CompanyName, '')
			else ISNULL(pcl.CustomerID + '-', '') + ISNULL(pcl.CompanyName, '') 
		end
	
		,Client = ISNULL(cl.CustomerID + '-', '') + ISNULL(cl.CompanyName, '')
		,ClientID = cl.CustomerID
		,ClientName = cl.CompanyName
		,ParentClientDivision = cd.DivisionName
		,CompanyTypeKey = cl.CompanyTypeKey
		,CompanyTypeName = ct.CompanyTypeName
			
	from tCompany cl (nolock) 
	left outer join tCompany pcl (nolock) on cl.ParentCompanyKey = pcl.CompanyKey
	left outer join tClientDivision cd (nolock) on cl.ParentCompanyDivisionKey = cd.ClientDivisionKey
	left outer join tCompanyType ct (nolock) on cl.CompanyTypeKey = ct.CompanyTypeKey
	where #tRpt.ClientKey = cl.CompanyKey
	
	update #tRpt
	set ClientID = '- NONE'
	    ,ClientName = '- No Client Specified'
	    ,CompanyTypeName = '- NONE'
	where Client = '- NONE - No Client Specified'

	/*
	This statement would organize the clients as follows:
	
	No Parent
		Client 1
		Client 2
		Parent Client 1
	Parent Client 1
		Client 3
		Client 4	

	update #tRpt
	set  ParentClientKey = pcl.CompanyKey
		,ParentClient = ISNULL(pcl.CustomerID, '') + '-' + ISNULL(pcl.CompanyName, '')
		,Client = ISNULL(cl.CustomerID, '') + '-' + ISNULL(cl.CompanyName, '')
	from tCompany cl (nolock) 
	left outer join tCompany pcl (nolock) on cl.ParentCompanyKey = pcl.CompanyKey
	where #tRpt.ClientKey = cl.CompanyKey
	*/
	
	--update Account Manager related columns
	update #tRpt
	set AccountManagerKey = c.AccountManagerKey
	from tCompany c (nolock) 
	where #tRpt.ClientKey = c.CompanyKey

	update #tRpt
	set AccountManager = u.FirstName + ' ' + u.LastName
	from tUser u (nolock) 
	where #tRpt.AccountManagerKey = u.UserKey

	update #tRpt
	set AccountManager = 'No Account Manager'
	where #tRpt.AccountManagerKey is null

	--update Company Owner related columns
	update #tRpt
	set ContactOwnerKey = c.ContactOwnerKey
	from tCompany c (nolock) 
	where #tRpt.ClientKey = c.CompanyKey

	update #tRpt
	set CompanyOwner = u.FirstName + ' ' + u.LastName
	from tUser u (nolock) 
	where #tRpt.ContactOwnerKey = u.UserKey

	update #tRpt
	set CompanyOwner = 'No Company Owner'
	where #tRpt.ContactOwnerKey is null

	--update GLCompany related columns
	update #tRpt
	set GLCompanyName = 'No Company'
	where GLCompanyKey is null
	
	update #tRpt
	set GLCompanyName = glc.GLCompanyName
	from tGLCompany glc (nolock) 
	where #tRpt.GLCompanyKey = glc.CompanyKey

	--update Office related columns
	update #tRpt
	set OfficeName = 'No Office'
	where #tRpt.OfficeKey is null
	
	update #tRpt
	set OfficeName = o.OfficeName
	from tOffice o (nolock) 
	where #tRpt.OfficeKey = o.OfficeKey
	
	--revenue		
	update #tRpt
	set Revenue = ISNULL(tmp.Amount, 0)
	from	(select sum(Credit - Debit) as Amount, t.ClientKey
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
			and   (@ClassKey is null or ISNULL(t.ClassKey, 0) = @ClassKey)
			--and (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				)
			and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
			and gl.AccountType = 40
			and isnull(t.Overhead, 0) = 0
			and t.ClientKey is not null
			group by t.ClientKey) as tmp
	where	#tRpt.ClientKey = tmp.ClientKey
		
	-- update the no client row
	if @IncludeOther = 1
	BEGIN
		update #tRpt
		set Revenue = ISNULL(tmp.Amount, 0)
		from	(select sum(Credit - Debit) as Amount
				from vHTransaction t (nolock) 
				inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
				where t.CompanyKey = @CompanyKey
				and (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
				and (@ClassKey is null or ISNULL(t.ClassKey, 0) = @ClassKey)
				--and (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				)
				and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
				and gl.AccountType = 40
				--and (isnull(t.Overhead, 0) = 1 or t.ClientKey is null)
				and t.ClientKey is null -- 188701
				) as tmp
		Where	#tRpt.ClientKey = -1
	END
		
	--OtherIncomeDirect		
	update #tRpt
	set OtherIncomeDirect = ISNULL(tmp.Amount, 0)
	from	(select sum(Credit - Debit) as Amount, t.ClientKey
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
			and (@ClassKey is null or ISNULL(t.ClassKey, 0) = @ClassKey)
			--and (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				)
				and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
			and gl.AccountType = 41
			and isnull(t.Overhead, 0) = 0
			and t.ClientKey is not null
			group by t.ClientKey) as tmp
	where	#tRpt.ClientKey = tmp.ClientKey
		
	-- update the no client row
	if @IncludeOther = 1
	BEGIN
		update #tRpt
		set OtherIncomeDirect = ISNULL(tmp.Amount, 0)
		from	(select sum(Credit - Debit) as Amount
				from vHTransaction t (nolock) 
				inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
				where t.CompanyKey = @CompanyKey
				and (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
				and (@ClassKey is null or ISNULL(t.ClassKey, 0) = @ClassKey)
				--and (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				)
				and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
				and gl.AccountType = 41
				--and (isnull(t.Overhead, 0) = 1 or t.ClientKey is null)
				and t.ClientKey is null -- 188701
				) as tmp
		Where #tRpt.ClientKey = -1
	END
		
	--Direct Costs
	update #tRpt
	set OutsideCostsDirect = ISNULL(tmp.Amount, 0)
	from	(select sum(Debit - Credit) as Amount, t.ClientKey
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
			and (@ClassKey is null or ISNULL(t.ClassKey, 0) = @ClassKey)
			--and (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				)
			and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
			and gl.AccountType = 50
			and isnull(t.Overhead, 0) = 0
			and t.ClientKey is not null
			group by t.ClientKey) as tmp
	where	#tRpt.ClientKey = tmp.ClientKey
	
	update #tRpt
	set InsideCostsDirect = ISNULL(tmp.Amount, 0)
	from	(select sum(Debit - Credit) as Amount, t.ClientKey
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
			and (@ClassKey is null or ISNULL(t.ClassKey, 0) = @ClassKey)
			--and (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				)
			and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
			and gl.AccountType = 51
			and isnull(t.Overhead, 0) = 0
			and t.ClientKey is not null
			group by t.ClientKey) as tmp
	where	#tRpt.ClientKey = tmp.ClientKey

	update #tRpt
	set OtherCostsDirect = ISNULL(tmp.Amount, 0)
	from	(select sum(Debit - Credit) as Amount, t.ClientKey
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
			and (@ClassKey is null or ISNULL(t.ClassKey, 0) = @ClassKey)
			--and (@GLCompanyKey is null or ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
				)
			and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
			and gl.AccountType = 52
			and isnull(t.Overhead, 0) = 0
			and t.ClientKey is not null
			group by t.ClientKey) as tmp
	where	#tRpt.ClientKey = tmp.ClientKey

	--labor hours

	UPDATE	#tRpt
	SET		LaborHours = tmp.ActualHours,
			InsideLaborCost = tmp.Cost
	FROM	#tTime tmp
	WHERE	#tRpt.ClientKey = tmp.ClientKey

    
    --inside expenses
	update	#tRpt
	set		InsideExpenseCost = ISNULL(tmp1.Amount, 0) + ISNULL(tmp2.Amount, 0)
	from	#tRpt
	left join (select sum( round(isnull(TotalCost,0) * m.ExchangeRate, 2) ) AS Amount, p.ClientKey
			from tMiscCost m (nolock)
			inner join tProject p (nolock) on m.ProjectKey = p.ProjectKey
--This inner join has been uncommented for 20497
/*
			inner join (Select Distinct ProjectKey From tTransaction (nolock) 
				inner join tGLAccount on tTransaction.GLAccountKey = tGLAccount.GLAccountKey
				Where TransactionDate >= @StartDate and TransactionDate <= @EndDate
					and tGLAccount.AccountType in (40, 41, 50, 51, 52)
					and (@OfficeKey is null or ISNULL(tTransaction.OfficeKey, 0) = @OfficeKey)
					and (@GLCompanyKey is null or ISNULL(tTransaction.GLCompanyKey, 0) = @GLCompanyKey)
					and tTransaction.CompanyKey = @CompanyKey) as pKeys on p.ProjectKey = pKeys.ProjectKey
*/					
			and (@OfficeKey is null or ISNULL(p.OfficeKey, 0) = @OfficeKey)
			and (@ClassKey is null or ISNULL(p.ClassKey, 0) = @ClassKey)
			--and (@GLCompanyKey is null or ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
				)
			and m.ExpenseDate >= @StartDate and m.ExpenseDate <= @EndDate
			and	p.ClientKey in (select distinct ClientKey from #tRpt) --No need to sum up for all clients
			group by p.ClientKey) as tmp1 ON #tRpt.ClientKey = tmp1.ClientKey
	left join (select sum(round(isnull(ActualCost,0)  * ee.ExchangeRate, 2)) AS Amount, p.ClientKey
			from tExpenseReceipt e (nolock) 
			inner join tExpenseEnvelope ee (nolock) on e.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
			inner join tProject p (nolock) on e.ProjectKey = p.ProjectKey
--This inner join has been uncommented for 20497
/*
			inner join (Select Distinct ProjectKey From tTransaction (nolock) 
				inner join tGLAccount on tTransaction.GLAccountKey = tGLAccount.GLAccountKey
				Where TransactionDate >= @StartDate and TransactionDate <= @EndDate
					and tGLAccount.AccountType in (40, 41, 50, 51, 52)
					and (@OfficeKey is null or ISNULL(tTransaction.OfficeKey, 0) = @OfficeKey)
					and (@GLCompanyKey is null or ISNULL(tTransaction.GLCompanyKey, 0) = @GLCompanyKey)
					and tTransaction.CompanyKey = @CompanyKey) as pKeys on p.ProjectKey = pKeys.ProjectKey
*/					
			and (@OfficeKey is null or ISNULL(p.OfficeKey, 0) = @OfficeKey)
			and (@ClassKey is null or ISNULL(p.ClassKey, 0) = @ClassKey)
			--and (@GLCompanyKey is null or ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			AND     (
				-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
				--case when @GLCompanyKey = X or Blank(0)
				 OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
				)
			and e.ExpenseDate >= @StartDate and e.ExpenseDate <= @EndDate
			and ee.Status = 4
			and e.VoucherDetailKey is null --not converted to an invoice yet
			and	p.ClientKey in (select distinct ClientKey from #tRpt) --No need to sum up for all clients
			group by p.ClientKey) as tmp2 ON #tRpt.ClientKey = tmp2.ClientKey
	
	--Overhead Allocations
	exec spRptProfitCalcOverheadAllocation 
		 @CompanyKey
		,@GLCompanyKey
		,@OfficeKey
		,@ClassKey
		,@StartDate
		,@EndDate
		,@AllocateBy
		,@TotalOverhead50 output
		,@TotalOverhead51 output
		,@TotalOverhead52 output
		,@TotalAGI output
		,@TotalHours output
		,@TotalLaborCost output
		,@TotalBillings output
		
	
	--by AGI
	/*
	if @AllocateBy = 1
		begin
			if @TotalAGI <> 0
				update #tRpt
				set OutsideCostsAllocated = (AdjustedGrossIncome / @TotalAGI) * @TotalOverhead50
				   ,OverheadAllocation = (AdjustedGrossIncome / @TotalAGI) * @TotalOverhead51
				   ,OtherCostsAllocated = (AdjustedGrossIncome / @TotalAGI) * @TotalOverhead52
				   ,TotalOverhead = @TotalOverhead51
				   ,TotalAGI = @TotalAGI
				   ,AGIPercent = AdjustedGrossIncome / @TotalAGI
				Where ClientKey > 0
		end
	*/
	
	--by labor hours
	if @AllocateBy = 2
		begin
			if @TotalHours <> 0
				update #tRpt
				set OutsideCostsAllocated = (LaborHours / @TotalHours) * @TotalOverhead50
				   ,OverheadAllocation = (LaborHours / @TotalHours) * @TotalOverhead51
				   ,OtherCostsAllocated = (LaborHours / @TotalHours) * @TotalOverhead52
				   ,TotalOverhead = @TotalOverhead51
				   ,TotalHours = @TotalHours
				   ,HoursPercent = LaborHours / @TotalHours
				Where ClientKey > 0
		end
            
	--by labor cost		
	if @AllocateBy = 3
		begin
			if @TotalLaborCost <> 0
				update #tRpt
				set OutsideCostsAllocated = (InsideLaborCost / @TotalLaborCost) * @TotalOverhead50
				   ,OverheadAllocation = (InsideLaborCost / @TotalLaborCost) * @TotalOverhead51
				   ,OtherCostsAllocated = (InsideLaborCost / @TotalLaborCost) * @TotalOverhead52
				   ,TotalOverhead = @TotalOverhead51
				   ,TotalLaborCost = @TotalLaborCost
				   ,LaborCostPercent = InsideLaborCost / @TotalLaborCost
				Where ClientKey > 0
		end
	
	--by billings			
	if @AllocateBy = 4
		begin 
			
			if @TotalBillings <> 0
				update #tRpt
				set OutsideCostsAllocated = (Revenue / @TotalBillings) *@TotalOverhead50
				   ,OverheadAllocation = (Revenue / @TotalBillings) * @TotalOverhead51
				   ,OtherCostsAllocated = (Revenue / @TotalBillings) * @TotalOverhead52			
				   ,TotalOverhead = @TotalOverhead51
				   ,TotalInvoice = @TotalBillings
				  ,InvoicePercent = Revenue / @TotalBillings
				Where ClientKey > 0     
		end

	-- Subtract out the inside costs
	update #tRpt
	set OverheadAllocation = OverheadAllocation - InsideLaborCost - InsideExpenseCost

	--no overhead allocation
	if @AllocateBy = 5
		begin 
			update #tRpt
			set OverheadAllocation = 0	
		end
				
	--update the Overhead values for use by the drilldown
	update	#tRpt
	set		Overhead50 = @TotalOverhead50,
			Overhead51 = @TotalOverhead51,
			Overhead52 = @TotalOverhead52
				
	--AGI
	update #tRpt
	set AdjustedGrossIncome = Revenue - OutsideCostsDirect - OutsideCostsAllocated, 
		OutsideCosts = OutsideCostsDirect + OutsideCostsAllocated,
		TotalInsideCosts = InsideLaborCost + InsideExpenseCost + OverheadAllocation + InsideCostsDirect,
		OtherCosts = OtherCostsDirect + OtherCostsAllocated
	
	update #tRpt
	set OrdinaryIncome = AdjustedGrossIncome - TotalInsideCosts,
		NetProfit = AdjustedGrossIncome - TotalInsideCosts - OtherCosts + OtherIncomeDirect

	
	--calculate percentages of overall (column) totals
	select @TotalRevenue = isnull((select sum(Revenue) from #tRpt), 0)
	select @TotalOutsideCosts = isnull((select sum(OutsideCosts) from #tRpt), 0)
	if @TotalRevenue <> 0
		update #tRpt
		set RevenuePercent = Revenue / @TotalRevenue * 100
	if @TotalOutsideCosts <> 0
		update #tRpt
		set OutsideCostsPercentCost = OutsideCosts / @TotalOutsideCosts * 100

	--calculate row percentages of revenue
	update #tRpt
	set OutsideCostsPercentRevenue = OutsideCosts / Revenue * 100
		,AdjustedGrossIncomePercentRevenue = AdjustedGrossIncome / Revenue * 100
		,InsideLaborCostPercentRevenue = InsideLaborCost / Revenue * 100
		,InsideExpenseCostPercentRevenue = InsideExpenseCost / Revenue * 100
		,TotalInsideCostsPercentRevenue = TotalInsideCosts / Revenue * 100
		,OverheadAllocationPercentRevenue = OverheadAllocation / Revenue * 100
		,OrdinaryIncomePercentRevenue = OrdinaryIncome / Revenue * 100
		,NetProfitPercentRevenue = NetProfit / Revenue * 100
	where Revenue <> 0

	--calculate row percentages of AGI
	update #tRpt
	set InsideLaborCostPercentAGI = InsideLaborCost / AdjustedGrossIncome * 100
		,InsideExpenseCostPercentAGI = InsideExpenseCost / AdjustedGrossIncome * 100
		,TotalInsideCostsPercentAGI = TotalInsideCosts / AdjustedGrossIncome * 100
		,OverheadAllocationPercentAGI = OverheadAllocation / AdjustedGrossIncome * 100
		,OrdinaryIncomePercentAGI = OrdinaryIncome / AdjustedGrossIncome * 100
		,NetProfitPercentAGI = NetProfit / AdjustedGrossIncome * 100
	where AdjustedGrossIncome <> 0	

	return 1
GO
