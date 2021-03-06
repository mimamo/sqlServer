USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectHourlyRealization]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectHourlyRealization]
	@CompanyKey int,
	@ClientKey int,
	@OfficeKey int,
	@ProjectStatusKey int,
	@ClientDivisionKey int,
	@ClientProductKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@UserKey int = null

AS --Encrypt

/*
|| When     Who Rel    What
|| 10/05/06 CRG 8.35   Modified the AmountPrebilled query
|| 07/09/07 GHL 8.5    Addded restriction on ERs
|| 11/28/07 GHL 8.441  (16470) Added ClientKey parameter to reduce # of projects
|| 11/10/09 GHL 10.513 (67846) Split from spRptProjectProfitability to query only what is needed
||                     for this particular report (Project Hourly Realization) 
||                     Performance was too slow
|| 04/01/11 RLB 10.542 (97641) added Labor Income Account total
|| 04/17/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 06/14/12 MFT 10.557 (144371) Added Markup column
|| 08/15/12 MFT 10.558 (151496) Removed out-of-range projects
|| 10/04/12 RLB 10.560 (154307) Changing InvoiceDate to PostingDate On Vouchers and Client Invoices
|| 08/20/13 RLB 10.571 (187381) now pulling invoice lines that at set to use transactions
|| 01/21/14 GHL 10.576 Calculating now in Home Currency
|| 05/07/14 WDF 10.580 (215221) Added ActualBilled
|| 10/20/14 GAR 10.584 (233179) Changed LaborBilled statement to use the tTime.DateBilled
||						instead of the tTime.WorkDate to figure out labor billed.  Also added a check
||						for write offs so we don't include them in hours billed.
|| 11/17/14 GAR	10.586 (236733) t.ProjectKey was missing from LaborBilled query.
*/

	Declare @RestrictToGLCompany int

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
		from tUser u (nolock)
		inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		Where u.UserKey = @UserKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)


create table #project(
	ProjectKey int null
	,ProjectNumber varchar(50) null
	,ProjectName varchar(100) null
	
	-- for group info
	,ClientKey int null
	,ProjectTypeKey int null
	,AccountManager int null
	,CampaignKey int null
	,ClientDivisionKey int null
	,ClientProductKey int null
	
	-- for columns
	,AmountActualBilled money null
	,AmountActualTransactionBilled money null
	,VINet money null
	,ERNet money null
	,MCNet money null
	,GJNet money null
	,Markup money null
	,OtherExpenseNet money null
	,LaborNet money null
	,LaborBilled money null
	,LaborIncomeAccountTotal money null
	,ActualHours decimal(24,4) null
	,Updated bit NOT NULL
	)

create table #tClient (ClientKey int null)
if isnull(@ClientKey,0) > 0
begin
	insert #tClient select @ClientKey
	insert #tClient 
	select CompanyKey from tCompany (nolock) 
	where OwnerCompanyKey = @CompanyKey 
	and ParentCompanyKey = @ClientKey	
end 

if @ProjectStatusKey is null
	select @ProjectStatusKey = -3
		
insert #project (
	ProjectKey
	,ProjectNumber
	,ProjectName
	,ClientKey 
	,ProjectTypeKey 
	,AccountManager 
	,CampaignKey 
	,ClientDivisionKey 
	,ClientProductKey
	,AmountActualBilled
	,AmountActualTransactionBilled
	,VINet
	,ERNet
	,MCNet
	,GJNet
	,Markup
	,OtherExpenseNet
	,LaborNet
	,LaborBilled
	,LaborIncomeAccountTotal
	,ActualHours
	,Updated
	)
select p.ProjectKey
	,p.ProjectNumber
	,p.ProjectName
	,p.ClientKey 
	,p.ProjectTypeKey 
	,p.AccountManager 
	,p.CampaignKey 
	,p.ClientDivisionKey 
	,p.ClientProductKey
	,0,0,0,0,0,0,0,0,0,0,0,0,0
