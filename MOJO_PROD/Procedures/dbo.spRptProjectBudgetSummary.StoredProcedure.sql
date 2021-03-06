USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectBudgetSummary]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptProjectBudgetSummary]
(
	@CompanyKey int,
	@EndDate smalldatetime,
	@UserKey int = null
)

AS --Encrypt

/*
  || When     Who Rel     What
  || 10/12/06 WES 8.3567  Added Campaign Name for group by in proj budget summary report
  || 07/29/07 GHL 8.433   Getting now OrdersUnbilled from vPurchaseOrderDetailCosts
  || 07/15/08 GWG 10.005  Added the voucherdetailkey = null for expense reports so they dont get double counted
  || 04/18/12 GHL 10.555  Added UserKey fot tUserGLCompanyAccess
  || 01/17/13 GHL 10.564  (156960) Added AllocatedHours, FutureAllocatedHours, AllocatedGross, FutureAllocatedGross  
  ||                      Future fields are calculated for t.PlanStart >= EndDate (On or later than today)
  */

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

if @EndDate is null 
	Select @EndDate = '12/31/2049'
 
create table #project(ProjectKey int null
		,AllocatedHours decimal(24,4) null
		,FutureAllocatedHours decimal(24,4) null
		,AllocatedGross money null
		,FutureAllocatedGross money null
		)

insert #project (ProjectKey)
select ProjectKey
From   tProject (nolock)
Where  CompanyKey = @CompanyKey and NonBillable = 0 and Closed = 0
	AND (@RestrictToGLCompany = 0 
		OR GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )

update #project
set    #project.AllocatedHours = isnull((
		select SUM(tu.Hours) 
        from   tTaskUser tu (nolock)
        inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
        where t.ProjectKey = #project.ProjectKey
		),0)

update #project
set    #project.FutureAllocatedHours = isnull((
		select SUM(tu.Hours) 
        from   tTaskUser tu (nolock)
        inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
        where t.ProjectKey = #project.ProjectKey
		and   t.PlanStart >= @EndDate
		),0)

update #project
set    #project.AllocatedGross = isnull((
select SUM(tu.Hours * case p.GetRateFrom 
		when 1 then ISNULL(cl.HourlyRate,0)
		when 2 then ISNULL(p.HourlyRate, 0)
		when 3 then ISNULL(a.HourlyRate, 0)
		when 4 then 
			case isnull(u.RateLevel, 1) 
				when 1 then isnull(s.HourlyRate1, 0)
				when 2 then isnull(s.HourlyRate2, 0)
				when 3 then isnull(s.HourlyRate3, 0)
				when 4 then isnull(s.HourlyRate4, 0)
				when 5 then isnull(s.HourlyRate5, 0)
				else isnull(s.HourlyRate1, 0)
			end
			when 5 then 
			case isnull(u.RateLevel, 1) 
				when 1 then isnull(trsd.HourlyRate1, 0)
				when 2 then isnull(trsd.HourlyRate2, 0)
				when 3 then isnull(trsd.HourlyRate3, 0)
				when 4 then isnull(trsd.HourlyRate4, 0)
				when 5 then isnull(trsd.HourlyRate5, 0)
				else isnull(trsd.HourlyRate1, 0)
			end
			when 6 then ISNULL(t.HourlyRate, 0) 
		end
		)
from   tTaskUser tu (nolock)
inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
left join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
left join tUser u (nolock) on tu.UserKey = u.UserKey
left join tService s (nolock) on tu.ServiceKey = s.ServiceKey
left join tAssignment a (nolock) on u.UserKey = a.UserKey and a.ProjectKey = 11 -- Inner join
left join tTimeRateSheet trs (nolock) on p.TimeRateSheetKey = trs.TimeRateSheetKey
left join tTimeRateSheetDetail trsd (nolock) on trs.TimeRateSheetKey = trsd.TimeRateSheetKey and tu.ServiceKey = trsd.ServiceKey 
where t.ProjectKey = #project.ProjectKey
		),0)

