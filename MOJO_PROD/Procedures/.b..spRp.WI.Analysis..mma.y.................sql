USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptWIPAnalysisSummary]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptWIPAnalysisSummary]
	(
		@CompanyKey INT
		,@AsOfDate SMALLDATETIME
		,@GLCompanyKey INT		-- -1 All, 0 NULL, >0 valid GLCompany
		,@OfficeKey INT			-- -1 All, 0 NULL, >0 valid Office
		,@ClientKey INT			-- -1 All, 0 NULL, >0 valid Client
		,@AccountManager INT
		,@UserKey INT = null
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 08/27/07 GHL 8.5  Creation for new WIP analysis report       
  || 08/28/07 GHL 8.5  Changed var names to make it consistent with spRptWIPAnalysisProjects
  ||                   + Added check of AsOfDate     
  || 11/09/07 GHL 8.5  Removed entity = wip from where clause  
  || 02/01/08 GWG 8.503Changed Income fields to be Credit - Debit to show a positive balance   
  || 07/1/09  GWG 10.5 Updated the second call to unposted orders with an isnull so it does not blank out previous amt. 
  || 04/29/10 GWG 10.522 Added restict logic for unbilled amounts to not include things transfered in at a later date.
  || 11/10/10 GHL 10.537 (93562) Querying now unbilled labor like in spGLPostWIP to improve perfo
  || 11/10/10 GHL 10.537 Added logic for @WIPBookVoucherToRevenue
  || 02/02/11 GHL 10.541 (102052) Added AND	(vd.TransferInDate is NULL OR vd.TransferInDate <= @AsOfDate) to where clause
  ||                     for unbilled other expense to be consistent with spRptWIPAnalysisUnpostedDetail
  || 04/12/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
  || 02/24/15 GHL 10.589  Take in account tProject.DoNotPostWIP
  */
  
	SET NOCOUNT ON
	
-- Get Default Accounts
Declare @WIPLaborAssetAccountKey int, @WIPLaborAssetAccount varchar(1000), @WIPLaborAssetAccountAmount money
Declare @WIPLaborIncomeAccountKey int, @WIPLaborIncomeAccount varchar(1000), @WIPLaborIncomeAccountAmount money
Declare @WIPLaborWOAccountKey int, @WIPLaborWOAccount varchar(1000), @WIPLaborWOAccountAmount money

Declare @WIPExpenseAssetAccountKey int, @WIPExpenseAssetAccount varchar(1000), @WIPExpenseAssetAccountAmount money
Declare @WIPExpenseIncomeAccountKey int, @WIPExpenseIncomeAccount varchar(1000), @WIPExpenseIncomeAccountAmount money
Declare @WIPExpenseWOAccountKey int, @WIPExpenseWOAccount varchar(1000), @WIPExpenseWOAccountAmount money

Declare @WIPMediaAssetAccountKey int, @WIPMediaAssetAccount varchar(1000), @WIPMediaAssetAccountAmount money
Declare @WIPMediaIncomeAccountKey int, @WIPMediaIncomeAccount varchar(1000), @WIPMediaIncomeAccountAmount money
Declare @WIPMediaWOAccountKey int, @WIPMediaWOAccount varchar(1000), @WIPMediaWOAccountAmount money

Declare @WIPVoucherAssetAccountKey int, @WIPVoucherAssetAccount varchar(1000), @WIPVoucherAssetAccountAmount money
Declare @WIPVoucherIncomeAccountKey int, @WIPVoucherIncomeAccount varchar(1000), @WIPVoucherIncomeAccountAmount money
Declare @WIPVoucherWOAccountKey int, @WIPVoucherWOAccount varchar(1000), @WIPVoucherWOAccountAmount money

Declare @IOClientLink int
Declare @BCClientLink int
Declare @WIPBookVoucherToRevenue int

Select
	@WIPLaborAssetAccountKey = ISNULL(WIPLaborAssetAccountKey, 0),
	@WIPLaborIncomeAccountKey = ISNULL(WIPLaborIncomeAccountKey, 0),
	@WIPLaborWOAccountKey = ISNULL(WIPLaborWOAccountKey, 0),

	@WIPExpenseAssetAccountKey = ISNULL(WIPExpenseAssetAccountKey, 0),
	@WIPExpenseIncomeAccountKey = ISNULL(WIPExpenseIncomeAccountKey, 0),
	@WIPExpenseWOAccountKey = ISNULL(WIPExpenseWOAccountKey, 0),

	@WIPMediaAssetAccountKey = ISNULL(WIPMediaAssetAccountKey, 0),
	@WIPMediaIncomeAccountKey = ISNULL(WIPMediaIncomeAccountKey, 0),
	@WIPMediaWOAccountKey = ISNULL(WIPMediaWOAccountKey, 0),

	@WIPVoucherAssetAccountKey = ISNULL(WIPVoucherAssetAccountKey, 0),
	@WIPVoucherIncomeAccountKey = ISNULL(WIPVoucherIncomeAccountKey, 0),
	@WIPVoucherWOAccountKey = ISNULL(WIPVoucherWOAccountKey, 0),
	
	@IOClientLink = ISNULL(IOClientLink, 1),
	@BCClientLink = ISNULL(BCClientLink, 1),
	@WIPBookVoucherToRevenue = ISNULL(WIPBookVoucherToRevenue, 0)

from tPreference (nolock) 
Where CompanyKey = @CompanyKey

Select @WIPLaborAssetAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPLaborAssetAccountKey
Select @WIPLaborIncomeAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPLaborIncomeAccountKey
Select @WIPLaborWOAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPLaborWOAccountKey

Select @WIPExpenseAssetAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPExpenseAssetAccountKey
Select @WIPExpenseIncomeAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPExpenseIncomeAccountKey
Select @WIPExpenseWOAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPExpenseWOAccountKey

Select @WIPMediaAssetAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPMediaAssetAccountKey
Select @WIPMediaIncomeAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPMediaIncomeAccountKey
Select @WIPMediaWOAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPMediaWOAccountKey

Select @WIPVoucherAssetAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPVoucherAssetAccountKey
Select @WIPVoucherIncomeAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPVoucherIncomeAccountKey
Select @WIPVoucherWOAccount = AccountNumber + ' ' + AccountName from tGLAccount (nolock) Where GLAccountKey = @WIPVoucherWOAccountKey

Declare @UnbilledLabor money
Declare @UnbilledOtherExpenses money
Declare @UnbilledProductionExpenses money
Declare @UnbilledMediaExpenses money

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

IF @AsOfDate IS NOT NULL
BEGIN

-- Labor
	-- This will include WIP + JE
	SELECT @WIPLaborAssetAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPLaborAssetAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity IN ('WIP', 'GENJRNL')
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)
	
	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )

	-- This will include WIP + JE
	SELECT @WIPLaborIncomeAccountAmount = SUM(gl.Credit - gl.Debit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPLaborIncomeAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity IN ('WIP', 'GENJRNL')
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )

	-- This will include WIP + JE
	SELECT @WIPLaborWOAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPLaborWOAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity IN ('WIP', 'GENJRNL')
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)


	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )


	create table #tTime (
	ProjectKey int null
	, RetainerKey int null
	, TimeKey uniqueidentifier
	, WIPPostingInKey int null    -- initial query index IX_tTime_24
	, WIPPostingOutKey int null   -- initial query index IX_tTime_24
	, InvoiceLineKey int null     -- initial query index IX_tTime_24
	, DateBilled smalldatetime null   -- initial query index IX_tTime_24
	
	, ServiceKey int null             -- later query index PK_tTime, then IX_tTime_9
	, ActualHours decimal(24, 4) null -- later query index PK_tTime, then IX_tTime_9
	, ActualRate money null           -- later query index PK_tTime, then IX_tTime_9
	
	, WorkDate smalldatetime null         -- later query index PK_tTime, then let SQL decides
	, TransferInDate smalldatetime null   -- later query index PK_tTime, then let SQL decides
	
	, TimeSheetStatus int null  -- index PK_tTime, then IX_tTime_13   
	
	, UserKey int null -- added for ICT/GLCompanySource
	, GLCompanyKey int null
	, OfficeKey int null
    , UpdateFlag int null
	)

	-- insert the time entries that never went IN WIP
	insert #tTime (ProjectKey, RetainerKey, TimeKey, WIPPostingInKey, WIPPostingOutKey, InvoiceLineKey, DateBilled, GLCompanyKey, OfficeKey,UpdateFlag)
	select t.ProjectKey, isnull(p.RetainerKey, 0), t.TimeKey, t.WIPPostingInKey, t.WIPPostingOutKey, t.InvoiceLineKey, t.DateBilled
	-- by default, pick gl comp and office from project
	, p.GLCompanyKey, p.OfficeKey, 0
	from tTime t with (index=IX_tTime_24, nolock) 
		inner join tProject p  (nolock) on t.ProjectKey = p.ProjectKey
	where p.CompanyKey = @CompanyKey
	and   p.NonBillable = 0
	and   isnull(p.DoNotPostWIP, 0) = 0
	and   t.WIPPostingInKey = 0
	AND	 (t.DateBilled IS NULL OR t.DateBilled > @AsOfDate)    
	/* commented out because of tProject.GLCompanySource
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	*/
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )

	-- check time sheet status
	-- index PK_tTime, then IX_tTime_13
	update #tTime
	set    #tTime.TimeSheetStatus = ts.Status 
	      ,#tTime.UserKey = ts.UserKey
	from   tTime t with (index=PK_tTime, nolock)
		  ,tTimeSheet ts (nolock)
	where  #tTime.TimeKey = t.TimeKey
	and    t.TimeSheetKey = ts.TimeSheetKey

	delete #tTime where TimeSheetStatus <> 4
	
	-- update work date/tranfer date...there is no index for that
	update #tTime
	set    #tTime.WorkDate = t.WorkDate
		  ,#tTime.TransferInDate = t.TransferInDate
	from   tTime t with (index=PK_tTime, nolock)
	where  #tTime.TimeKey = t.TimeKey

	delete #tTime where WorkDate > @AsOfDate
	delete #tTime where TransferInDate > @AsOfDate
	
	-- pull other data needed
	-- index PK_tTime, then IX_tTime_9
	update #tTime
	set    #tTime.ActualHours = t.ActualHours
		  ,#tTime.ActualRate = t.ActualRate
		  ,#tTime.ServiceKey = t.ServiceKey
	from   tTime t with (index=PK_tTime, nolock)
	where  #tTime.TimeKey = t.TimeKey

	-- now that we have a service key, we can remove services covered by retainer
	DELETE #tTime FROM tRetainerItems ri (NOLOCK) 
	WHERE  #tTime.RetainerKey > 0
	AND    #tTime.RetainerKey = ri.RetainerKey 
	AND    ri.EntityKey = #tTime.ServiceKey 
	AND    ri.Entity = 'tService'

	-- Correct gl comp and office based on project's GLCompanySource
	update #tTime
	set    #tTime.GLCompanyKey = u.GLCompanyKey
	      ,#tTime.OfficeKey = u.OfficeKey
	from   tProject p (nolock)
	      ,tUser u (nolock)
	where  #tTime.ProjectKey = p.ProjectKey
	and    #tTime.UserKey = u.UserKey
	and    isnull(p.GLCompanySource, 0) = 1

	if @GLCompanyKey >= 0
		delete #tTime where isnull(GLCompanyKey, 0) <> isnull(@GLCompanyKey, 0) 
	else
	begin
		-- All requested
		if @RestrictToGLCompany = 1
			delete #tTime
			where  isnull(GLCompanyKey, 0) not in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey)
	end

	if @OfficeKey >= 0
		delete #tTime where isnull(OfficeKey, 0) <> isnull(@OfficeKey, 0) 
	
	SELECT @UnbilledLabor = SUM(ROUND(t.ActualHours * t.ActualRate,2)) 
		from #tTime t (NOLOCK) 

	/* Initial query but takes too long
	-- Unposted to WIP Labor, Entity = WIP, Asset account
	SELECT @UnbilledLabor = SUM(ROUND(t.ActualHours * t.ActualRate,2)) 
		from tTime t (NOLOCK) 
			inner join tTimeSheet ts (NOLOCK) on t.TimeSheetKey = ts.TimeSheetKey
			--inner join tUser u (NOLOCK) on t.UserKey = u.UserKey
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left join tTask ta (NOLOCK) on t.TaskKey = ta.TaskKey
			--left join tService s (NOLOCK) on t.ServiceKey = s.ServiceKey
		Where		ts.CompanyKey = @CompanyKey
		AND			ts.Status = 4
		AND			p.NonBillable = 0
		AND			t.WorkDate <= @AsOfDate
		AND  		t.WIPPostingInKey = 0
		AND			p.CompanyKey = @CompanyKey -- Use indexes better
		-- Has not been billed at the time 
		AND			(t.DateBilled IS NULL OR t.DateBilled > @AsOfDate)
		AND			(t.TransferInDate is NULL OR t.TransferInDate <= @AsOfDate)
		AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
		AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
		AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
		AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )
				AND    t.ServiceKey NOT IN (SELECT ri.EntityKey 
									FROM tRetainerItems ri (NOLOCK)
									WHERE ri.RetainerKey = p.RetainerKey
									AND   ri.Entity = 'tService') 		
	--*/


