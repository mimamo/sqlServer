USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectWip]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptProjectWip]
(
	@CompanyKey int,
	@EndDate smalldatetime,
	@UserKey int = null
)
AS --Encrypt

  /*
  || When     Who Rel	   What
  || 06/22/07 GHL 8.43     Excluding now projects on retainers for labor, misc cost, exp receipts
  || 07/01/07 GWG 8.431    Excluding voucher cost where PO was prebilled
  || 07/09/07 GHL 8.5      Added restriction on ERs
  || 07/30/07 GHL 8.5      Refining now retainer projects by looking now at tRetainerItems
  ||                       Using a temp table, because subqueries were taking too long
  || 12/12/07 GHL 8.5      (17265) Added check of Closed projects
  || 01/14/08 GHL 8.5      (18753) Added vouchers
  || 07/09/08 GHL 8.515	   (29816) Reading now tTime records into a temp table to increase perfo
  ||			   Also reading now tInvoiceSummary instead of tInvoiceLine
  || 02/12/09 MFT 10.0.1.9 (46566) Changed InvoiceDate to PostingDate for invoice and voucher info comparisons
  || 11/02/10 GHL 10.0537  (93562) Removed Table Scan on tTime. Increased performance 10 fold on tTime queries by performing 3 queries
  ||                       1) DateBilled = null 2) DateBilled > End Date and WriteOff = 0 3) DateBilled <= End Date and WriteOff = 1
  ||                       then using TimeKey to get to the other fields 
  || 04/18/12 GHL 10.5555  Added UserKey from tUserGLCompanyAccess
  */  
  
if @EndDate is null 
	Select @EndDate = '12/31/2049'
 
Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

CREATE TABLE #tProjectWIP (
	ProjectKey INT NULL
	,ProjectName VARCHAR(100) NULL
	,ProjectNumber VARCHAR(50) NULL
	,RetainerKey INT NULL
	,IncludeLabor INT NULL
	,IncludeExpense INT NULL
	
	,CompanyKey INT NULL
	,Active INT NULL
	,ProjectStatusKey INT NULL
	,ClientKey INT NULL
	,CompanyName VARCHAR(255) NULL
	,OfficeKey INT NULL
	,OfficeName VARCHAR(200) NULL
	,AccountManager INT NULL
	,AccountManagerName	VARCHAR(255) NULL
	,ClientDivisionKey INT NULL
	,DivisionName VARCHAR(300) NULL
	,ClientProductKey INT NULL
	,ProductName VARCHAR(300) NULL
	
	,LaborUnBilled MONEY NULL
	,LaborUnBilledCost MONEY NULL
	,LaborWriteOff MONEY NULL
	,ERUnBilled MONEY NULL
	,ERUnBilledCost MONEY NULL
	,ERWriteOff MONEY NULL
	,MCUnBilled MONEY NULL
	,MCUnBilledCost MONEY NULL
	,MCWriteOff MONEY NULL
	,VOUnBilled MONEY NULL
	,VOUnBilledCost MONEY NULL
	,VOWriteOff MONEY NULL
	
	,EstLabor MONEY NULL
	,BudgetExpenses MONEY NULL
	,EstExpenses MONEY NULL
	,COApprovedLabor MONEY NULL
	,COApprovedExpense MONEY NULL
	
	,InvoiceAmount MONEY NULL
	,InvoiceAmountWithAdvBill MONEY NULL
	
) 
 
CREATE TABLE #tTime (
	TimeKey uniqueidentifier 
	,ProjectKey INT NULL
	,RetainerKey INT NULL
	,TimeSheetKey INT NUll
	,ServiceKey INT NULL
	,WorkDate SMALLDATETIME NULL
	,DateBilled SMALLDATETIME NULL
	,WriteOff TINYINT NULL
	,ActualHours DECIMAL(24,4) NULL			
    ,ActualRate MONEY NULL
    ,CostRate MONEY NULL
    ,UpdateFlag int null
    )
    