from   tProject p (nolock)
where  p.CompanyKey =	@CompanyKey
and    p.NonBillable = 0
and    (@ClientKey = -1 or p.ClientKey in (select ClientKey from #tClient))
and    (@OfficeKey = -1 or p.OfficeKey = @OfficeKey)
and    (
		@ProjectStatusKey = -3 or 
		(@ProjectStatusKey = -1 and p.Active = 1) or
		(@ProjectStatusKey = -2 and p.Active = 0) or
		(@ProjectStatusKey >0 and p.ProjectStatusKey = @ProjectStatusKey)
		)    
and    (@ClientDivisionKey = -1 or p.ClientDivisionKey = @ClientDivisionKey)
and    (@ClientProductKey = -1 or p.ClientProductKey = @ClientProductKey)
AND    (@RestrictToGLCompany = 0 
		OR p.GLCompanyKey IN (SELECT GLCompanyKey 
			FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )

if @StartDate is null
	Select @StartDate = '1/1/1970'
	
if @EndDate is null
	Select @EndDate = '12/31/2050'

--Billed Nontransaction
UPDATE #project
SET
	AmountActualBilled = TotalAmount,
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			SUM(ROUND(il.TotalAmount * i.ExchangeRate, 2)) AS TotalAmount,
			il.ProjectKey AS ProjectKey
		FROM
			tInvoiceLine il (nolock)
			INNER JOIN tInvoice i (nolock) ON i.InvoiceKey = il.InvoiceKey
	  WHERE
		i.CompanyKey = @CompanyKey AND
	  	i.AdvanceBill = 0 AND
	  	i.PostingDate >= @StartDate AND
	  	i.PostingDate <= @EndDate AND
		il.BillFrom = 1

	  GROUP BY il.ProjectKey
	 ) a ON p.ProjectKey = a.ProjectKey

-- Get All Transtions Billed
-- Time
UPDATE #project
SET
	AmountActualTransactionBilled = ISNULL(AmountActualTransactionBilled, 0)  + TotalAmount,
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			SUM(ROUND(summ.Amount * i.ExchangeRate, 2)) AS TotalAmount,
			summ.ProjectKey AS ProjectKey
		FROM
			tInvoiceLine il (nolock)
			INNER JOIN tInvoice i (nolock) ON i.InvoiceKey = il.InvoiceKey
			INNER JOIN tInvoiceSummary summ (nolock) ON il.InvoiceLineKey = summ.InvoiceLineKey AND summ.Entity = 'tService'
	  WHERE
	  	i.CompanyKey = @CompanyKey AND
	  	i.AdvanceBill = 0 AND
	  	i.PostingDate >= @StartDate AND
	  	i.PostingDate <= @EndDate AND
		il.BillFrom = 2

	  GROUP BY summ.ProjectKey
	 ) a ON p.ProjectKey = a.ProjectKey

-- Expense
UPDATE #project
SET
	AmountActualTransactionBilled = ISNULL(AmountActualTransactionBilled, 0)  + TotalAmount,
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			SUM(ROUND(er.AmountBilled * i.ExchangeRate, 2)) AS TotalAmount, -- could also take er.ExchangeRate
			er.ProjectKey AS ProjectKey
		FROM
			tInvoiceLine il (nolock)
			INNER JOIN tInvoice i (nolock) ON i.InvoiceKey = il.InvoiceKey
			INNER JOIN tExpenseReceipt er (nolock) ON il.InvoiceLineKey = er.InvoiceLineKey
	  WHERE
	  	i.CompanyKey = @CompanyKey AND
	  	i.AdvanceBill = 0 AND
	  	i.PostingDate >= @StartDate AND
	  	i.PostingDate <= @EndDate AND
		il.BillFrom = 2

	  GROUP BY er.ProjectKey
	 ) a ON p.ProjectKey = a.ProjectKey