update #project
set    #project.FutureAllocatedGross = isnull((
select SUM(tu.Hours * case p.GetRateFrom 
		when 1 then ISNULL(cl.HourlyRate,0)
		when 2 then ISNULL(p.HourlyRate, 0)
		when 3 then ISNULL(a.HourlyRate, 0)
		when 4 then 
			case isnull(u.RateLevel, 1) 
				when 1 then isnull(s.HourlyRate1, 0)
				when 2 then isnull(s.HourlyRate2, 0)
				when 3 then isnull(s.HourlyRate3, 0)
				when 4 then isnull(s.HourlyRate4, 0)
				when 5 then isnull(s.HourlyRate5, 0)
				else isnull(s.HourlyRate1, 0)
			end
			when 5 then 
			case isnull(u.RateLevel, 1) 
				when 1 then isnull(trsd.HourlyRate1, 0)
				when 2 then isnull(trsd.HourlyRate2, 0)
				when 3 then isnull(trsd.HourlyRate3, 0)
				when 4 then isnull(trsd.HourlyRate4, 0)
				when 5 then isnull(trsd.HourlyRate5, 0)
				else isnull(trsd.HourlyRate1, 0)
			end
			when 6 then ISNULL(t.HourlyRate, 0) 
		end
		)
from   tTaskUser tu (nolock)
inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
left join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
left join tUser u (nolock) on tu.UserKey = u.UserKey
left join tService s (nolock) on tu.ServiceKey = s.ServiceKey
left join tAssignment a (nolock) on u.UserKey = a.UserKey and a.ProjectKey = 11 -- Inner join
left join tTimeRateSheet trs (nolock) on p.TimeRateSheetKey = trs.TimeRateSheetKey
left join tTimeRateSheetDetail trsd (nolock) on trs.TimeRateSheetKey = trsd.TimeRateSheetKey and tu.ServiceKey = trsd.ServiceKey 
where t.ProjectKey = #project.ProjectKey
and   t.PlanStart >= @EndDate
		),0)


