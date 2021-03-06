USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptMuddAGIAcctMgrClient]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptMuddAGIAcctMgrClient]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@SalesManager varchar(1000),
		@PaidOnly tinyint,
		@ProjectTypeKey int,
		@OmitNoSM tinyint,
		@AccountManagerKey int,
		@OnlyPaid tinyint,
		@PaidStartDate smalldatetime,
		@PaidEndDate smalldatetime
		
	)
AS --Encrypt

/*
|| When     Who Rel   What
|| 09/26/06 CRG 8.35  Modified to Cast the AmtToBill custom field to money in case users enter $ or , for the value.
||
|| 09/26/06 CRG 8.35  Modified to combine ProjectTypes: Radio and TV Spot.
||
|| 09/26/06 CRG 8.35  Added parameter for OmitNoSM, to allow them to omit projects with no Sales Manager.
||
|| 10/13/06 CRG 8.35  Added AccountManagerKey.
||                    Removed special code that combined Radio and TV spots.
|| 03/06/07 GWG 8.406 Added the ability to limit to a paid date range
|| 04/18/07 GHL 8.4.2 Reviewed LastPaid logic
|| 11/26/07 GHL 8.5   Switched to LEFT OUTER JOIN/INNER JOIN for SQL 2005
|| 05/14/13 GHL 10.567 (177619) Added indexes and reorganized deletes for performance 
*/  

Create Table #Projects
(
	ProjectKey int null,
	CustomFieldKey int null,
	ProjectNumber varchar(500) null,
	ProjectName varchar(100) null,
	AccountManager varchar(500) null,
	AccountManagerKey int null,
	SalesManager varchar(1000) null,
	ClientName varchar(1000) null,
	CommPaid varchar(10) null,
	PerfBased varchar(10) null,
	SpacePos int null,
	SalesManagerFirst varchar(1000) null,
	SalesManagerLast varchar(1000) null,
	SalesManagerInitials varchar(2) null,
	AmountToBill decimal(24,4) null,
	BillMonth varchar(50) null,
	BillYear varchar(50) null,
	BillDate datetime null,
	LastPaid smalldatetime null,

	-- added these fields to temp to increase perfo
	-- when the number of projects is high, it is usually faster to do separate updates rather than subqueries
	PrintSave money null,  
	MiscExp money null,
	POExpense money null,
	Estimate money null
)


Create Table #fullypaid
(
	InvoiceKey int null,
	ProjectKey int null,
	MaxDate smalldatetime null
)


if @PaidStartDate is null
	Select @PaidStartDate = DATEADD(yy, -30, GETDATE())
if @PaidEndDate is null
	Select @PaidEndDate = DATEADD(yy, 30, GETDATE())
	
/*
IF @ProjectTypeKey = 9 --Radio/TV Spot
	Insert Into #Projects (ProjectKey)
	Select Distinct p.ProjectKey 
	from tProject p (nolock) Inner join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	Where p.CompanyKey = @CompanyKey
	and	p.ProjectTypeKey in (9, 10)
	and ProjectStatusKey not in (6,10) -- Cancelled, Cancelled By Client
ELSE
	Insert Into #Projects (ProjectKey)
	Select Distinct p.ProjectKey 
	from tProject p (nolock) Inner join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	Where p.CompanyKey = @CompanyKey
	and	((isnull(@ProjectTypeKey, 0) = 0) or (p.ProjectTypeKey = @ProjectTypeKey))
	and ProjectStatusKey not in (6,10) -- Cancelled, Cancelled By Client
*/

create index ind_proj_mudd_xxx on #Projects (ProjectKey)
create index ind_custom_mudd_xxx on #Projects (CustomFieldKey)
create index ind_proj_mudd_2xxx on #fullypaid (ProjectKey)
create index ind_inv_mudd_2xxx on #fullypaid (InvoiceKey)

Insert #Projects (ProjectKey)
Select Distinct p.ProjectKey 
from tProject p (nolock) Inner join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
Where p.CompanyKey = @CompanyKey
and	((isnull(@ProjectTypeKey, 0) = 0) or (p.ProjectTypeKey = @ProjectTypeKey))
and ProjectStatusKey not in (6,10) -- Cancelled, Cancelled By Client
and	((isnull(@AccountManagerKey, 0) = 0) or (p.AccountManager = @AccountManagerKey))

