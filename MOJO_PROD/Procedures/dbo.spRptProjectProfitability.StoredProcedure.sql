USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectProfitability]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptProjectProfitability]
	@CompanyKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@OnTransOrBilled int, -- 1 By Transaction Date, 0 By Date Billed
	@ClientKey int = null,
	@UserKey int = null

AS --Encrypt

/*
|| When     Who Rel   What
|| 10/05/06 CRG 8.35  Modified the AmountPrebilled query
|| 07/09/07 GHL 8.5   Addded restriction on ERs
|| 11/28/07 GHL 8.441 (16470) Added ClientKey parameter to reduce # of projects
|| 04/13/12 GHL 10.555  Added UserKey for UserGLCompanyAccess 
*/
		
DECLARE @ToDate DATETIME
SELECT @ToDate = CONVERT(DATETIME, (CONVERT(VARCHAR(10), GETDATE(), 101)), 101)
		
if @StartDate is null
	Select @StartDate = '1/1/1970'
	
if @EndDate is null
	Select @EndDate = '12/31/2050'

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

create table #tClient (ClientKey int null)
if @ClientKey is not null
begin
	insert #tClient select @ClientKey
	insert #tClient 
	select CompanyKey from tCompany (nolock) 
	where OwnerCompanyKey = @CompanyKey and
	ParentCompanyKey = @ClientKey	
end 

if @OnTransOrBilled = 1
select 
	 p.ProjectNumber
	,p.ProjectName
	,RTRIM(LTRIM(p.ProjectNumber)) + ' - ' + RTRIM(LTRIM(p.ProjectName)) as Project
	,p.Active
	,p.ProjectStatusKey
	,cl.CompanyKey as ClientKey
	,ISNULL(cl.CompanyName, ' No Client') as CompanyName
	,cl.CustomerID as ClientID
	,ISNULL(pcl.CompanyName, ' No Parent Company') as ParentCompanyName
	,pcl.CustomerID as ParentClientID
	,cl.ParentCompanyKey
	,o.OfficeKey
	,ISNULL(o.OfficeName, ' No Office') as OfficeName
	,pt.ProjectTypeKey
	,ISNULL(pt.ProjectTypeName, ' No Project Type') as ProjectTypeName
	,cp.CampaignKey
	,ISNULL(cp.CampaignName, ' No Campaign') as CampaignName
	,p.AccountManager
	,CASE WHEN p.AccountManager IS NULL THEN ' No Account Manager'
	      ELSE am.FirstName + ' ' + am.LastName
	 END as AccountManagerName
	,p.ClientDivisionKey
	,ISNULL(div.DivisionName, ' No Division') as DivisionName
	,p.ClientProductKey
	,ISNULL(prod.ProductName, ' No Product') as ProductName
	,cl.CompanyTypeKey
	,ISNULL(ct.CompanyTypeName, ' No Company Type') as CompanyTypeName	
	,ISNULL(p.EstHours, 0) + ISNULL(p.ApprovedCOHours, 0) as BudgetHours
	,ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) as BudgetLabor
	,ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense, 0) as BudgetExpenses
	,ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense, 0) as Budget
	,ISNULL(ActualHours, 0) as ActualHours
	,ISNULL(LaborGross, 0) as LaborGross
	,ISNULL(LaborNet, 0) as LaborNet
	,ISNULL(ERNet, 0) + ISNULL(MCNet, 0) + ISNULL(VINet, 0) as ExpenseNet
	,ISNULL(ERNet, 0) + ISNULL(MCNet, 0) + ISNULL(GJNet, 0) as OtherExpenseNet
	,ISNULL(ERGross, 0) + ISNULL(MCGross, 0) + ISNULL(VIGross, 0) as ExpenseGross
	,ISNULL(GJNet, 0) as GJNet
	,ISNULL(ERNet, 0) as ERNet
	,ISNULL(ERGross, 0) as ERGross
	,ISNULL(MCNet, 0) as MCNet
	,ISNULL(MCGross, 0) as MCGross
	,ISNULL(VINet, 0) as VINet
	,ISNULL(VINet, 0) as VINetPrebill
	,ISNULL(VIGross, 0) as VIGross
	,ISNULL(LaborNet, 0) + ISNULL(ERNet, 0) + ISNULL(MCNet, 0) + ISNULL(VINet, 0) + ISNULL(GJNet, 0) as TotalNet
	,ISNULL((Select sum(TotalAmount) 
		from tInvoiceLine il (nolock)
		inner join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
	    Where il.ProjectKey = p.ProjectKey and i.AdvanceBill = 1 
	    and i.InvoiceDate >= @StartDate and i.InvoiceDate <= @EndDate), 0) as AmountAdvanceBilled
	,ISNULL((Select sum(TotalAmount) 
		from tInvoiceLine il (nolock)
		inner join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
	    Where il.ProjectKey = p.ProjectKey and i.AdvanceBill = 0 
	    and i.InvoiceDate >= @StartDate and i.InvoiceDate <= @EndDate), 0) as AmountActualBilled
	,ISNULL((Select sum(TotalAmount) 
		from tInvoiceLine il (nolock)
		inner join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
	    Where il.ProjectKey = p.ProjectKey and i.AdvanceBill = 0 
	    and i.InvoiceDate <= @ToDate), 0) as AmountBilledToDate
	,ISNULL((Select sum(ROUND(BilledHours * BilledRate, 2)) 
		from tTime t (nolock)
			inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
			Where ts.CompanyKey = @CompanyKey
			And t.ProjectKey = p.ProjectKey 
			And t.WorkDate >= @StartDate and t.WorkDate <= @EndDate), 0) as LaborBilled
	,ISNULL(
		(SELECT SUM(pod.AccruedCost)
		FROM	tPurchaseOrderDetail pod (nolock)
		INNER JOIN tPurchaseOrder po (nolock) ON pod.PurchaseOrderKey = po.PurchaseOrderKey 
		WHERE	pod.ProjectKey = p.ProjectKey
		AND		po.POKind = 0
		AND		po.PODate >= @StartDate and po.PODate <= @EndDate
		AND		ISNULL(pod.InvoiceLineKey, 0) > 0
		AND		pod.Closed = 0		
		)
	, 0)
	+
	ISNULL(
		(SELECT SUM(pod.AccruedCost)
		FROM	tPurchaseOrderDetail pod (nolock)
		INNER JOIN tPurchaseOrder po (nolock) ON pod.PurchaseOrderKey = po.PurchaseOrderKey 
		WHERE	pod.ProjectKey = p.ProjectKey
		AND		po.POKind > 0
		AND		pod.DetailOrderDate >= @StartDate and pod.DetailOrderDate <= @EndDate
		AND		ISNULL(pod.InvoiceLineKey, 0) > 0 
		AND		pod.Closed = 0
		)
	, 0) As AmountPrebilled  		