-- Misc Cost
UPDATE #project
SET
	AmountActualTransactionBilled = ISNULL(AmountActualTransactionBilled, 0)  + TotalAmount,
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			SUM(ROUND(mc.AmountBilled * i.ExchangeRate,2)) AS TotalAmount,
			mc.ProjectKey AS ProjectKey
		FROM
			tInvoiceLine il (nolock)
			INNER JOIN tInvoice i (nolock) ON i.InvoiceKey = il.InvoiceKey
			INNER JOIN tMiscCost mc (nolock) ON il.InvoiceLineKey = mc.InvoiceLineKey
	  WHERE
	  	i.CompanyKey = @CompanyKey AND
	  	i.AdvanceBill = 0 AND
	  	i.PostingDate >= @StartDate AND
	  	i.PostingDate <= @EndDate AND
		il.BillFrom = 2

	  GROUP BY mc.ProjectKey
	 ) a ON p.ProjectKey = a.ProjectKey

-- Voucher
UPDATE #project
SET
	AmountActualTransactionBilled = ISNULL(AmountActualTransactionBilled, 0)  + TotalAmount,
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			SUM(ROUND(vd.AmountBilled * i.ExchangeRate,2)) AS TotalAmount,
			vd.ProjectKey AS ProjectKey
		FROM
			tInvoiceLine il (nolock)
			INNER JOIN tInvoice i (nolock) ON i.InvoiceKey = il.InvoiceKey
			INNER JOIN tVoucherDetail vd (nolock) ON il.InvoiceLineKey = vd.InvoiceLineKey
	  WHERE
	  	i.CompanyKey = @CompanyKey AND
	  	i.AdvanceBill = 0 AND
	  	i.PostingDate >= @StartDate AND
	  	i.PostingDate <= @EndDate AND
		il.BillFrom = 2

	  GROUP BY vd.ProjectKey
	 ) a ON p.ProjectKey = a.ProjectKey

-- PO
UPDATE #project
SET
	AmountActualTransactionBilled = ISNULL(AmountActualTransactionBilled, 0)  + TotalAmount,
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			SUM(ROUND(pod.AmountBilled * i.ExchangeRate, 2)) AS TotalAmount,
			pod.ProjectKey AS ProjectKey
		FROM
			tInvoiceLine il (nolock)
			INNER JOIN tInvoice i (nolock) ON i.InvoiceKey = il.InvoiceKey
			INNER JOIN tPurchaseOrderDetail pod (nolock) ON il.InvoiceLineKey = pod.InvoiceLineKey
	  WHERE
	  	i.CompanyKey = @CompanyKey AND
	  	i.AdvanceBill = 0 AND
	  	i.PostingDate >= @StartDate AND
	  	i.PostingDate <= @EndDate AND
		il.BillFrom = 2

	  GROUP BY pod.ProjectKey
	 ) a ON p.ProjectKey = a.ProjectKey

--Direct Exp
UPDATE #project
SET
	VINet = TotalCost,
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			SUM(ROUND(vd.TotalCost * v.ExchangeRate, 2)) AS TotalCost,
			vd.ProjectKey AS ProjectKey
		FROM
			tVoucherDetail vd (nolock)
			INNER JOIN tVoucher v (nolock) ON v.VoucherKey = vd.VoucherKey
		WHERE
			v.CompanyKey = @CompanyKey AND
	  		v.PostingDate >= @StartDate AND
			v.PostingDate <= @EndDate
		GROUP BY vd.ProjectKey
	) a ON p.ProjectKey = a.ProjectKey

--Markup 1
UPDATE #project
SET
	Markup = ISNULL(p.Markup, 0) + ISNULL(a.Markup,0) ,
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			SUM( ROUND((ISNULL(vd.BillableCost, 0) - ISNULL(vd.PTotalCost, 0) ) * vd.PExchangeRate, 2)) AS Markup,
			vd.ProjectKey AS ProjectKey
		FROM
			tVoucherDetail vd (nolock) 
			INNER JOIN tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
		WHERE
			v.CompanyKey = @CompanyKey AND
	  		v.PostingDate >= @StartDate AND
			v.PostingDate <= @EndDate
		GROUP BY vd.ProjectKey
	) a ON p.ProjectKey = a.ProjectKey