-- create index to speed up queries
CREATE CLUSTERED INDEX [IX_tProjectWIP_Temp1] ON #tProjectWIP(ProjectKey)
CREATE CLUSTERED INDEX [IX_tProjectWIP_Temp2] ON #tTime(ProjectKey)
    
 
INSERT #tProjectWIP (
	ProjectKey,ProjectName,ProjectNumber,RetainerKey,CompanyKey,Active,ProjectStatusKey,ClientKey,CompanyName 
	,OfficeKey,OfficeName,AccountManager,AccountManagerName,ClientDivisionKey,DivisionName,ClientProductKey,ProductName 
	,LaborUnBilled,LaborUnBilledCost,LaborWriteOff,ERUnBilled,ERUnBilledCost,ERWriteOff
	,MCUnBilled,MCUnBilledCost,MCWriteOff,VOUnBilled,VOUnBilledCost,VOWriteOff 
	,EstLabor,BudgetExpenses,EstExpenses,COApprovedLabor,COApprovedExpense ,InvoiceAmount,InvoiceAmountWithAdvBill
	)

Select
	 p.ProjectKey
	,LTRIM(RTRIM(p.ProjectName)) as ProjectName
	,LTRIM(RTRIM(p.ProjectNumber)) as ProjectNumber
	,ISNULL(p.RetainerKey, 0) --, ISNULL(r.IncludeLabor, 0), ISNULL(r.IncludeExpense, 0)
	,p.CompanyKey
	,p.Active
	,p.ProjectStatusKey
	,p.ClientKey
	,c.CustomerID + ' - ' +c.CompanyName as CompanyName
	,p.OfficeKey
	,o.OfficeName
	,p.AccountManager
	,u.FirstName + ' ' + u.LastName as AccountManagerName
	,div.ClientDivisionKey
	,ISNULL(div.DivisionName, ' No Division') as DivisionName
	,prod.ClientProductKey
	,ISNULL(prod.ProductName, ' No Product') as ProductName
	
	,0,0,0,0,0,0,0,0,0,0,0,0
	
	-- Budget Tracking
	,ISNULL(p.EstLabor, 0) as EstLabor
	,ISNULL(p.BudgetExpenses, 0) as BudgetExpenses
	,ISNULL(p.EstExpenses, 0) as EstExpenses
	,ISNULL(p.ApprovedCOLabor, 0) as COApprovedLabor
	,ISNULL(p.ApprovedCOExpense, 0) as COApprovedExpense

	,0,0

From
	tProject p (nolock)
	LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey
	LEFT OUTER JOIN tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	LEFT OUTER JOIN tUser u (nolock) on p.AccountManager = u.UserKey
	left outer join tClientDivision div (nolock) on p.ClientDivisionKey = div.ClientDivisionKey
	left outer join tClientProduct prod (nolock) on p.ClientProductKey = prod.ClientProductKey
Where
	p.CompanyKey = @CompanyKey and p.NonBillable = 0 and p.Closed = 0
	AND (@RestrictToGLCompany = 0 
		OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
	

/*  This query generates a Table Scan and can last 2 minutes

INSERT #tTime (ProjectKey,RetainerKey,ServiceKey,WorkDate,DateBilled,WriteOff,ActualHours,ActualRate,CostRate)
select t.ProjectKey, p.RetainerKey, t.ServiceKey, t.WorkDate, t.DateBilled
	, t.WriteOff, t.ActualHours, t.ActualRate, t.CostRate
from   tTime t (nolock)
inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
where p.CompanyKey = @CompanyKey
and p.NonBillable = 0
and p.Closed = 0 
and ts.CompanyKey = @CompanyKey
and ts.Status = 4
and t.WorkDate <= @EndDate

DELETE #tTime 
WHERE ISNULL(RetainerKey, 0) > 0
AND ServiceKey NOT IN (SELECT EntityKey FROM tRetainerItems ri (NOLOCK)
								 WHERE ri.RetainerKey = #tTime.RetainerKey
								 AND   ri.Entity = 'tService')  
*/

-- the following queries in tTime should take around 15 second

--1) Pull unbilled time entries    
-- use IX_tTime_16 = ProjectKey, DateBilled, TimeSheetKey, UserKey, ServiceKey, WorkDate
INSERT #tTime (TimeKey, ProjectKey, RetainerKey, TimeSheetKey, DateBilled, ServiceKey, WorkDate, WriteOff, UpdateFlag)
select t.TimeKey, p.ProjectKey, p.RetainerKey, t.TimeSheetKey, t.DateBilled, t.ServiceKey, t.WorkDate
	, 0  -- no need to pull WriteOff (save on query time), I know it is 0 if not billed
	, 0  -- indicate first and second pull 