/*
	,ISNULL(
		(SELECT SUM(pod.AccruedCost)
		FROM	tPurchaseOrderDetail pod (nolock)
		INNER JOIN tPurchaseOrder po (nolock) ON pod.PurchaseOrderKey = po.PurchaseOrderKey 
		WHERE	pod.ProjectKey = p.ProjectKey
		AND		po.POKind = 0
		AND		po.PODate >= @StartDate and po.PODate <= @EndDate
		AND		ISNULL(pod.InvoiceLineKey, 0) > 0
		AND		pod.PurchaseOrderDetailKey NOT IN
					(SELECT PurchaseOrderDetailKey
					FROM	tVoucherDetail vd (nolock)
					WHERE	vd.ProjectKey = p.ProjectKey)
		)
	, 0)
	+
	ISNULL(
		(SELECT SUM(pod.AccruedCost)
		FROM	tPurchaseOrderDetail pod (nolock)
		INNER JOIN tPurchaseOrder po (nolock) ON pod.PurchaseOrderKey = po.PurchaseOrderKey 
		WHERE	pod.ProjectKey = p.ProjectKey
		AND		po.POKind > 0
		AND		pod.DetailOrderDate >= @StartDate and pod.DetailOrderDate <= @EndDate
		AND		ISNULL(pod.InvoiceLineKey, 0) > 0 
		AND		pod.PurchaseOrderDetailKey NOT IN
					(SELECT PurchaseOrderDetailKey
					FROM	tVoucherDetail vd (nolock)
					WHERE	vd.ProjectKey = p.ProjectKey)
		)
	, 0) As AmountPrebilled   
	,ISNULL(
		(SELECT SUM(vd.TotalCost)
		FROM	tVoucherDetail vd (nolock)
		INNER JOIN tPurchaseOrderDetail pod (nolock) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
		INNER JOIN tVoucher v (nolock) ON vd.VoucherKey = v.VoucherKey
		WHERE	pod.ProjectKey = p.ProjectKey
		AND		v.InvoiceDate >= @StartDate and v.InvoiceDate <= @EndDate
		AND		ISNULL(vd.InvoiceLineKey, 0) > 0), 0) As AmountPrebilledOnVoucher 	
*/
from tProject p (nolock)
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tCompanyType ct (nolock) on cl.CompanyTypeKey = ct.CompanyTypeKey
	left outer join tCompany pcl (nolock) on cl.ParentCompanyKey = pcl.CompanyKey
	left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tUser am (nolock) on p.AccountManager = am.UserKey
	left outer join tClientDivision div (nolock) on p.ClientDivisionKey = div.ClientDivisionKey
	left outer join tClientProduct prod (nolock) on p.ClientProductKey = prod.ClientProductKey
	left outer join (
		Select tTime.ProjectKey
			, Sum(ActualHours) as ActualHours
			, SUM(ROUND(ActualHours * ActualRate, 2)) as LaborGross
			, SUM(ROUND(ActualHours * CostRate, 2)) as LaborNet
		From tTime (nolock) inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
		Where WorkDate >= @StartDate and WorkDate <= @EndDate and tTimeSheet.CompanyKey = @CompanyKey
		Group By tTime.ProjectKey
		) as rptTime on p.ProjectKey = rptTime.ProjectKey
	left outer join (
		Select tExpenseReceipt.ProjectKey, SUM(BillableCost) as ERGross, SUM(ActualCost) as ERNet
		From tExpenseReceipt (nolock) inner join tExpenseEnvelope (nolock) on tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
		Where ExpenseDate >= @StartDate and ExpenseDate <= @EndDate and CompanyKey = @CompanyKey
		And  tExpenseReceipt.VoucherDetailKey is null 
		Group By tExpenseReceipt.ProjectKey) as rptER on p.ProjectKey  = rptER.ProjectKey
	left outer join (
		Select tMiscCost.ProjectKey, SUM(BillableCost) as MCGross, SUM(TotalCost) as MCNet
		From tMiscCost (nolock) inner join tProject (nolock) on tProject.ProjectKey = tMiscCost.ProjectKey
		Where ExpenseDate >= @StartDate and ExpenseDate <= @EndDate and CompanyKey = @CompanyKey
		Group By tMiscCost.ProjectKey) as rptMC on p.ProjectKey = rptMC.ProjectKey
	left outer join (
		Select tVoucherDetail.ProjectKey, SUM(BillableCost) as VIGross, 
		SUM(TotalCost) AS VINet
		From tVoucherDetail (nolock) inner join tVoucher (nolock) on tVoucher.VoucherKey = tVoucherDetail.VoucherKey
		Where InvoiceDate >= @StartDate and InvoiceDate <= @EndDate and CompanyKey = @CompanyKey
		Group By tVoucherDetail.ProjectKey) as rptVI on p.ProjectKey = rptVI.ProjectKey
	left outer join (
		Select tVoucherDetail.ProjectKey, SUM(TotalCost) as VINetPrebill
		From tVoucherDetail (nolock) inner join tVoucher (nolock) on tVoucher.VoucherKey = tVoucherDetail.VoucherKey
		Where InvoiceDate >= @StartDate and InvoiceDate <= @EndDate and CompanyKey = @CompanyKey
		And	PurchaseOrderDetailKey IS NULL
		Group By tVoucherDetail.ProjectKey) as rptVIPrebill on p.ProjectKey = rptVIPrebill.ProjectKey
	LEFT OUTER JOIN (
		Select tTransaction.ProjectKey, SUM(Debit - Credit) AS GJNet 
		from tTransaction (nolock) 
		where Entity = 'GENJRNL' and TransactionDate >= @StartDate and TransactionDate <= @EndDate
		Group By tTransaction.ProjectKey) as rptGJ ON p.ProjectKey = rptGJ.ProjectKey