-- Other Expenses
	-- This will include WIP + JE
	SELECT @WIPExpenseAssetAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPExpenseAssetAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity IN ('WIP', 'GENJRNL')
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )

	-- This will include WIP + JE
	SELECT @WIPExpenseIncomeAccountAmount = SUM(gl.Credit - gl.Debit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPExpenseIncomeAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity IN ('WIP', 'GENJRNL')
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )

	-- This will include WIP + JE
	SELECT @WIPExpenseWOAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPExpenseWOAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity IN ('WIP', 'GENJRNL')
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )

	-- Unposted to WIP Other Expenses, Entity = WIP, Asset account
	SELECT @UnbilledOtherExpenses = SUM(mc.TotalCost)
	FROM		tMiscCost mc (NOLOCK)
	INNER JOIN	tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tItem it (NOLOCK) ON mc.ItemKey = it.ItemKey
	WHERE		p.CompanyKey = @CompanyKey
	AND			p.NonBillable = 0
	and         isnull(p.DoNotPostWIP, 0) = 0
	AND			mc.ExpenseDate <= @AsOfDate
	AND 		mc.WIPPostingInKey = 0
	-- Has not been billed at the time 
	AND			(mc.DateBilled IS NULL OR mc.DateBilled > @AsOfDate)
	AND			(mc.TransferInDate is NULL OR mc.TransferInDate <= @AsOfDate)
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )
	AND    mc.ItemKey NOT IN (SELECT ri.EntityKey 
											FROM tRetainerItems ri (NOLOCK)
											WHERE ri.RetainerKey = p.RetainerKey
											AND   ri.Entity = 'tItem') 				

	SELECT	@UnbilledOtherExpenses = ISNULL(@UnbilledOtherExpenses, 0) + SUM(vd.TotalCost) 
	FROM		tVoucherDetail vd (NOLOCK)
	INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
	LEFT JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
	LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
	WHERE		v.CompanyKey = @CompanyKey
	AND			v.Status = 4
	AND         v.PostingDate <= @AsOfDate 
	AND			p.NonBillable = 0
	and         isnull(p.DoNotPostWIP, 0) = 0
	AND  		vd.WIPPostingInKey = 0
	AND  		vd.WIPPostingOutKey = 0 -- so that we do not pick up old vouchers who never got in
	AND			it.ItemType = 3   
	-- Has not been billed at the time 
	AND			(vd.DateBilled IS NULL OR vd.DateBilled > @AsOfDate)
	AND			(vd.TransferInDate is NULL OR vd.TransferInDate <= @AsOfDate)
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )
	AND    vd.ItemKey NOT IN (SELECT ri.EntityKey 
									FROM tRetainerItems ri (NOLOCK)
									WHERE ri.RetainerKey = p.RetainerKey
									AND   ri.Entity = 'tItem') 			

