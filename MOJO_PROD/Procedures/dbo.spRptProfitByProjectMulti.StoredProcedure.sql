USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProfitByProjectMulti]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProfitByProjectMulti]
	 @CompanyKey int
	,@GLCompanyKey int
	,@OfficeKey int
	,@StartDate smalldatetime
	,@EndDate smalldatetime
	,@AllocateBy smallint
	,@IncludeOther tinyint -- 0: No extra rows, 1: add No Project row, 2: add a No Project/No Client
	,@UserKey int = null

AS --Encrypt

  /*
  || When     Who Rel    What
  || 10/17/07 RTC 8.5	   Creation for 85 profit analysis
  || 11/01/07 GHL 8.5    Added error checking
  || 11/11/07 GWG 8.5    Modified for the new layout
  || 11/20/07 CRG 8.5    Modified to make queries more efficient
  || 11/27/07 GHL 8.5    Added WITH for compliance with SQL Server 2005
  || 05/16/08 GHL 8.510  Noticed that we have rows where ClientKey = null, ProjectKey >0
  ||                     So modified the queries (for specific project)
  ||                     Noticed that NO CLIENT/NO PROJECT had multiple Offices 
  ||                     so modified the queries when @IncluedOther > 1 so that we do not
  ||                     create duplicate data for these rows 
  || 09/16/08 GHL 10.009 (32478) Time entry regardless of GL transactions must be in
  || 10/21/08 CRG 10.0.1.1 (37032) Added ClassID and ClassName
  || 02/10/09 RTC 10.018 Removed query hint for better performance
  || 03/30/09 GHL 10.022 (48136) Modified query in if @IncludeOther > 0 block
  || 04/27/09 GWG 10.023 Always getting time from raw tables so that labor cost and inside costs always get applied
  || 10/09/09 GHL 10.512 (58567) Added Project Status
  || 12/06/09 GHL 10.514 (69687) Added projects with misc costs and ER activity to help with InsideExpenseCost 
  || 01/12/11 GHL 10.540 (100093) Removed 'AND t.ClientKey is not null' for OutsideCostsDirect
  ||                     was a problem with a vendor line without a client
  ||                     IOClientLink = 2 media and IO had no media estimate
  || 04/13/11 GHL 10.543 Rolledback 100093 because 1) I fixed the data at client site (found client where missing) 
  ||                     2) This caused a discrepancy between Client PL Multi and Project PL Multi noticed by Ron Ause
  ||                     on 4/12/2011
  || 04/22/11 RLB 10.543 (109178) Added Retainer Name
  || 03/07/12 GHL 10.554 (135111) Added CurrentTotalBudget
  || 04/12/12 GHL 10.555 Added UserKey for UserGLCompanyAccess
  || 09/12/12 MFT 10.560 Added ParentClientDivision
  || 06/10/13 RLB 10.568 ClassKey was added to spRptProfitCalcOverheadAllocation passing in a null since no classkey is avaible here
  || 07/17/13 RLB 10.570  (183577) Added Company Owner from ContactOwnerKey
  || 09/27/13 GHL 10.572  (188701) In the NO CLIENT row, remove the overhead transactions
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

	if @IncludeOther > 0
	BEGIN
		Insert #tRpt (ProjectKey, Project, ClientKey, Client, OfficeKey, GLCompanyKey)
		Select -1, '- NONE - No Project', c.CompanyKey
		,ISNULL(c.CustomerID, '') + '-' + ISNULL(c.CompanyName, '')
		,ISNULL(t.OfficeKey, 0), ISNULL(t.GLCompanyKey, 0)
		-- make them null, this is just for grouping, otherwise we have to include them in the summary queries
		-- because right now it creates duplicate queried data 
		--,null, null
		From tTransaction t (nolock)
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		inner join tCompany c (nolock) on t.ClientKey = c.CompanyKey
		Where t.ClientKey is not null 
		and t.ProjectKey is null
		and (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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
		and gl.AccountType in (40, 41, 50, 51, 52) 
		and	t.CompanyKey = @CompanyKey
		and ISNULL(t.Overhead , 0) = 0
		-- removed this for 48136
		--and (t.ClientKey in (select distinct ClientKey from #tRpt) or @IncludeOther = 2)
		Group By c.CompanyKey, c.CustomerID, c.CompanyName, ISNULL(t.OfficeKey, 0), ISNULL(t.GLCompanyKey, 0) 
		--Group By c.CompanyKey, c.CustomerID, c.CompanyName 
	
	END
	
	if @IncludeOther > 1
	BEGIN
		Insert #tRpt (ProjectKey, Project, ClientKey, Client, OfficeKey, GLCompanyKey)
		--Select -1, '- NONE - No Project', -1, '- NONE - No Client', null, null
		--Same here this creates duplicate queried data 
		Select -1, '- NONE - No Project', -1, '- NONE - No Client'
		,ISNULL(t.OfficeKey, 0), ISNULL(t.GLCompanyKey, 0)
		From tTransaction t (nolock)
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		--Where (isnull(t.Overhead, 0) = 1 or t.ClientKey is null) -- 188701
		Where t.ClientKey is null -- 188701
		and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
		and (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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
				
		and gl.AccountType in (40, 41) 
		and	t.CompanyKey = @CompanyKey
		Group By ISNULL(t.OfficeKey, 0), ISNULL(t.GLCompanyKey, 0)

	END


	
		-- Added 09/05/08 Time Entry regardless of GL transactions must be in
		Insert #tRpt(ProjectKey, ClientKey)
		Select Distinct p.ProjectKey, p.ClientKey
		From tTime t (nolock) 
			inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
			INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
			INNER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
			WHERE	ts.CompanyKey = @CompanyKey
				AND		t.WorkDate >= @StartDate AND t.WorkDate <= @EndDate
				AND		ts.Status = 4
				AND		ISNULL(c.Overhead, 0) = 0
				AND		(@OfficeKey IS NULL or ISNULL(p.OfficeKey, 0) = @OfficeKey)
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

				and p.ProjectKey not in (select ProjectKey from #tRpt)

		-- Added 12/06/09 Needed for InsideExpenseCost
		Insert #tRpt(ProjectKey, ClientKey)
		Select Distinct p.ProjectKey, p.ClientKey
		From tMiscCost mc (nolock) 
			INNER JOIN tProject p (nolock) ON mc.ProjectKey = p.ProjectKey
			INNER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
			WHERE	p.CompanyKey = @CompanyKey
				AND	mc.ExpenseDate >= @StartDate AND mc.ExpenseDate <= @EndDate
				AND	ISNULL(c.Overhead, 0) = 0
				AND	(@OfficeKey IS NULL or ISNULL(p.OfficeKey, 0) = @OfficeKey)
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
				and p.ProjectKey not in (select ProjectKey from #tRpt)

		-- Added 12/06/09 Needed for InsideExpenseCost
		Insert #tRpt(ProjectKey, ClientKey)
		Select Distinct p.ProjectKey, p.ClientKey
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
				and p.ProjectKey not in (select ProjectKey from #tRpt)

	
		CREATE TABLE #tTime
			(ClientKey int null,
			ProjectKey int null,
			ActualHours decimal(24,4) null,
			Cost money null)
		
		/*	
		INSERT	#tTime
		SELECT	p.ClientKey, p.ProjectKey,
				ISNULL(SUM(ISNULL(t.ActualHours, 0)), 0),
				ISNULL(SUM(ISNULL(ActualHours, 0) * ISNULL(CostRate,0)), 0)
		FROM	tTime t WITH (index=IX_tTime_2, nolock) 
		INNER JOIN tTimeSheet ts (nolock) ON t.TimeSheetKey = ts.TimeSheetKey
		INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
		INNER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
        INNER JOIN (Select Distinct ProjectKey From tTransaction (nolock) 
                     inner join tGLAccount on tTransaction.GLAccountKey = tGLAccount.GLAccountKey
                     Where TransactionDate >= @StartDate AND TransactionDate <= @EndDate
                     and tGLAccount.AccountType in (40, 41, 50, 51, 52)
	                ) as pKeys on p.ProjectKey = pKeys.ProjectKey
		WHERE	ts.CompanyKey = @CompanyKey
		AND		t.WorkDate >= @StartDate AND t.WorkDate <= @EndDate
		AND		ts.Status = 4
		AND		ISNULL(c.Overhead, 0) = 0
		AND		(@OfficeKey IS NULL or ISNULL(p.OfficeKey, 0) = @OfficeKey)
		AND		(@GLCompanyKey IS NULL or ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
		GROUP BY p.ClientKey, p.ProjectKey
		*/
			
		-- Modified 09/05/08, no joins with tTransaction but #tRpt	
		INSERT	#tTime
		SELECT	p.ClientKey, p.ProjectKey,
				ISNULL(SUM(ISNULL(t.ActualHours, 0)), 0),
				ISNULL(SUM(ISNULL(ActualHours, 0) * ISNULL(HCostRate,0)), 0)
		FROM	tTime t (nolock) 
		INNER JOIN tTimeSheet ts (nolock) ON t.TimeSheetKey = ts.TimeSheetKey
		INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
		INNER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
        INNER JOIN (SELECT DISTINCT  ProjectKey FROM #tRpt)
				as pKeys on p.ProjectKey = pKeys.ProjectKey
		WHERE	ts.CompanyKey = @CompanyKey
		AND		t.WorkDate >= @StartDate AND t.WorkDate <= @EndDate
		AND		ts.Status = 4
		AND		ISNULL(c.Overhead, 0) = 0
		AND		(@OfficeKey IS NULL or ISNULL(p.OfficeKey, 0) = @OfficeKey)
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
		GROUP BY p.ClientKey, p.ProjectKey
		
		-- Insert the pair ClientKey, ProjectKey if not in the temp table yet
		INSERT	#tRpt (ClientKey, ProjectKey)
		SELECT	#tTime.ClientKey, #tTime.ProjectKey
		FROM	#tTime
		LEFT JOIN #tRpt ON #tTime.ClientKey = #tRpt.ClientKey AND #tTime.ProjectKey = #tRpt.ProjectKey
		WHERE	#tRpt.ClientKey IS NULL
		AND		#tRpt.ProjectKey IS NULL


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

	--update project related columns
	update #tRpt
	set  Project = isnull(p.ProjectNumber, '- NONE') + ' - ' + isnull(p.ProjectName, 'No Project')
		,ProjectTypeName = pt.ProjectTypeName
		,ProjectStatusName = ps.ProjectStatus
		,CampaignID = cmp.CampaignID
		,CampaignName = cmp.CampaignName
		,DivisionName = d.DivisionName
		,ProductName = prd.ProductName
		,OfficeKey = p.OfficeKey
		,GLCompanyKey = p.GLCompanyKey
		,ClassKey = p.ClassKey
		,RetainerName = rt.Title
		,CurrentTotalBudget = p.EstLabor + p.EstExpenses + ISNULL(p.SalesTax, 0)
							+ p.ApprovedCOLabor + p.ApprovedCOExpense + ISNULL(p.ApprovedCOSalesTax, 0)
		            
	from tProject p (nolock)
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	left outer join tCampaign cmp (nolock) on p.CampaignKey = cmp.CampaignKey
	left outer join tClientDivision d (nolock) on p.ClientDivisionKey = d.ClientDivisionKey
	left outer join tClientProduct prd (nolock) on p.ClientProductKey = prd.ClientProductKey
	left outer join tRetainer rt (nolock) on p.RetainerKey = rt.RetainerKey
	where #tRpt.ProjectKey = p.ProjectKey

	--update Account Manager
	update #tRpt
	set  AccountManager = am.FirstName + ' ' + am.LastName
	from tProject p (nolock)
	left outer join tUser am (nolock) on p.AccountManager = am.UserKey 
	where #tRpt.ProjectKey = p.ProjectKey

	--update Company Owner
	update #tRpt
	set  CompanyOwner = co.FirstName + ' ' + co.LastName
	from tCompany c (nolock)
	left outer join tUser co (nolock) on c.ContactOwnerKey = co.UserKey 
	where #tRpt.ClientKey = c.CompanyKey

	--update client related columns
	update #tRpt
	set  Client = '- NONE - No Client' 
	where #tRpt.ClientKey is null
	
	update #tRpt
	set  ParentClient = ISNULL(pcl.CustomerID, '') + '-' + ISNULL(pcl.CompanyName, '')
		,Client = ISNULL(cl.CustomerID, '') + '-' + ISNULL(cl.CompanyName, '')
		,ParentClientDivision = cd.DivisionName
	from tCompany cl (nolock) 
	left outer join tCompany pcl (nolock) on cl.ParentCompanyKey = pcl.CompanyKey
	left outer join tClientDivision cd (nolock) on cl.ParentCompanyDivisionKey = cd.ClientDivisionKey
	where #tRpt.ClientKey = cl.CompanyKey
	
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
	
	--update Class related columns
	update	#tRpt
	set		ClassID = 'No Class',
			ClassName = 'No Class'
	where	#tRpt.ClassKey is null
	
	update	#tRpt
	set		ClassID = c.ClassID,
			ClassName = c.ClassName
	from	tClass c (nolock) 
	where	#tRpt.ClassKey = c.ClassKey
		
	-- Project Specific
	update #tRpt
	set Revenue = ISNULL(tmp.Amount, 0)
	from	(select sum(Credit - Debit) as Amount
			,isnull(t.ClientKey, 0) as ClientKey
			,isnull(t.ProjectKey,0) as ProjectKey
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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
			--and t.ClientKey is not null -- to capture the case ProjectK>0, ClientK=NULL 
			group by isnull(t.ClientKey, 0), isnull(t.ProjectKey, 0)
			) as tmp
	where	ISNULL(#tRpt.ClientKey, 0) = ISNULL(tmp.ClientKey, 0)
	and		#tRpt.ProjectKey = tmp.ProjectKey
		

	-- update the client row with no project
	if @IncludeOther > 0
	BEGIN
		update #tRpt
		set Revenue = ISNULL(tmp.Amount, 0)
		from	(select sum(Credit - Debit) as Amount
				, ISNULL(t.ClientKey, 0) AS ClientKey
				, ISNULL(t.OfficeKey, 0) AS OfficeKey
				, ISNULL(t.GLCompanyKey, 0) AS GLCompanyKey
				from vHTransaction t (nolock) 
				inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
				where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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
				--and t.ProjectKey is null
				and ISNULL(t.ProjectKey, 0) = 0 -- capture t.ProjectKey = 0	 
				group by ISNULL(t.ClientKey, 0), ISNULL(t.OfficeKey, 0), ISNULL(t.GLCompanyKey, 0) 
				) as tmp
		Where	#tRpt.ProjectKey = -1
		and		ISNULL(#tRpt.ClientKey, 0) = tmp.ClientKey
		and     ISNULL(#tRpt.OfficeKey, 0) = tmp.OfficeKey
		and     ISNULL(#tRpt.GLCompanyKey, 0) = tmp.GLCompanyKey
	END
	
	-- update the no client, no project row
	if @IncludeOther > 1
	BEGIN
	update #tRpt
	set Revenue =
		isnull((
			select sum(Credit - Debit)
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where t.CompanyKey = @CompanyKey
			and (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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

			and ISNULL(t.OfficeKey, 0) = ISNULL(#tRpt.OfficeKey, 0)
			and ISNULL(t.GLCompanyKey, 0) = ISNULL(#tRpt.GLCompanyKey, 0)
			
			and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
			and gl.AccountType = 40
			--and (isnull(t.Overhead, 0) = 1 or (t.ClientKey is null and t.ProjectKey is null)) -- 188701
			and (t.ClientKey is null and t.ProjectKey is null) -- 188701
		), 0)
	Where #tRpt.ClientKey = -1 and #tRpt.ProjectKey = -1
	
	END

	-- Project Specific
	update #tRpt
	set OtherIncomeDirect = ISNULL(tmp.Amount, 0)
	from	(select sum(Credit - Debit) as Amount
			, isnull(t.ClientKey, 0) as ClientKey, isnull(t.ProjectKey,0) as ProjectKey
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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
			--and t.ClientKey is not null -- to capture the case ProjectK>0, ClientK=NULL
			group by isnull(t.ClientKey, 0), isnull(t.ProjectKey,0)) as tmp
	where	ISNULL(#tRpt.ClientKey, 0) = ISNULL(tmp.ClientKey, 0)
	and		#tRpt.ProjectKey = tmp.ProjectKey

	-- update the client only row
	if @IncludeOther > 0
	BEGIN
		update #tRpt
		set OtherIncomeDirect = ISNULL(tmp.Amount, 0)
		from	(select sum(Credit - Debit) as Amount
					, isnull(t.ClientKey, 0) AS ClientKey
					, isnull(t.OfficeKey, 0) AS OfficeKey
					, isnull(t.GLCompanyKey, 0) AS GLCompanyKey
					
				from vHTransaction t (nolock) 
				inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
				where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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
				--and t.ProjectKey is null
				and ISNULL(t.ProjectKey, 0) = 0 -- capture t.ProjectKey = 0	
				group by ISNULL(t.ClientKey, 0), ISNULL(t.OfficeKey, 0), ISNULL(t.GLCompanyKey, 0) 
				) as tmp
		Where	#tRpt.ProjectKey = -1
		and		ISNULL(#tRpt.ClientKey, 0) = tmp.ClientKey
		and     ISNULL(#tRpt.OfficeKey, 0) = tmp.OfficeKey
		and     ISNULL(#tRpt.GLCompanyKey, 0) = tmp.GLCompanyKey
	END
	
	-- update the no client, no project row
	if @IncludeOther > 1
	BEGIN
		update #tRpt
		set OtherIncomeDirect =
			isnull((
				select sum(Credit - Debit)
				from vHTransaction t (nolock) 
				inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
				where t.CompanyKey = @CompanyKey
				and (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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

				and ISNULL(t.OfficeKey, 0) = ISNULL(#tRpt.OfficeKey, 0)
				and ISNULL(t.GLCompanyKey, 0) = ISNULL(#tRpt.GLCompanyKey, 0)

				and t.TransactionDate >= @StartDate and t.TransactionDate <= @EndDate
				and gl.AccountType = 41
				--and (isnull(t.Overhead, 0) = 1 or (t.ClientKey is null and t.ProjectKey is null)) -- 188701
				and (t.ClientKey is null and t.ProjectKey is null) -- 188701
			), 0)
		Where #tRpt.ClientKey = -1 and #tRpt.ProjectKey = -1
	END

	--Direct Costs - Project Specific
	update #tRpt
	set OutsideCostsDirect = ISNULL(tmp.Amount, 0)
	from	(select sum(Debit - Credit) AS Amount
		   , isnull(t.ClientKey, 0) as ClientKey, isnull(t.ProjectKey,0) as ProjectKey
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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
			-- Why this? Commented out for 100093
			--and t.ClientKey is not null -- to capture the case ProjectK>0, ClientK=NULL
			and t.ClientKey is not null -- put back to correct discrepancy between Client PL Multi and Project PL Multi 
			group by isnull(t.ClientKey, 0), isnull(t.ProjectKey, 0)) as tmp
	where	ISNULL(#tRpt.ClientKey, 0) = ISNULL(tmp.ClientKey, 0)
	and		#tRpt.ProjectKey = tmp.ProjectKey
	
	update #tRpt
	set InsideCostsDirect = ISNULL(tmp.Amount, 0)
	from	(select sum(Debit - Credit) AS Amount
	        , isnull(t.ClientKey, 0) as ClientKey, isnull(t.ProjectKey,0) as ProjectKey
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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
			-- Why this?
			and t.ClientKey is not null -- to capture the case ProjectK>0, ClientK=NULL
			group by isnull(t.ClientKey, 0), isnull(t.ProjectKey, 0)) as tmp
	where	ISNULL(#tRpt.ClientKey, 0) = ISNULL(tmp.ClientKey, 0)
	and		#tRpt.ProjectKey = tmp.ProjectKey

	update #tRpt
	set OtherCostsDirect = ISNULL(tmp.Amount, 0)
	from	(select sum(Debit - Credit) AS Amount
			, isnull(t.ClientKey, 0) as ClientKey, isnull(t.ProjectKey,0) as ProjectKey
			from vHTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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
			-- Why this?
			and t.ClientKey is not null -- to capture the case ProjectK>0, ClientK=NULL
			group by isnull(t.ClientKey, 0), isnull(t.ProjectKey, 0)) as tmp
	where	ISNULL(#tRpt.ClientKey, 0) = ISNULL(tmp.ClientKey, 0)
	and		#tRpt.ProjectKey = tmp.ProjectKey
		
	
	if @IncludeOther > 0
	BEGIN
		--Direct Costs - No Project, Client Only
		update #tRpt
		set OutsideCostsDirect = ISNULL(tmp.Amount, 0)
		from	(select sum(Debit - Credit) AS Amount
					, ISNULL(t.ClientKey, 0) AS ClientKey
					, ISNULL(t.OfficeKey, 0) AS OfficeKey
					, ISNULL(t.GLCompanyKey, 0) AS GLCompanyKey
				from vHTransaction t (nolock) 
				inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
				where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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
				--and t.ProjectKey is null
				and ISNULL(t.ProjectKey, 0) = 0 -- capture t.ProjectKey = 0	
				and ISNULL(t.ClientKey, 0) > 0
				group by ISNULL(t.ClientKey, 0), ISNULL(t.OfficeKey, 0), ISNULL(t.GLCompanyKey, 0)
				) as tmp
		Where	#tRpt.ProjectKey = -1 
		and		ISNULL(#tRpt.ClientKey, 0) = tmp.ClientKey
		and     ISNULL(#tRpt.OfficeKey, 0) = tmp.OfficeKey
		and     ISNULL(#tRpt.GLCompanyKey, 0) = tmp.GLCompanyKey
		
		
		update #tRpt
		set InsideCostsDirect = ISNULL(tmp.Amount, 0)
		from	(select sum(Debit - Credit) AS Amount
					, ISNULL(t.ClientKey, 0) AS ClientKey
					, ISNULL(t.OfficeKey, 0) AS OfficeKey
					, ISNULL(t.GLCompanyKey, 0) AS GLCompanyKey
				from vHTransaction t (nolock) 
				inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
				where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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
				--and t.ProjectKey is null
				and ISNULL(t.ProjectKey, 0) = 0 -- capture t.ProjectKey = 0	
				and ISNULL(t.ClientKey, 0) > 0
				group by ISNULL(t.ClientKey, 0), ISNULL(t.OfficeKey, 0), ISNULL(t.GLCompanyKey, 0)
				) as tmp
		Where	#tRpt.ProjectKey = -1 
		and		ISNULL(#tRpt.ClientKey, 0) = tmp.ClientKey
		and     ISNULL(#tRpt.OfficeKey, 0) = tmp.OfficeKey
		and     ISNULL(#tRpt.GLCompanyKey, 0) = tmp.GLCompanyKey


		update #tRpt
		set OtherCostsDirect = ISNULL(tmp.Amount, 0)
		from	(select sum(Debit - Credit) AS Amount
					, ISNULL(t.ClientKey, 0) AS ClientKey
					, ISNULL(t.OfficeKey, 0) AS OfficeKey
					, ISNULL(t.GLCompanyKey, 0) AS GLCompanyKey
				from vHTransaction t (nolock) 
				inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
				where (@OfficeKey is null or ISNULL(t.OfficeKey, 0) = @OfficeKey)
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
				--and t.ProjectKey is null
				and ISNULL(t.ProjectKey, 0) = 0 -- capture t.ProjectKey = 0	
				and ISNULL(t.ClientKey, 0) > 0
				group by ISNULL(t.ClientKey, 0), ISNULL(t.OfficeKey, 0), ISNULL(t.GLCompanyKey, 0)
				) as tmp
		Where	#tRpt.ProjectKey = -1 
		and		ISNULL(#tRpt.ClientKey, 0) = tmp.ClientKey
		and     ISNULL(#tRpt.OfficeKey, 0) = tmp.OfficeKey
		and     ISNULL(#tRpt.GLCompanyKey, 0) = tmp.GLCompanyKey
		
	END

	
	--labor hours - project

	UPDATE	#tRpt
	SET		LaborHours = tmp.ActualHours,
			InsideLaborCost = tmp.Cost
	FROM	#tTime tmp
	WHERE	#tRpt.ClientKey = tmp.ClientKey
	AND		#tRpt.ProjectKey = tmp.ProjectKey


	--inside expenses
	update	#tRpt
	set InsideExpenseCost = ISNULL(tmp1.Amount, 0) + ISNULL(tmp2.Amount, 0)
	from	#tRpt
	left join (select sum(round(isnull(TotalCost,0) * m.ExchangeRate, 2) ) AS Amount, p.ClientKey, m.ProjectKey
			from tMiscCost m (nolock) 
			inner join tProject p (nolock) on m.ProjectKey = p.ProjectKey
			where (@OfficeKey is null or ISNULL(p.OfficeKey, 0) = @OfficeKey)
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
			group by p.ClientKey, m.ProjectKey) as tmp1 ON #tRpt.ClientKey = tmp1.ClientKey AND #tRpt.ProjectKey = tmp1.ProjectKey
	left join (select sum(round(isnull(ActualCost,0) * ee.ExchangeRate, 2)) AS Amount, p.ClientKey, e.ProjectKey
			from tExpenseReceipt e (nolock) 
			inner join tExpenseEnvelope ee (nolock) on e.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
			inner join tProject p (nolock) on e.ProjectKey = p.ProjectKey
			where (@OfficeKey is null or ISNULL(p.OfficeKey, 0) = @OfficeKey)
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
			group by p.ClientKey, e.ProjectKey) as tmp2 ON #tRpt.ClientKey = tmp2.ClientKey AND #tRpt.ProjectKey = tmp2.ProjectKey
            
	--Overhead Allocations
	exec spRptProfitCalcOverheadAllocation 
		 @CompanyKey
		,@GLCompanyKey
		,@OfficeKey
		,NULL
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