Where
	p.CompanyKey = @CompanyKey and
	p.NonBillable = 0 and
	(@ClientKey is null or p.ClientKey in (select ClientKey from #tClient))
	AND (@RestrictToGLCompany = 0 
		OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )

else
select 
	 p.ProjectNumber
	,p.ProjectName
	,RTRIM(LTRIM(p.ProjectNumber)) + ' - ' + RTRIM(LTRIM(p.ProjectName)) as Project
	,p.Active
	,p.ProjectStatusKey
	,cl.CompanyKey as ClientKey
	,ISNULL(cl.CompanyName, ' No Client') as CompanyName
	,cl.CustomerID as ClientID
	,ISNULL(pcl.CompanyName, ' No Parent Company') as ParentCompanyName
	,pcl.CustomerID as ParentClientID
	,cl.ParentCompanyKey
	,o.OfficeKey
	,ISNULL(o.OfficeName, ' No Office') as OfficeName
	,pt.ProjectTypeKey
	,ISNULL(pt.ProjectTypeName, ' No Project Type') as ProjectTypeName
	,cp.CampaignKey
	,ISNULL(cp.CampaignName, ' No Campaign') as CampaignName
	,p.AccountManager
	,CASE WHEN p.AccountManager IS NULL THEN ' No Account Manager'
	      ELSE am.FirstName + ' ' + am.LastName
	 END as AccountManagerName
	,p.ClientDivisionKey
	,ISNULL(div.DivisionName, ' No Division') as DivisionName
	,p.ClientProductKey
	,ISNULL(prod.ProductName, ' No Product') as ProductName
	,cl.CompanyTypeKey
	,ISNULL(ct.CompanyTypeName, ' No Company Type') as CompanyTypeName	
	,ISNULL(p.EstHours, 0) + ISNULL(p.ApprovedCOHours, 0) as BudgetHours
	,ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) as BudgetLabor
	,ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense, 0) as BudgetExpenses
	,ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense, 0) as Budget
	,ISNULL(ActualHours, 0) as ActualHours
	,ISNULL(LaborGross, 0) as LaborGross
	,ISNULL(LaborNet, 0) as LaborNet
	,ISNULL(ERNet, 0) + ISNULL(MCNet, 0) + ISNULL(VINet, 0)  as ExpenseNet
	,ISNULL(ERNet, 0) + ISNULL(MCNet, 0) + ISNULL(GJNet, 0) as OtherExpenseNet
	,ISNULL(ERGross, 0) + ISNULL(MCGross, 0) + ISNULL(VIGross, 0) as ExpenseGross
	,ISNULL(GJNet, 0) as GJNet
	,ISNULL(ERNet, 0) as ERNet
	,ISNULL(ERGross, 0) as ERGross
	,ISNULL(MCNet, 0) as MCNet
	,ISNULL(MCGross, 0) as MCGross
	,ISNULL(VINet, 0)  as VINet
	,ISNULL(VINet, 0) as VINetPrebill
	,ISNULL(VIGross, 0) as VIGross
	,ISNULL(LaborNet, 0) + ISNULL(ERNet, 0) + ISNULL(MCNet, 0) + ISNULL(VINet, 0) + ISNULL(GJNet, 0) as TotalNet
	,ISNULL((Select sum(TotalAmount) 
		from tInvoiceLine il (nolock)
		inner join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
	    Where il.ProjectKey = p.ProjectKey and i.AdvanceBill = 1 
	   and i.InvoiceDate >= @StartDate and i.InvoiceDate <= @EndDate), 0) as AmountAdvanceBilled
	,ISNULL((Select sum(TotalAmount) 
		from tInvoiceLine il (nolock)
		inner join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
	    Where il.ProjectKey = p.ProjectKey and i.AdvanceBill = 0 
	    and i.InvoiceDate >= @StartDate and i.InvoiceDate <= @EndDate), 0) as AmountActualBilled
	,ISNULL((Select sum(TotalAmount) 
		from tInvoiceLine il (nolock)
		inner join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
	    Where il.ProjectKey = p.ProjectKey and i.AdvanceBill = 0 
	    and i.InvoiceDate <= @ToDate), 0) as AmountBilledToDate
	,ISNULL((Select sum(ROUND(BilledHours * BilledRate, 2)) 
		from tTime t (nolock)
			inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
			Where ts.CompanyKey = @CompanyKey
			And t.ProjectKey = p.ProjectKey 
			And t.DateBilled >= @StartDate and t.DateBilled <= @EndDate), 0) as LaborBilled
	,ISNULL(
		(SELECT SUM(pod.AccruedCost)
		FROM	tPurchaseOrderDetail pod (nolock)
		WHERE	pod.ProjectKey = p.ProjectKey
		AND		pod.DateBilled >= @StartDate and pod.DateBilled <= @EndDate
		AND		ISNULL(pod.InvoiceLineKey, 0) > 0
		AND		pod.Closed = 0
		)
	, 0) As AmountPrebilled  	