-- Production Expenses/Vouchers
	-- This will include WIP + JE
	SELECT @WIPVoucherAssetAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPVoucherAssetAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity IN ('WIP', 'GENJRNL')
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

	
	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )

	IF @WIPBookVoucherToRevenue = 1
	
		SELECT @WIPVoucherIncomeAccountAmount = SUM(gl.Credit - gl.Debit)
		FROM   tTransaction gl (NOLOCK)
			LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
		WHERE  gl.CompanyKey = @CompanyKey
		AND    gl.GLAccountKey = @WIPVoucherIncomeAccountKey 
		AND    gl.TransactionDate <= @AsOfDate
		--AND    gl.Entity IN ('WIP', 'GENJRNL')
		--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
		
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

		AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
		AND (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
		AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )
	

	-- This will include WIP + JE
	SELECT @WIPVoucherWOAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPVoucherWOAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity IN ('WIP', 'GENJRNL')
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )

	-- Unposted to WIP Other Expenses 
	SELECT		@UnbilledProductionExpenses = ISNULL(SUM(vd.TotalCost), 0) 
	FROM		tVoucherDetail vd (NOLOCK)
	INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
	LEFT JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
	LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
	LEFT  JOIN	tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	WHERE		v.CompanyKey = @CompanyKey
	AND			v.Status = 4
	AND         v.PostingDate <= @AsOfDate 
	AND			p.NonBillable = 0
	and   isnull(p.DoNotPostWIP, 0) = 0	
	AND  		vd.WIPPostingInKey = 0
	AND  		vd.WIPPostingOutKey = 0 -- so that we do not pick up old vouchers who never got in
	AND			pod.InvoiceLineKey IS NULL -- No PreBill PO ???????
	AND			it.ItemType = 0   
	-- Has not been billed at the time 
	AND			(vd.DateBilled IS NULL OR vd.DateBilled > @AsOfDate)
	AND			(vd.TransferInDate is NULL OR vd.TransferInDate <= @AsOfDate)
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )
	AND    vd.ItemKey NOT IN (SELECT ri.EntityKey 
									FROM tRetainerItems ri (NOLOCK)
									WHERE ri.RetainerKey = p.RetainerKey
									AND   ri.Entity = 'tItem') 			