from   tTime t with (index=IX_tTime_16,nolock)
inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
where p.CompanyKey = @CompanyKey
and p.NonBillable = 0
and p.Closed = 0 
and  t.DateBilled is null   


--2) Pull billed time entries with date billed in the future, should not be too larger    
-- use IX_tTime_16 = ProjectKey, DateBilled, TimeSheetKey, UserKey, ServiceKey, WorkDate
INSERT #tTime (TimeKey, ProjectKey, RetainerKey, TimeSheetKey, DateBilled, ServiceKey, WorkDate, WriteOff, UpdateFlag)
select t.TimeKey, p.ProjectKey, p.RetainerKey, t.TimeSheetKey, t.DateBilled, t.ServiceKey, t.WorkDate
	, 0  
	, 0  -- indicate first and second pull
from   tTime t with (index=IX_tTime_16,nolock)
inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
where p.CompanyKey = @CompanyKey
and p.NonBillable = 0
and p.Closed = 0 
and  t.DateBilled > @EndDate    
and t.WriteOff = 0


delete #tTime where WorkDate > @EndDate

DELETE #tTime 
WHERE ISNULL(RetainerKey, 0) > 0
AND ServiceKey NOT IN (SELECT EntityKey FROM tRetainerItems ri (NOLOCK)
								 WHERE ri.RetainerKey = #tTime.RetainerKey
								 AND   ri.Entity = 'tService')  

-- flag if not approved
update #tTime
set    #tTime.UpdateFlag = 1
from   tTimeSheet ts (nolock)
where  #tTime.TimeSheetKey = ts.TimeSheetKey
and    ts.Status < 4

-- delete if not approved
delete  #tTime where UpdateFlag = 1


--3) Pull writen off time entries, we should have a very small number of records
-- use IX_tTime_9, we have everything we need except TimeSheetKey, but since they have been written off, I know that they are approved
-- except WorkDate
INSERT #tTime (TimeKey, ProjectKey, RetainerKey, TimeSheetKey, ServiceKey, WriteOff, DateBilled, ActualHours, ActualRate, CostRate, UpdateFlag)
select t.TimeKey, p.ProjectKey, p.RetainerKey, 1, t.ServiceKey, 1, t.DateBilled, t.ActualHours, t.ActualRate, t.CostRate 
	, 1  -- indicate third pull
from   tTime t (nolock)
inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
where p.CompanyKey = @CompanyKey
and p.NonBillable = 0
and p.Closed = 0 
and  t.DateBilled <= @EndDate    
and t.WriteOff = 1

DELETE #tTime 
WHERE ISNULL(RetainerKey, 0) > 0
AND ServiceKey NOT IN (SELECT EntityKey FROM tRetainerItems ri (NOLOCK)
								 WHERE ri.RetainerKey = #tTime.RetainerKey
								 AND   ri.Entity = 'tService')  



-- for the first and second pull, we need	ActualHours, ActualRate, CostRate							 

update #tTime
set    #tTime.ActualHours = t.ActualHours
      ,#tTime.ActualRate = t.ActualRate
      ,#tTime.CostRate = t.CostRate
from   tTime t (nolock)
where  #tTime.TimeKey = t.TimeKey
and    #tTime.UpdateFlag = 0     								 

-- for the third pull we need WorkDate

update #tTime
set    #tTime.WorkDate = t.WorkDate
from   tTime t (nolock)
where  #tTime.TimeKey = t.TimeKey
and    #tTime.UpdateFlag = 1     	

delete  #tTime where UpdateFlag = 1 and WorkDate > @EndDate


-- END QUERIES IN tTime