/*
	,ISNULL(
		(SELECT SUM(pod.AccruedCost)
		FROM	tPurchaseOrderDetail pod (nolock)
		WHERE	pod.ProjectKey = p.ProjectKey
		AND		pod.DateBilled >= @StartDate and pod.DateBilled <= @EndDate
		AND		ISNULL(pod.InvoiceLineKey, 0) > 0
		AND		pod.PurchaseOrderDetailKey NOT IN
					(SELECT PurchaseOrderDetailKey
					FROM	tVoucherDetail vd (nolock)
					WHERE	vd.ProjectKey = p.ProjectKey)
		)
	, 0) As AmountPrebilled  	
	,ISNULL(
		(SELECT SUM(vd.TotalCost)
		FROM	tVoucherDetail vd (nolock)
		INNER JOIN tPurchaseOrderDetail pod (nolock) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
		WHERE	pod.ProjectKey = p.ProjectKey
		AND		pod.DateBilled >= @StartDate and pod.DateBilled <= @EndDate
		AND		ISNULL(pod.InvoiceLineKey, 0) > 0 ), 0) As AmountPrebilledOnVoucher 	
*/
from tProject p (nolock)
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tCompanyType ct (nolock) on cl.CompanyTypeKey = ct.CompanyTypeKey
	left outer join tCompany pcl (nolock) on cl.ParentCompanyKey = pcl.CompanyKey
	left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tUser am (nolock) on p.AccountManager = am.UserKey
	left outer join tClientDivision div (nolock) on p.ClientDivisionKey = div.ClientDivisionKey
	left outer join tClientProduct prod (nolock) on p.ClientProductKey = prod.ClientProductKey
	left outer join (
	Select tTime.ProjectKey
		, Sum(ActualHours) as ActualHours
		, SUM(ROUND(ActualHours * ActualRate, 2)) as LaborGross
		, SUM(ROUND(ActualHours * CostRate, 2)) as LaborNet
	From tTime (nolock) inner join tTimeSheet (nolock) on tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
	Where DateBilled >= @StartDate and DateBilled <= @EndDate and tTimeSheet.CompanyKey = @CompanyKey
	Group By tTime.ProjectKey
	) as rptTime on p.ProjectKey = rptTime.ProjectKey
	left outer join (
	Select tExpenseReceipt.ProjectKey, SUM(BillableCost) as ERGross, SUM(ActualCost) as ERNet
	From tExpenseReceipt (nolock) inner join tExpenseEnvelope (nolock) on tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
	Where DateBilled >= @StartDate and DateBilled <= @EndDate and CompanyKey = @CompanyKey
	Group By tExpenseReceipt.ProjectKey) as rptER on p.ProjectKey  = rptER.ProjectKey
	left outer join (
	Select tMiscCost.ProjectKey, SUM(BillableCost) as MCGross, SUM(TotalCost) as MCNet
	From tMiscCost (nolock) inner join tProject (nolock) on tProject.ProjectKey = tMiscCost.ProjectKey
	Where DateBilled >= @StartDate and DateBilled <= @EndDate and CompanyKey = @CompanyKey
	Group By tMiscCost.ProjectKey) as rptMC on p.ProjectKey = rptMC.ProjectKey
	left outer join (
		Select tVoucherDetail.ProjectKey, SUM(BillableCost) as VIGross, SUM(TotalCost) as VINet
		From tVoucherDetail (nolock) inner join tVoucher (nolock) on tVoucher.VoucherKey = tVoucherDetail.VoucherKey
		Where DateBilled >= @StartDate and DateBilled <= @EndDate and CompanyKey = @CompanyKey
		Group By tVoucherDetail.ProjectKey) as rptVI on p.ProjectKey = rptVI.ProjectKey
	left outer join (
		Select tVoucherDetail.ProjectKey, SUM(TotalCost) as VINetPrebill
		From tVoucherDetail (nolock) inner join tVoucher (nolock) on tVoucher.VoucherKey = tVoucherDetail.VoucherKey
		Where DateBilled >= @StartDate and DateBilled <= @EndDate and CompanyKey = @CompanyKey
		And	PurchaseOrderDetailKey IS NULL
		Group By tVoucherDetail.ProjectKey) as rptVIPrebill on p.ProjectKey = rptVIPrebill.ProjectKey
	LEFT OUTER JOIN (
		Select tTransaction.ProjectKey, SUM(Debit - Credit) AS GJNet 
		from tTransaction (nolock) 
		where Entity = 'GENJRNL' and TransactionDate >= @StartDate and TransactionDate <= @EndDate
		Group By tTransaction.ProjectKey) as rptGJ ON p.ProjectKey = rptGJ.ProjectKey
Where
	p.CompanyKey = @CompanyKey and
	p.NonBillable = 0 and
	(@ClientKey is null or p.ClientKey in (select ClientKey from #tClient))
	AND (@RestrictToGLCompany = 0 
		OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
GO
