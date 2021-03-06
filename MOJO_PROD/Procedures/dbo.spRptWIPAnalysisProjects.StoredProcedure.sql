USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptWIPAnalysisProjects]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptWIPAnalysisProjects]
	(
		@CompanyKey INT
		,@AsOfDate SMALLDATETIME
		,@GLCompanyKey INT		-- -1 All, 0 NULL, >0 valid GLCompany
		,@OfficeKey INT			-- -1 All, 0 NULL, >0 valid Office
		,@ClientKey INT			-- -1 All, 0 NULL, >0 valid Client
		,@AccountManager INT

		,@WIPAgingType INT=0      -- 0: None, 1:Labor, 2:Production, 3:Media, 4:Other
		,@Days1 INT = 30
		,@Days2 INT = 60
		,@Days3 INT = 90

		,@UserKey INT = null
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 08/27/07 GHL 8.5  Creation for new WIP analysis report           
  || 10/30/07 GHL 8.5  Fixed bugs during testing      
  || 11/02/07 GHL 8.5  Deleted projects where all is zero
  || 11/09/07 GHL 8.5  Removed where clauses to entity wip	
  || 01/25/08 GHL 8.503 Changed subqueries by Insert/GroupBy then derived table
  || 05/14/08 GHL 8.510 Deleting now projects where all fields are 0 not only the Total
  || 10/15/10 GHL 10.535 Added Aging section  
  || 10/28/10 GHL 10.537 Corrected wip asset accounts for Production and Other expenses
  || 04/12/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
  */
  
	SET NOCOUNT ON
	
-- Get Default Accounts
Declare @WIPLaborAssetAccountKey int
Declare @WIPExpenseAssetAccountKey int
Declare @WIPMediaAssetAccountKey int
Declare @WIPVoucherAssetAccountKey int
Declare @AgingAccountKey int

Select
	@WIPLaborAssetAccountKey = ISNULL(WIPLaborAssetAccountKey, 0),
	@WIPExpenseAssetAccountKey = ISNULL(WIPExpenseAssetAccountKey, 0),
	@WIPMediaAssetAccountKey = ISNULL(WIPMediaAssetAccountKey, 0),
	@WIPVoucherAssetAccountKey = ISNULL(WIPVoucherAssetAccountKey, 0)
from tPreference (nolock) 
Where CompanyKey = @CompanyKey

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

/*
Flash screen says

AgingType = 1 Labor
AgingType = 2 Production
AgingType = 3 Media
AgingType = 4 Other

UnbilledLabor				linked to @WIPLaborAssetAccountKey
UnbilledProduction			linked to @WIPVoucherAssetAccountKey
UnbilledMedia				linked to @WIPMediaAssetAccountKey
UnbilledOther				linked to @WIPExpenseAssetAccountKey

so link to proper wip asset account below

*/

IF @WIPAgingType = 1	SELECT @AgingAccountKey = @WIPLaborAssetAccountKey
IF @WIPAgingType = 2	SELECT @AgingAccountKey = @WIPVoucherAssetAccountKey
IF @WIPAgingType = 3	SELECT @AgingAccountKey = @WIPMediaAssetAccountKey
IF @WIPAgingType = 4	SELECT @AgingAccountKey = @WIPExpenseAssetAccountKey
IF @AgingAccountKey IS NULL		
	SELECT @WIPAgingType = 0

CREATE TABLE #WIPAnalysis(ProjectKey INT NULL 
			, UnbilledLabor MONEY NULL, UnbilledProductionExpenses MONEY NULL
			, UnbilledMediaExpenses MONEY NULL, UnbilledOtherExpenses MONEY NULL
			) 
 
CREATE TABLE #WIPAging(ProjectKey INT NULL 
			, Unbilled30 MONEY NULL, Unbilled60 MONEY NULL
			, Unbilled90 MONEY NULL, Unbilled90P MONEY NULL
			) 

CREATE TABLE #aging (ProjectKey int, Amount money null, UnbilledBucket int null)

-- Get total UnbilledLabor
INSERT #WIPAnalysis (ProjectKey, UnbilledLabor, UnbilledProductionExpenses
		,UnbilledMediaExpenses ,UnbilledOtherExpenses)