-- Then bring in the project info based on the selected Project Keys
Update #Projects Set
	CustomFieldKey = p.CustomFieldKey,
	ProjectNumber = p.ProjectNumber,
	ProjectName = p.ProjectName,
	AccountManagerKey = p.AccountManager,
	AccountManager = am.FirstName + ' ' + am.LastName,
	ClientName = 
		case
			when c.CustomerID is null then ISNULL(c.CompanyName, '')
			else c.CustomerID + ' ' + ISNULL(c.CompanyName, '')
		end
From tProject p (nolock)
	INNER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey
	LEFT OUTER JOIN tUser am (nolock) on p.AccountManager = am.UserKey
Where #Projects.ProjectKey = p.ProjectKey
	
-- get the Bill Month
Update #Projects Set BillMonth = FieldValue From vCFValues Where vCFValues.FieldName = 'BillMonth' and EntityKey = @CompanyKey and Entity = 'General' and #Projects.CustomFieldKey = vCFValues.CustomFieldKey

--select * from #Projects

-- get the Billing Year
Update #Projects Set BillYear = FieldValue From vCFValues Where vCFValues.FieldName = 'BillYear' and EntityKey = @CompanyKey and Entity = 'General' and #Projects.CustomFieldKey = vCFValues.CustomFieldKey

-- convert to a billing date
update #Projects
set BillDate = cast(BillMonth + ' 01,' + BillYear as datetime)

-- eliminate projects that do not fall in the specified date range
delete #Projects
where (BillDate < @StartDate or BillDate > @EndDate)
or BillDate is null

-- Get the Sales Manager and Update the table
Update #Projects Set SalesManager = FieldValue From vCFValues Where vCFValues.FieldName = 'SalesMngr' and EntityKey = @CompanyKey and Entity = 'General' and #Projects.CustomFieldKey = vCFValues.CustomFieldKey

-- if a sales manager is specified, delete projects where there is no match
If @SalesManager is not null
	Delete #Projects Where SalesManager <> @SalesManager or SalesManager is null

 	
-- extract Sales Manager initials
update #Projects
set SpacePos = charindex(' ',SalesManager)
where SalesManager is not null

update #Projects
set SalesManagerFirst = rtrim(ltrim(substring(SalesManager , 1 , SpacePos-1)))
where SalesManager is not null
and SpacePos > 0

update #Projects
set SalesManagerLast = rtrim(ltrim(substring(SalesManager , SpacePos , len(SalesManager))))
where SalesManager is not null
and SpacePos > 0

update #Projects
set SalesManagerInitials = upper(substring(SalesManagerFirst,1,1)) + upper(substring(SalesManagerLast,1,1))
where SalesManager is not null
and SpacePos > 0


-- get the comm paid flag
Update #Projects Set CommPaid = Case FieldValue When 'YES' then 'X' else '' end 
	From vCFValues Where vCFValues.FieldName = 'comPaid' and EntityKey = @CompanyKey and Entity = 'General' and #Projects.CustomFieldKey = vCFValues.CustomFieldKey

-- If Paid only then remove projects that are not paid
if @PaidOnly = 1
	Delete #Projects Where CommPaid <> 'X' or CommPaid is null
	
-- If Omit Projects with No Sales Manager
IF @OmitNoSM = 1
	DELETE	#Projects
	WHERE	SalesManager is null
	OR		LEN(SalesManager) = 0

-- get the comm paid flag
Update #Projects Set PerfBased = Case FieldValue When 'YES' then 'X' else '' end 
	From vCFValues Where vCFValues.FieldName = 'PerfBased' and EntityKey = @CompanyKey and Entity = 'General' and #Projects.CustomFieldKey = vCFValues.CustomFieldKey
	
-- Get the Amount To Bill and update the table
Update #Projects Set AmountToBill = cast(FieldValue as money) From vCFValues Where vCFValues.FieldName = 'AmtToBill' and EntityKey = @CompanyKey and Entity = 'General' and #Projects.CustomFieldKey = vCFValues.CustomFieldKey

-- Find the last date an invoice for this project was paid. 
-- Only look at invoices and receipts in the date window