--ERNet
UPDATE #project
SET
	ERNet = ActualCost,
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			SUM(ROUND(er.ActualCost * ee.ExchangeRate,2)) AS ActualCost,
			er.ProjectKey AS ProjectKey
		FROM
			tExpenseReceipt er (nolock)
		INNER JOIN tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey 
		WHERE
			ee.CompanyKey = @CompanyKey AND
	  		er.VoucherDetailKey IS NULL AND
			er.ExpenseDate >= @StartDate AND
			er.ExpenseDate <= @EndDate
		GROUP BY er.ProjectKey
	) a ON p.ProjectKey = a.ProjectKey

--Markup 2
UPDATE #project
SET
	Markup = ISNULL(p.Markup, 0) + ISNULL(a.Markup,0), 
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			SUM( ROUND((ISNULL(er.BillableCost, 0) - ISNULL(er.PTotalCost, 0) ) * er.PExchangeRate,2)) AS Markup,
			er.ProjectKey AS ProjectKey
		FROM tExpenseReceipt er (nolock) 
		INNER JOIN tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey 
		WHERE
			ee.CompanyKey = @CompanyKey AND
			er.VoucherDetailKey IS NULL AND
			er.ExpenseDate >= @StartDate AND
			er.ExpenseDate <= @EndDate 
		GROUP BY er.ProjectKey
	) a ON p.ProjectKey = a.ProjectKey

--MCNet
UPDATE #project
SET
	MCNet = a.TotalCost,
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			SUM(ROUND(mc.TotalCost * mc.ExchangeRate,2)) AS TotalCost,
			mc.ProjectKey AS ProjectKey
		FROM tMiscCost mc (nolock)
		WHERE
			mc.ExpenseDate >= @StartDate AND
			mc.ExpenseDate <= @EndDate
		GROUP BY mc.ProjectKey
	) a ON p.ProjectKey = a.ProjectKey

--Markup 3
UPDATE #project
SET
	Markup = ISNULL(p.Markup, 0) + ISNULL(a.Markup, 0),
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			SUM( ROUND(
				(ISNULL(mc.BillableCost, 0) - ISNULL(mc.TotalCost, 0) ) * mc.ExchangeRate
				,2)) AS Markup,
			mc.ProjectKey AS ProjectKey
		FROM tMiscCost mc (nolock)
		WHERE
			mc.ExpenseDate >= @StartDate AND
			mc.ExpenseDate <= @EndDate
		GROUP BY mc.ProjectKey
	) a ON p.ProjectKey = a.ProjectKey

--GJNet
UPDATE #project
SET
	GJNet = a.GJNet,
	Updated = 1
	FROM
		#project p (nolock)
		INNER JOIN (
			SELECT
				SUM(t.HDebit - t.HCredit) AS GJNet,
				t.ProjectKey AS ProjectKey
		FROM tTransaction t (nolock)
		WHERE
			t.CompanyKey = @CompanyKey AND
			t.Entity = 'GENJRNL' AND
			t.TransactionDate >= @StartDate AND
			t.TransactionDate <= @EndDate
		GROUP BY t.ProjectKey
	) a ON p.ProjectKey = a.ProjectKey

--LaborIncomeAccountTotal
UPDATE #project
SET
	LaborIncomeAccountTotal = a.LaborIncomeAccountTotal,
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			SUM(t.HCredit - t.HDebit) AS LaborIncomeAccountTotal,
			t.ProjectKey AS ProjectKey
		FROM
			tTransaction t (nolock)
			INNER JOIN tGLAccount gla (nolock) ON t.GLAccountKey = gla.GLAccountKey
		WHERE
			gla.LaborIncome = 1 AND
			t.CompanyKey = @CompanyKey AND
			t.TransactionDate >= @StartDate AND
			t.TransactionDate <= @EndDate
		GROUP BY t.ProjectKey
	) a ON p.ProjectKey = a.ProjectKey