SELECT ISNULL(gl.ProjectKey, 0), SUM(gl.Debit - gl.Credit), 0, 0, 0
FROM   tTransaction gl (NOLOCK)
LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
WHERE  gl.CompanyKey = @CompanyKey
AND    gl.TransactionDate <= @AsOfDate
--AND    gl.Entity = 'WIP'
AND    gl.GLAccountKey = @WIPLaborAssetAccountKey
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
group by ISNULL(gl.ProjectKey, 0)

									
-- Get total UnbilledProductionExpenses
INSERT #WIPAnalysis (ProjectKey, UnbilledLabor, UnbilledProductionExpenses
		,UnbilledMediaExpenses ,UnbilledOtherExpenses)
SELECT ISNULL(gl.ProjectKey, 0), 0, SUM(gl.Debit - gl.Credit), 0, 0
FROM   tTransaction gl (NOLOCK)
LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
WHERE  gl.CompanyKey = @CompanyKey
AND    gl.TransactionDate <= @AsOfDate
--AND    gl.Entity = 'WIP'
AND    gl.GLAccountKey = @WIPVoucherAssetAccountKey
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
group by ISNULL(gl.ProjectKey, 0)


-- Get total UnbilledMediaExpenses
INSERT #WIPAnalysis (ProjectKey, UnbilledLabor, UnbilledProductionExpenses
		,UnbilledMediaExpenses ,UnbilledOtherExpenses)
SELECT ISNULL(gl.ProjectKey, 0), 0, 0, SUM(gl.Debit - gl.Credit), 0
FROM   tTransaction gl (NOLOCK)
LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
WHERE  gl.CompanyKey = @CompanyKey
AND    gl.TransactionDate <= @AsOfDate
--AND    gl.Entity = 'WIP'
AND    gl.GLAccountKey = @WIPMediaAssetAccountKey
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
group by ISNULL(gl.ProjectKey, 0)

-- Get total UnbilledOtherExpenses
INSERT #WIPAnalysis (ProjectKey, UnbilledLabor, UnbilledProductionExpenses
		,UnbilledMediaExpenses ,UnbilledOtherExpenses)
SELECT ISNULL(gl.ProjectKey, 0), 0, 0, 0, SUM(gl.Debit - gl.Credit)
FROM   tTransaction gl (NOLOCK)
LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
WHERE  gl.CompanyKey = @CompanyKey
AND    gl.TransactionDate <= @AsOfDate
--AND    gl.Entity = 'WIP'
AND    gl.GLAccountKey = @WIPExpenseAssetAccountKey
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
group by ISNULL(gl.ProjectKey, 0)
			

IF @WIPAgingType = 1 -- Labor
BEGIN
	
	insert #aging (ProjectKey, Amount, UnbilledBucket)

	select ProjectKey, sum(Amount), UnbilledBucket
	from (
	select  isnull(gl.ProjectKey,0) as ProjectKey
		   ,case when gl.PostSide = 'D' then wpd.Amount else -1*wpd.Amount end as Amount
		   ,case when datediff(d, t.WorkDate, @AsOfDate) <= @Days1 then 30
				 when datediff(d, t.WorkDate, @AsOfDate) > @Days1 and datediff(d, t.WorkDate, @AsOfDate) <= @Days2 then 60
				 when datediff(d, t.WorkDate, @AsOfDate) > @Days2 and datediff(d, t.WorkDate, @AsOfDate) <= @Days3 then 90
				 when datediff(d, t.WorkDate, @AsOfDate) > @Days3 then 99
			 end as UnbilledBucket    
	from   tTransaction gl (nolock)
	inner join tWIPPostingDetail wpd (nolock) on gl.TransactionKey = wpd.TransactionKey
	inner join tTime t (nolock) on wpd.UIDEntityKey = t.TimeKey
	LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity = 'WIP'
	AND    gl.GLAccountKey = @AgingAccountKey
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

		) as wipaging
	group by ProjectKey, UnbilledBucket

END