-- Media Expenses/Vouchers
	-- This will include WIP + JE
	SELECT @WIPMediaAssetAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPMediaAssetAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity IN ('WIP', 'GENJRNL')
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )

	IF @WIPBookVoucherToRevenue = 1
	
		SELECT @WIPMediaIncomeAccountAmount = SUM(gl.Credit - gl.Debit)
		FROM   tTransaction gl (NOLOCK)
			LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
		WHERE  gl.CompanyKey = @CompanyKey
		AND    gl.GLAccountKey = @WIPMediaIncomeAccountKey 
		AND    gl.TransactionDate <= @AsOfDate
		--AND    gl.Entity IN ('WIP', 'GENJRNL')
		--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
		
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

		AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
		AND (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
		AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )

	-- This will include WIP + JE
	SELECT @WIPMediaWOAccountAmount = SUM(gl.Debit - gl.Credit)
	FROM   tTransaction gl (NOLOCK)
		LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.GLAccountKey = @WIPMediaWOAccountKey 
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity IN ('WIP', 'GENJRNL')
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )

	-- Unposted to WIP Media Expenses -- link through projects
	SELECT		@UnbilledMediaExpenses = SUM(vd.TotalCost) 
	FROM		tVoucherDetail vd (NOLOCK)
	INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
	LEFT JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
	LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
	LEFT  JOIN	tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	WHERE		v.CompanyKey = @CompanyKey
	AND			v.Status = 4
	AND         v.PostingDate <= @AsOfDate 
	AND			p.NonBillable = 0
	and   isnull(p.DoNotPostWIP, 0) = 0
	AND  		vd.WIPPostingInKey = 0
	AND  		vd.WIPPostingOutKey = 0 -- so that we do not pick up old vouchers who never got in
	AND			pod.InvoiceLineKey IS NULL -- No PreBill PO ???????
	AND		   ((@IOClientLink = 1 AND it.ItemType = 1) Or (@BCClientLink = 1 AND it.ItemType = 2)) 
	-- Has not been billed at the time 
	AND			(vd.DateBilled IS NULL OR vd.DateBilled > @AsOfDate)
	AND			(vd.TransferInDate is NULL OR vd.TransferInDate <= @AsOfDate)
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)

	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(p.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(p.ClientKey, 0)) )
	AND    (@AccountManager = -1 Or (ISNULL(@AccountManager, 0) = ISNULL(p.AccountManager, 0)) )
	AND    vd.ItemKey NOT IN (SELECT ri.EntityKey 
									FROM tRetainerItems ri (NOLOCK)
									WHERE ri.RetainerKey = p.RetainerKey
									AND   ri.Entity = 'tItem') 			

	-- Unposted to WIP Media Expenses -- link through media
	SELECT		@UnbilledMediaExpenses = ISNULL(@UnbilledMediaExpenses, 0) + ISNULL(SUM(vd.TotalCost), 0) 
	FROM		tVoucherDetail vd (NOLOCK)
	INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
	LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
	INNER  JOIN	tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	INNER  JOIN	tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
	inner join tMediaEstimate e (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
	WHERE		v.CompanyKey = @CompanyKey
	AND			v.Status = 4
	AND         v.PostingDate <= @AsOfDate 
	AND  		vd.WIPPostingInKey = 0
	AND  		vd.WIPPostingOutKey = 0 -- so that we do not pick up old vouchers who never got in
	AND			pod.InvoiceLineKey IS NULL -- No PreBill PO ???????
	AND		   ((@IOClientLink = 2 AND it.ItemType = 1) Or (@BCClientLink = 2 AND it.ItemType = 2)) 
	-- Has not been billed at the time 
	AND			(vd.DateBilled IS NULL OR vd.DateBilled > @AsOfDate)
	AND			(vd.TransferInDate is NULL OR vd.TransferInDate <= @AsOfDate)
	--AND    (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(e.GLCompanyKey, 0)) )
	
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey = -1 AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND e.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey != -1 AND ISNULL(e.GLCompanyKey, 0) = @GLCompanyKey)
			)

	
	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(e.OfficeKey, 0)) )
	AND    (@ClientKey = -1 Or (ISNULL(@ClientKey, 0) = ISNULL(e.ClientKey, 0)) )
	--AND    @AccountManager = -1