--LaborNet, ActualHours
UPDATE #project
SET
	LaborNet = a.LaborNet,
	ActualHours = a.ActualHours,
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			ISNULL(SUM(
			ROUND(t.ActualHours * t.HCostRate, 2) 
			), 0) AS LaborNet,
			ISNULL(SUM(t.ActualHours), 0) AS ActualHours,
			t.ProjectKey AS ProjectKey
		FROM tTime t (nolock)
			INNER JOIN tProject pr (nolock) on t.ProjectKey = pr.ProjectKey
		WHERE
			pr.CompanyKey = @CompanyKey AND
			t.WorkDate >= @StartDate AND
			t.WorkDate <= @EndDate
		GROUP BY t.ProjectKey
	) a ON p.ProjectKey = a.ProjectKey
	
--LaborBilled
UPDATE #project
SET
	LaborBilled = a.LaborBilled,
	Updated = 1
FROM
	#project p (nolock)
	INNER JOIN (
		SELECT
			ISNULL(SUM(
			ROUND(ROUND(t.BilledHours * t.BilledRate, 2) * t.ExchangeRate, 2)
			), 0) AS LaborBilled,
			t.ProjectKey AS ProjectKey
		FROM tTime t (nolock)
			INNER JOIN tProject pr (nolock) on t.ProjectKey = pr.ProjectKey
		WHERE
			pr.CompanyKey = @CompanyKey AND
			t.DateBilled >= @StartDate AND
			t.DateBilled <= @EndDate AND
			t.WriteOff = 0
		GROUP BY t.ProjectKey
	) a ON p.ProjectKey = a.ProjectKey

--OtherExpenseNet
UPDATE #project
SET
	OtherExpenseNet = ISNULL(ERNet, 0) + ISNULL(MCNet, 0) + ISNULL(GJNet, 0)

DELETE FROM #project
WHERE Updated = 0


select
	 p.*
	,ISNULL(p.AmountActualBilled, 0) + ISNULL(p.AmountActualTransactionBilled, 0) AS [ActualBilled]
	,RTRIM(LTRIM(p.ProjectNumber)) + ' - ' + RTRIM(LTRIM(p.ProjectName)) as Project
	,ISNULL(cl.CompanyName, ' No Client') as CompanyName
	,cl.CustomerID as ClientID
	,ISNULL(pcl.CompanyName, ' No Parent Company') as ParentCompanyName
	,pcl.CustomerID as ParentClientID
	,ISNULL(pt.ProjectTypeName, ' No Project Type') as ProjectTypeName
	,ISNULL(cp.CampaignName, ' No Campaign') as CampaignName
	,CASE WHEN p.AccountManager IS NULL THEN ' No Account Manager'
	      ELSE am.FirstName + ' ' + am.LastName
	 END as AccountManagerName
	,ISNULL(div.DivisionName, ' No Division') as DivisionName
	,ISNULL(prod.ProductName, ' No Product') as ProductName
	,ISNULL(ct.CompanyTypeName, ' No Company Type') as CompanyTypeName		    	    
from #project p
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tCompanyType ct (nolock) on cl.CompanyTypeKey = ct.CompanyTypeKey
	left outer join tCompany pcl (nolock) on cl.ParentCompanyKey = pcl.CompanyKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tUser am (nolock) on p.AccountManager = am.UserKey
	left outer join tClientDivision div (nolock) on p.ClientDivisionKey = div.ClientDivisionKey
	left outer join tClientProduct prod (nolock) on p.ClientProductKey = prod.ClientProductKey
GO