IF @WIPAgingType > 1 -- expenses
BEGIN
	
	insert #aging (ProjectKey, Amount, UnbilledBucket)

	select ProjectKey, sum(Amount), UnbilledBucket
	from (
	
	select  isnull(gl.ProjectKey,0) as ProjectKey
		   ,case when gl.PostSide = 'D' then wpd.Amount else -1*wpd.Amount end as Amount
		   ,case when datediff(d, t.ExpenseDate, @AsOfDate) <= @Days1 then 30
				 when datediff(d, t.ExpenseDate, @AsOfDate) > @Days1 and datediff(d, t.ExpenseDate, @AsOfDate) <= @Days2 then 60
				 when datediff(d, t.ExpenseDate, @AsOfDate) > @Days2 and datediff(d, t.ExpenseDate, @AsOfDate) <= @Days3 then 90
				 when datediff(d, t.ExpenseDate, @AsOfDate) > @Days3 then 99
			 end as UnbilledBucket    
	from   tTransaction gl (nolock)
	inner join tWIPPostingDetail wpd (nolock) on gl.TransactionKey = wpd.TransactionKey
	inner join tMiscCost t (nolock) on wpd.EntityKey = t.MiscCostKey
	LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity = 'WIP'
	AND    gl.GLAccountKey = @AgingAccountKey
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
	AND    wpd.Entity = 'tMiscCost'

	UNION ALL

	select  isnull(gl.ProjectKey,0) as ProjectKey
		   ,case when gl.PostSide = 'D' then wpd.Amount else -1*wpd.Amount end as Amount
		   ,case when datediff(d, v.InvoiceDate, @AsOfDate) <= @Days1 then 30
				 when datediff(d, v.InvoiceDate, @AsOfDate) > @Days1 and datediff(d, v.InvoiceDate, @AsOfDate) <= @Days2 then 60
				 when datediff(d, v.InvoiceDate, @AsOfDate) > @Days2 and datediff(d, v.InvoiceDate, @AsOfDate) <= @Days3 then 90
				 when datediff(d, v.InvoiceDate, @AsOfDate) > @Days3 then 99
			 end as UnbilledBucket    
	from   tTransaction gl (nolock)
	inner join tWIPPostingDetail wpd (nolock) on gl.TransactionKey = wpd.TransactionKey
	inner join tVoucherDetail t (nolock) on wpd.EntityKey = t.VoucherDetailKey
	inner join tVoucher v (nolock) on t.VoucherKey = v.VoucherKey
	LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity = 'WIP'
	AND    gl.GLAccountKey = @AgingAccountKey
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
	AND    wpd.Entity = 'tVoucherDetail'

	UNION ALL

	select  isnull(gl.ProjectKey,0) as ProjectKey
		   ,case when gl.PostSide = 'D' then wpd.Amount else -1*wpd.Amount end as Amount
		   ,case when datediff(d, t.ExpenseDate, @AsOfDate) <= @Days1 then 30
				 when datediff(d, t.ExpenseDate, @AsOfDate) > @Days1 and datediff(d, t.ExpenseDate, @AsOfDate) <= @Days2 then 60
				 when datediff(d, t.ExpenseDate, @AsOfDate) > @Days2 and datediff(d, t.ExpenseDate, @AsOfDate) <= @Days3 then 90
				 when datediff(d, t.ExpenseDate, @AsOfDate) > @Days3 then 99
			 end as UnbilledBucket    
	from   tTransaction gl (nolock)
	inner join tWIPPostingDetail wpd (nolock) on gl.TransactionKey = wpd.TransactionKey
	inner join tExpenseReceipt t (nolock) on wpd.EntityKey = t.ExpenseReceiptKey
	LEFT OUTER JOIN tProject p (NOLOCK) ON gl.ProjectKey = p.ProjectKey
	WHERE  gl.CompanyKey = @CompanyKey
	AND    gl.TransactionDate <= @AsOfDate
	--AND    gl.Entity = 'WIP'
	AND    gl.GLAccountKey = @AgingAccountKey
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
	AND    wpd.Entity = 'tExpenseReceipt'

		) as wipaging
	group by ProjectKey, UnbilledBucket



END
 


insert #WIPAging (ProjectKey)
select DISTINCT ProjectKey FROM #aging

update #WIPAging
set    #WIPAging.Unbilled30 = ISNULL((
	select SUM(Amount) from #aging b where b.ProjectKey = #WIPAging.ProjectKey And UnbilledBucket = 30
	),0)