END -- As Of Date not null
	
Select
 @WIPLaborAssetAccount						as WIPLaborAssetAccount
,ISNULL(@WIPLaborAssetAccountAmount, 0)		as WIPLaborAssetAccountAmount
,@WIPLaborIncomeAccount						as WIPLaborIncomeAccount
,ISNULL(@WIPLaborIncomeAccountAmount, 0)	as WIPLaborIncomeAccountAmount
,@WIPLaborWOAccount							as WIPLaborWOAccount
,ISNULL(@WIPLaborWOAccountAmount, 0)		as WIPLaborWOAccountAmount
,ISNULL(@UnbilledLabor, 0)					as UnbilledLabor

,@WIPExpenseAssetAccount					as WIPExpenseAssetAccount
,ISNULL(@WIPExpenseAssetAccountAmount, 0)	as WIPExpenseAssetAccountAmount
,@WIPExpenseIncomeAccount					as WIPExpenseIncomeAccount
,ISNULL(@WIPExpenseIncomeAccountAmount, 0)	as WIPExpenseIncomeAccountAmount
,@WIPExpenseWOAccount						as WIPExpenseWOAccount
,ISNULL(@WIPExpenseWOAccountAmount, 0)		as WIPExpenseWOAccountAmount
,ISNULL(@UnbilledOtherExpenses, 0)			as UnbilledOtherExpenses