-- Invoiced info 
UPDATE #tProjectWIP
SET    #tProjectWIP.InvoiceAmount =
		ISNULL((Select sum(ISNULL(Amount, 0))
		from tInvoiceSummary isum (nolock) 
			INNER JOIN tInvoice i (nolock) on i.InvoiceKey = isum.InvoiceKey
		Where isum.ProjectKey = #tProjectWIP.ProjectKey and i.PostingDate <= @EndDate And i.AdvanceBill = 0) ,0)
	
UPDATE #tProjectWIP
SET    #tProjectWIP.InvoiceAmountWithAdvBill =
		ISNULL((Select sum(ISNULL(Amount, 0))
		from tInvoiceSummary isum (nolock) 
			INNER JOIN tInvoice i (nolock) on i.InvoiceKey = isum.InvoiceKey
		Where isum.ProjectKey = #tProjectWIP.ProjectKey and i.PostingDate <= @EndDate) ,0)
	
-- Labor

UPDATE #tProjectWIP
SET    #tProjectWIP.LaborUnBilled =
	CAST(ISNULL((Select sum(ROUND(ActualHours * ActualRate, 2)) 
		from #tTime t (nolock) 
		where t.ProjectKey = #tProjectWIP.ProjectKey 
		and (DateBilled is null Or DateBilled > @EndDate)
		), 0) as Money)
		
UPDATE #tProjectWIP
SET    #tProjectWIP.LaborUnBilledCost =
	CAST(ISNULL((Select sum(ROUND(ActualHours * CostRate, 2)) 
		from #tTime t (nolock) 
		where t.ProjectKey = #tProjectWIP.ProjectKey 
		and (DateBilled is null Or DateBilled > @EndDate)
		), 0) as Money)

UPDATE #tProjectWIP
SET    #tProjectWIP.LaborWriteOff =
	CAST(ISNULL((Select sum(ROUND(ActualHours * ActualRate, 2)) 
		from #tTime t (nolock) 
		where t.ProjectKey = #tProjectWIP.ProjectKey 
		and WriteOff = 1 and DateBilled <= @EndDate
		), 0) as Money)

-- ERs
UPDATE #tProjectWIP
SET    #tProjectWIP.ERUnBilled =
	ISNULL((Select sum(BillableCost) 
	from tExpenseReceipt t (nolock) 
	inner join tExpenseEnvelope ee (nolock) on t.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	Where ee.Status = 4 
	and t.ProjectKey = #tProjectWIP.ProjectKey 
	and t.VoucherDetailKey is null 
	and t.ItemKey NOT IN (SELECT EntityKey FROM tRetainerItems ri (NOLOCK)
								 WHERE ri.RetainerKey = #tProjectWIP.RetainerKey
								 AND   ri.Entity = 'tItem')  
	and ExpenseDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0)
	 

UPDATE #tProjectWIP
SET    #tProjectWIP.ERUnBilledCost =
	ISNULL((Select sum(ActualCost) 
	from tExpenseReceipt t (nolock) 
	inner join tExpenseEnvelope ee (nolock) on t.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	Where ee.Status = 4 
	and t.ProjectKey = #tProjectWIP.ProjectKey 
	and t.VoucherDetailKey is null 
	and t.ItemKey NOT IN (SELECT EntityKey FROM tRetainerItems ri (NOLOCK)
								 WHERE ri.RetainerKey = #tProjectWIP.RetainerKey
								 AND   ri.Entity = 'tItem')  
	and ExpenseDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0)

UPDATE #tProjectWIP
SET    #tProjectWIP.ERWriteOff =
	 ISNULL((Select sum(BillableCost)
	 from tExpenseReceipt t (nolock)  
	 inner join tExpenseEnvelope ee (nolock) on t.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
	 Where ee.Status = 4
	 and t.ProjectKey = #tProjectWIP.ProjectKey
	 and t.VoucherDetailKey is null
	 and t.ItemKey NOT IN (SELECT EntityKey FROM tRetainerItems ri (NOLOCK)
								 WHERE ri.RetainerKey = #tProjectWIP.RetainerKey
								 AND   ri.Entity = 'tItem')  
	 and ExpenseDate <= @EndDate and WriteOff = 1 and DateBilled <= @EndDate), 0)

-- Misc Costs
UPDATE #tProjectWIP
SET    #tProjectWIP.MCUnBilled =
	 ISNULL((Select sum(BillableCost)
	 from tMiscCost t (nolock) 
	 Where t.ProjectKey = #tProjectWIP.ProjectKey 
	 and t.ItemKey NOT IN (SELECT EntityKey FROM tRetainerItems ri (NOLOCK)
								 WHERE ri.RetainerKey = #tProjectWIP.RetainerKey
								 AND   ri.Entity = 'tItem')  
	 and ExpenseDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0)


UPDATE #tProjectWIP
SET  #tProjectWIP.MCUnBilledCost =
	 ISNULL((Select sum(TotalCost)
	 from tMiscCost t (nolock) 
	 Where t.ProjectKey = #tProjectWIP.ProjectKey 
	 and t.ItemKey NOT IN (SELECT EntityKey FROM tRetainerItems ri (NOLOCK)
								 WHERE ri.RetainerKey = #tProjectWIP.RetainerKey
								 AND   ri.Entity = 'tItem')  
	 and ExpenseDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0)

	 

UPDATE #tProjectWIP
SET    #tProjectWIP.MCWriteOff =
	 ISNULL((Select sum(BillableCost)
	 from tMiscCost t (nolock) 
	 Where t.ProjectKey = #tProjectWIP.ProjectKey 
	 and t.ItemKey NOT IN (SELECT EntityKey FROM tRetainerItems ri (NOLOCK)
								 WHERE ri.RetainerKey = #tProjectWIP.RetainerKey
								 AND   ri.Entity = 'tItem')  
	 and ExpenseDate <= @EndDate and WriteOff = 1 and DateBilled <= @EndDate), 0)


-- Vouchers
UPDATE #tProjectWIP
SET    #tProjectWIP.VOUnBilled =
	 ISNULL((Select sum(BillableCost)
	 from tVoucherDetail vd (nolock)
		inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey 
	 Where v.Status = 4 
	 and vd.ProjectKey = #tProjectWIP.ProjectKey 
	 and vd.ItemKey NOT IN (SELECT EntityKey FROM tRetainerItems ri (NOLOCK)
								 WHERE ri.RetainerKey = #tProjectWIP.RetainerKey
								 AND   ri.Entity = 'tItem')  
	 and v.PostingDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0)


UPDATE #tProjectWIP
SET    #tProjectWIP.VOUnBilledCost =
	 ISNULL((Select sum(vd.TotalCost)
	 from tVoucherDetail vd (nolock)
		inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey 
		left outer join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	 Where v.Status = 4 
	 and vd.ProjectKey = #tProjectWIP.ProjectKey 
	 and vd.ItemKey NOT IN (SELECT EntityKey FROM tRetainerItems ri (NOLOCK)
								 WHERE ri.RetainerKey = #tProjectWIP.RetainerKey
								 AND   ri.Entity = 'tItem')  
	 and v.PostingDate <= @EndDate and (vd.DateBilled is null Or vd.DateBilled > @EndDate)
	 and pod.DateBilled is NULL
	 ), 0)
		 	 

UPDATE #tProjectWIP
SET    #tProjectWIP.VOWriteOff =
	 ISNULL((Select sum(BillableCost)
	 from tVoucherDetail vd (nolock)
		inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey 
	 Where v.Status = 4 
	 and vd.ProjectKey = #tProjectWIP.ProjectKey 
	 and vd.ItemKey NOT IN (SELECT EntityKey FROM tRetainerItems ri (NOLOCK)
								 WHERE ri.RetainerKey = #tProjectWIP.RetainerKey
								 AND   ri.Entity = 'tItem')  
	 and vd.WriteOff = 1							 
	 and v.PostingDate <= @EndDate and vd.DateBilled <= @EndDate), 0)

		 	 
SELECT * FROM #tProjectWIP
	
/* 
Select
	 p.ProjectKey
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
	,u.FirstName + ' ' + u.LastName as AccountManagerName
	,div.ClientDivisionKey
	,ISNULL(div.DivisionName, ' No Division') as DivisionName
	,prod.ClientProductKey
	,ISNULL(prod.ProductName, ' No Product') as ProductName
	
	,CAST(ISNULL((Select sum(ROUND(ActualHours * ActualRate, 2)) from tTime t (nolock) inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
		Where ts.Status = 4 and t.ProjectKey = p.ProjectKey and ISNULL(p.RetainerKey, 0) = 0 and WorkDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0) as Money)
	 as LaborUnBilled
	,CAST(ISNULL((Select sum(ROUND(ActualHours * CostRate, 2)) from tTime t (nolock) inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
		Where ts.Status = 4 and t.ProjectKey = p.ProjectKey and ISNULL(p.RetainerKey, 0) = 0 and WorkDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0) as Money)
	 as LaborUnBilledCost
	,CAST(ISNULL((Select sum(ROUND(ActualHours * ActualRate, 2)) from tTime t (nolock) inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
		Where ts.Status = 4 and t.ProjectKey = p.ProjectKey and ISNULL(p.RetainerKey, 0) = 0 and WorkDate <= @EndDate and WriteOff = 1 and DateBilled <= @EndDate), 0) as Money)
	 as LaborWriteOff

	,ISNULL((Select sum(BillableCost) from tExpenseReceipt t (nolock) inner join tExpenseEnvelope ee (nolock) on t.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
		Where ee.Status = 4 and t.ProjectKey = p.ProjectKey and t.VoucherDetailKey is null and ISNULL(p.RetainerKey, 0) = 0 and ExpenseDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0)
	 as ERUnBilled
	,ISNULL((Select sum(ActualCost) from tExpenseReceipt t (nolock) inner join tExpenseEnvelope ee (nolock) on t.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
		Where ee.Status = 4 and t.ProjectKey = p.ProjectKey and t.VoucherDetailKey is null and ISNULL(p.RetainerKey, 0) = 0 and ExpenseDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0)
	 as ERUnBilledCost
	,ISNULL((Select sum(BillableCost) from tExpenseReceipt t (nolock)  inner join tExpenseEnvelope ee (nolock) on t.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
		Where ee.Status = 4 and t.ProjectKey = p.ProjectKey and t.VoucherDetailKey is null and ISNULL(p.RetainerKey, 0) = 0 and ExpenseDate <= @EndDate and WriteOff = 1 and DateBilled <= @EndDate), 0)
	 as ERWriteOff

	,ISNULL((Select sum(BillableCost) from tMiscCost t (nolock) Where t.ProjectKey = p.ProjectKey and ISNULL(p.RetainerKey, 0) = 0 and ExpenseDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0)
	 as MCUnBilled
	,ISNULL((Select sum(TotalCost) from tMiscCost t (nolock) Where t.ProjectKey = p.ProjectKey and ISNULL(p.RetainerKey, 0) = 0 and ExpenseDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0)
	 as MCUnBilledCost
	,ISNULL((Select sum(BillableCost) from tMiscCost t (nolock) Where t.ProjectKey = p.ProjectKey and ISNULL(p.RetainerKey, 0) = 0 and ExpenseDate <= @EndDate and WriteOff = 1 and DateBilled <= @EndDate), 0)
	 as MCWriteOff
	
	,ISNULL((Select SUM(BillableCost) from tVoucherDetail vd (nolock), tVoucher v (nolock)
		where v.Status = 4 and vd.ProjectKey = p.ProjectKey and vd.VoucherKey = v.VoucherKey and v.PostingDate <= @EndDate and (DateBilled is null Or DateBilled > @EndDate)), 0)
	 as VOUnBilled
	,ISNULL((Select SUM(vd.TotalCost) from tVoucherDetail vd (nolock) 
		inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		left outer join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		where v.Status = 4 and vd.ProjectKey = p.ProjectKey and v.PostingDate <= @EndDate and (vd.DateBilled is null Or vd.DateBilled > @EndDate) and pod.DateBilled is NULL ), 0)
	 as VOUnBilledCost
	,ISNULL((Select SUM(BillableCost) from tVoucherDetail vd (nolock), tVoucher v (nolock)
		where v.Status = 4 and vd.ProjectKey = p.ProjectKey and vd.VoucherKey = v.VoucherKey and v.InvoiceDate <= @EndDate and vd.WriteOff = 1 and DateBilled <= @EndDate), 0)
	 as VOWriteOff
	--and pod.DateBilled is NULL
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

From
	tProject p (nolock)
	LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey
	LEFT OUTER JOIN tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	LEFT OUTER JOIN tUser u (nolock) on p.AccountManager = u.UserKey
	left outer join tClientDivision div (nolock) on p.ClientDivisionKey = div.ClientDivisionKey
	left outer join tClientProduct prod (nolock) on p.ClientProductKey = prod.ClientProductKey

Where
	p.CompanyKey = @CompanyKey and p.NonBillable = 0

*/
GO