update #WIPAging
set    #WIPAging.Unbilled60 = ISNULL((
	select SUM(Amount) from #aging b where b.ProjectKey = #WIPAging.ProjectKey And UnbilledBucket = 60
	),0)
update #WIPAging
set    #WIPAging.Unbilled90 = ISNULL((
	select SUM(Amount) from #aging b where b.ProjectKey = #WIPAging.ProjectKey And UnbilledBucket = 90
	),0)
update #WIPAging
set    #WIPAging.Unbilled90P = ISNULL((
	select SUM(Amount) from #aging b where b.ProjectKey = #WIPAging.ProjectKey And UnbilledBucket = 99
	),0)


-- Use a derived table to get 1 record per project
SELECT 
		-- The reason why I set the ProjectKey = -1 is to distinguish from group rows on the flex grid
		CASE WHEN wip.ProjectKey = 0 THEN -1 ELSE wip.ProjectKey END			AS ProjectKey
		
		,ISNULL(p.ProjectNumber, '[NO PROJECT]')								AS ProjectNumber
		,ISNULL(p.ProjectName, '[NO PROJECT]')									AS ProjectName
		,ISNULL(RTRIM(p.ProjectNumber) + ' - ' +p.ProjectName, '[NO PROJECT]')	AS ProjectFullName
		,ISNULL(glc.GLCompanyName, '[NO COMPANY]')								AS GLCompanyName
		,ISNULL(o.OfficeName,'[NO OFFICE]')										AS OfficeName
		,ISNULL(u.FirstName + ' ' + u.LastName, '[NO ACCOUNT MANAGER]')			AS AccountManagerName
		,ISNULL(c.CustomerID, '[NO CLIENT]')									AS ClientID
		,ISNULL(c.CompanyName, '[NO CLIENT]')									AS CompanyName
		,ISNULL(c.CustomerID + ' - ' +c.CompanyName, '[NO CLIENT]') 			AS ClientFullName
		
		,wip.UnbilledLabor
		,wip.UnbilledProductionExpenses
		,wip.UnbilledMediaExpenses
		,wip.UnbilledOtherExpenses
		,wip.UnbilledTotal
		
		,isnull(ag.Unbilled30, 0) as Unbilled30
		,isnull(ag.Unbilled60, 0) as Unbilled60
		,isnull(ag.Unbilled90, 0) as Unbilled90
		,isnull(ag.Unbilled90P, 0) as Unbilled90P
			
FROM
	(SELECT ProjectKey 
		,Sum(UnbilledLabor)										As UnbilledLabor
		,Sum(UnbilledProductionExpenses)						As UnbilledProductionExpenses
		,Sum(UnbilledMediaExpenses)								As UnbilledMediaExpenses
		,Sum(UnbilledOtherExpenses)								As UnbilledOtherExpenses
		,Sum(UnbilledLabor) + Sum(UnbilledProductionExpenses)  
		 + Sum(UnbilledMediaExpenses) + Sum(UnbilledOtherExpenses)	As UnbilledTotal
	FROM #WIPAnalysis
	GROUP BY ProjectKey
		 ) AS wip
	LEFT OUTER JOIN tProject p (NOLOCK) ON wip.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tGLCompany glc (NOLOCK) ON p.GLCompanyKey = glc.GLCompanyKey
	LEFT OUTER JOIN tOffice o (NOLOCK) ON p.OfficeKey = o.OfficeKey
	LEFT OUTER JOIN tCompany c (NOLOCK) ON p.ClientKey = c.CompanyKey
	LEFT OUTER JOIN tUser u (NOLOCK) ON p.AccountManager = u.UserKey

	LEFT OUTER JOIN #WIPAging ag ON wip.ProjectKey = ag.ProjectKey

WHERE (wip.UnbilledLabor <> 0 OR wip.UnbilledProductionExpenses <> 0
		OR wip.UnbilledMediaExpenses <> 0 OR wip.UnbilledOtherExpenses <> 0)		 
ORDER BY ISNULL(p.ProjectNumber, '[NO PROJECT]')		
	

	RETURN 1
GO