Select
	 p.ProjectKey
	,#project.*
	,LTRIM(RTRIM(p.ProjectName)) as ProjectName
	,LTRIM(RTRIM(p.ProjectNumber)) as ProjectNumber
	,p.CompanyKey
	,p.Active
	,p.ProjectStatusKey
	,p.ClientKey
	,c.CustomerID + ' - ' +c.CompanyName as CompanyName
	,p.OfficeKey
	,o.OfficeName
	,p.AccountManager
	,p.StatusNotes
	,p.DetailedNotes
	,p.ClientNotes
	,u.FirstName + ' ' + u.LastName as AccountManagerName
	,div.ClientDivisionKey
	,ISNULL(div.DivisionName, ' No Division') as DivisionName
	,prod.ClientProductKey
	,ISNULL(prod.ProductName, ' No Product') as ProductName
	
	,CAST(ISNULL((Select sum(ROUND(ActualHours * ActualRate, 2)) from tTime t (nolock) inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
		Where ts.Status = 4 and t.ProjectKey = p.ProjectKey and WorkDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0) as Money)
	 as LaborUnBilled
	,CAST(ISNULL((Select sum(ROUND(ActualHours * ActualRate, 2)) from tTime t (nolock) inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
		Where ts.Status = 4 and t.ProjectKey = p.ProjectKey and WorkDate <= @EndDate and WriteOff = 1 and DateBilled <= @EndDate), 0) as Money)
	 as LaborWriteOff

	,ISNULL((Select sum(BillableCost) from tExpenseReceipt t (nolock) inner join tExpenseEnvelope ee (nolock) on t.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
		Where ee.Status = 4 and t.ProjectKey = p.ProjectKey and ExpenseDate <= @EndDate and VoucherDetailKey is null and (DateBilled is null Or DateBilled > @EndDate)), 0)
	 as ERUnBilled
	,ISNULL((Select sum(BillableCost) from tExpenseReceipt t (nolock)  inner join tExpenseEnvelope ee (nolock) on t.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
		Where ee.Status = 4 and t.ProjectKey = p.ProjectKey and ExpenseDate <= @EndDate and VoucherDetailKey is null and WriteOff = 1 and DateBilled <= @EndDate), 0)
	 as ERWriteOff

	,ISNULL((Select sum(BillableCost) from tMiscCost t (nolock) Where t.ProjectKey = p.ProjectKey and ExpenseDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0)
	 as MCUnBilled
	,ISNULL((Select sum(BillableCost) from tMiscCost t (nolock) Where t.ProjectKey = p.ProjectKey and ExpenseDate <= @EndDate and WriteOff = 1 and DateBilled <= @EndDate), 0)
	 as MCWriteOff
	
	,ISNULL((Select SUM(BillableCost) from tVoucherDetail vd (nolock), tVoucher v (nolock)
		where v.Status = 4 and vd.ProjectKey = p.ProjectKey and vd.VoucherKey = v.VoucherKey and v.PostingDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0)
	 as VOUnBilled
	,ISNULL((Select SUM(BillableCost) from tVoucherDetail vd (nolock), tVoucher v (nolock)
		where v.Status = 4 and vd.ProjectKey = p.ProjectKey and vd.VoucherKey = v.VoucherKey and v.InvoiceDate <= @EndDate and vd.WriteOff = 1 and DateBilled <= @EndDate), 0)
	 as VOWriteOff
	 
	,ISNULL((
		SELECT SUM(v.OpenUnbilledCost)
		FROM   tPurchaseOrderDetail pod (NOLOCK)
		INNER JOIN vPurchaseOrderDetailCosts v (NOLOCK) ON pod.PurchaseOrderDetailKey = v.PurchaseOrderDetailKey
		INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
		WHERE pod.ProjectKey = p.ProjectKey
		AND   po.Status = 4
		AND   pod.Closed = 0
		AND ( (po.POKind = 0 AND po.PODate <= @EndDate) OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
	),0) AS OrdersUnbilled
	
	-- Budget Tracking
	,ISNULL(p.EstLabor, 0) as EstLabor
	,ISNULL(p.BudgetExpenses, 0) as BudgetExpenses
	,ISNULL(p.EstExpenses, 0) as EstExpenses
	,ISNULL(p.ApprovedCOLabor, 0) as COApprovedLabor
	,ISNULL(p.ApprovedCOExpense, 0) as COApprovedExpense

	,ISNULL((Select sum(ISNULL(TotalAmount, 0))
		from tInvoiceLine il (nolock) 
			INNER JOIN tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
		Where il.ProjectKey = p.ProjectKey and i.InvoiceDate <= @EndDate And i.AdvanceBill = 0) ,0)
	as InvoiceAmount
	,ISNULL((Select sum(ISNULL(TotalAmount, 0))
		from tInvoiceLine il (nolock) 
			INNER JOIN tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
		Where il.ProjectKey = p.ProjectKey and i.InvoiceDate <= @EndDate) ,0)
	as InvoiceAmountWithAdvBill
	,cn.CampaignName as CampaignName

From
	tProject p (nolock)
	LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey
	LEFT OUTER JOIN tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	LEFT OUTER JOIN tUser u (nolock) on p.AccountManager = u.UserKey
	left outer join tClientDivision div (nolock) on p.ClientDivisionKey = div.ClientDivisionKey
	left outer join tClientProduct prod (nolock) on p.ClientProductKey = prod.ClientProductKey
	left outer join tCampaign cn (nolock) on p.CampaignKey = cn.CampaignKey
	inner join #project on p.ProjectKey = #project.ProjectKey
Where
	p.CompanyKey = @CompanyKey and p.NonBillable = 0 and p.Closed = 0
	AND (@RestrictToGLCompany = 0 
		OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
GO