-- get fullypaid invoices
insert #fullypaid (InvoiceKey, ProjectKey)
Select i.InvoiceKey, i.ProjectKey
From   tInvoice i (NOLOCK)
	Inner Join #Projects b ON i.ProjectKey = b.ProjectKey
Where 	i.PostingDate > '2/1/2007' -- Yes, hard coded 
And    ISNULL(i.InvoiceTotalAmount, 0)
		- ISNULL((Select Sum(Amount) from tCheckAppl ca (nolock) 
			inner join tCheck c (nolock) on ca.CheckKey = c.CheckKey 
		 	Where c.PostingDate <= @PaidEndDate 
		 	and ca.InvoiceKey = i.InvoiceKey), 0)
		- ISNULL((Select ISNULL(Sum(Amount), 0) 
			from tInvoiceCredit ic (nolock) 
			inner join tInvoice cc (nolock) on cc.InvoiceKey = ic.CreditInvoiceKey
			Where ic.InvoiceKey = i.InvoiceKey 
			And cc.PostingDate <= @PaidEndDate), 0)
		= 0

-- get the last check date for these fully paid invoices
Update #fullypaid
Set    #fullypaid.MaxDate =
	(Select Max(CheckDate) from tCheck (nolock) 
		inner join tCheckAppl (nolock) on tCheck.CheckKey = tCheckAppl.CheckKey
		Where tCheckAppl.InvoiceKey = #fullypaid.InvoiceKey 
			and tCheck.PostingDate >= @PaidStartDate and tCheck.PostingDate <= @PaidEndDate)
		
-- get the last check for the projects			
Update #Projects
Set    #Projects.LastPaid = 
	(Select Max(b.MaxDate) from #fullypaid b
	Where b.ProjectKey = #Projects.ProjectKey)

/*
Update #Projects
Set LastPaid = receipts.MaxDate
From (
Select i.ProjectKey, MAX(CheckDate) as MaxDate from tCheck ch (nolock) 
Inner join tCheckAppl ca (nolock) on ch.CheckKey = ca.CheckKey
inner join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
inner join #Projects p on p.ProjectKey = i.ProjectKey
and ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(AmountReceived, 0) - ISNULL(WriteoffAmount, 0) - ISNULL(i.RetainerAmount, 0) = 0 
--and i.PostingDate >= @PaidStartDate and i.PostingDate <= @PaidEndDate
and ch.PostingDate >= @PaidStartDate and ch.PostingDate <= @PaidEndDate
and i.PostingDate > '2/1/2007'
Group By i.ProjectKey
) as receipts
Where #Projects.ProjectKey = receipts.ProjectKey
*/

			
-- If we only want to see paid only, then delete where the date is null
if ISNULL(@OnlyPaid, 0) = 1
	Delete #Projects Where LastPaid is null 

update #Projects
set    #Projects.PrintSave = isnull((
	Select ISNULL(Sum(TotalCost), 0) 
		from tMiscCost m (nolock)
		inner join tItem i (nolock) on m.ItemKey = i.ItemKey
		Where i.ItemID = '*printsave' and m.ProjectKey = #Projects.ProjectKey
),0)

update #Projects
set    #Projects.MiscExp = isnull((
	Select ISNULL(Sum(TotalCost), 0) 
		from tMiscCost (nolock) 
		Where tMiscCost.ProjectKey = #Projects.ProjectKey
),0)


update #Projects
set    #Projects.POExpense = isnull((
	Select ISNULL(Sum(TotalCost), 0) from tVoucherDetail (nolock) 
		Where tVoucherDetail.ProjectKey = #Projects.ProjectKey and tVoucherDetail.PurchaseOrderDetailKey > 0
),0)

update #Projects
set    #Projects.POExpense = isnull(#Projects.POExpense, 0) + isnull((
	Select Sum(ISNULL(TotalCost, 0)) - Sum(ISNULL(AppliedCost, 0)) from tPurchaseOrderDetail pod (nolock)
		Where pod.ProjectKey = #Projects.ProjectKey and Closed = 0
),0)

update #Projects
set    #Projects.Estimate = isnull((
	Select Sum(ExpenseGross)
		from tEstimate e (nolock)
		where #Projects.ProjectKey = e.ProjectKey
),0)

Select p.*
	,AmountToBill as TotalInvoiced
from #Projects p Order By AccountManager, ProjectNumber
GO