,@WIPVoucherAssetAccount					as WIPVoucherAssetAccount
,ISNULL(@WIPVoucherAssetAccountAmount, 0)	as WIPVoucherAssetAccountAmount
,@WIPVoucherIncomeAccount					as WIPVoucherIncomeAccount
,ISNULL(@WIPVoucherIncomeAccountAmount, 0)	as WIPVoucherIncomeAccountAmount
,@WIPVoucherWOAccount						as WIPVoucherWOAccount
,ISNULL(@WIPVoucherWOAccountAmount, 0)		as WIPVoucherWOAccountAmount
,ISNULL(@UnbilledProductionExpenses, 0)		as UnbilledProductionExpenses

,@WIPMediaAssetAccount						as WIPMediaAssetAccount
,ISNULL(@WIPMediaAssetAccountAmount, 0)		as WIPMediaAssetAccountAmount
,@WIPMediaIncomeAccount						as WIPMediaIncomeAccount
,ISNULL(@WIPMediaIncomeAccountAmount, 0)	as WIPMediaIncomeAccountAmount
,@WIPMediaWOAccount							as WIPMediaWOAccount
,ISNULL(@WIPMediaWOAccountAmount, 0)		as WIPMediaWOAccountAmount
,ISNULL(@UnbilledMediaExpenses, 0)			as UnbilledMediaExpenses

	
	RETURN 1
GO
