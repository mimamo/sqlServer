USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptMuddAGIAcctMgr]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptMuddAGIAcctMgr]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@SalesManager varchar(1000),
		@AccountManagerKey int,
		@PaidOnly tinyint,
		@OmitNoSM tinyint
		
	)
AS --Encrypt

/*
|| When     Who Rel   What
|| 09/26/06 CRG 8.35  Modified to Cast the AmtToBill custom field to money in case users enter $ or , for the value.
|| 10/06/06 CRG 8.35  Added AccountManagerKey and OmitNoSM parameters for the report.
|| 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN/INNER JOIN for SQL 2005
*/
  
Create Table #Projects
(
	ProjectKey int null,
	CustomFieldKey int null,
	ProjectNumber varchar(500) null,
	AccountManagerKey int null,
	AccountManager varchar(500) null,
	SalesManager varchar(1000) null,
	ClientName varchar(1000) null,
	CommPaid varchar(10) null,
	PerfBased varchar(10) null,
	SpacePos int null,
	SalesManagerFirst varchar(1000) null,
	SalesManagerLast varchar(1000) null,
	SalesManagerInitials varchar(2) null,
	AmountToBill decimal(24,4) null,
	BillMonth varchar(50),
	BillYear varchar(50),
	BillDate datetime
)


-- Set up the table only brining in projects where there are invoices in the date range.
Insert Into #Projects (ProjectKey)
Select Distinct p.ProjectKey 
from tProject p (nolock) Inner join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
Where p.CompanyKey = @CompanyKey
and	(pt.ProjectTypeName = 'Direct Mail' or pt.ProjectTypeName = 'Insert') 
and ProjectStatusKey not in (6,10) -- Cancelled, Cancelled By Client


-- Then bring in the project info based on the selected Project Keys
Update #Projects Set
	CustomFieldKey = p.CustomFieldKey,
	ProjectNumber = p.ProjectNumber,
	AccountManagerKey = p.AccountManager,
	AccountManager = am.FirstName + ' ' + am.LastName,
	ClientName = 
		case
			when c.CustomerID is null then ISNULL(c.CompanyName, '')
			else c.CustomerID + ' ' + ISNULL(c.CompanyName, '')
		end
From tProject p (nolock)
	INNER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
	LEFT OUTER JOIN tUser am (nolock) ON p.AccountManager = am.UserKey
Where #Projects.ProjectKey = p.ProjectKey
	
	
-- get the Bill Month
Update #Projects Set BillMonth = FieldValue From vCFValues Where vCFValues.FieldName = 'BillMonth' and EntityKey = @CompanyKey and Entity = 'General' and #Projects.CustomFieldKey = vCFValues.CustomFieldKey

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

-- if an account manager is specified, delete projects where there is no match
If ISNULL(@AccountManagerKey, 0) > 0
	Delete #Projects Where AccountManagerKey <> @AccountManagerKey or AccountManagerKey is null

-- If Omit Projects with No Sales Manager
IF @OmitNoSM = 1
	DELETE	#Projects
	WHERE	SalesManager is null
	OR		LEN(SalesManager) = 0
	
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

-- get the comm paid flag
Update #Projects Set PerfBased = Case FieldValue When 'YES' then 'X' else '' end 
	From vCFValues Where vCFValues.FieldName = 'PerfBased' and EntityKey = @CompanyKey and Entity = 'General' and #Projects.CustomFieldKey = vCFValues.CustomFieldKey
	
-- Get the Amount To Bill and update the table
Update #Projects Set AmountToBill = cast(FieldValue as money) From vCFValues Where vCFValues.FieldName = 'AmtToBill' and EntityKey = @CompanyKey and Entity = 'General' and #Projects.CustomFieldKey = vCFValues.CustomFieldKey


Select * 
	,(Select ISNULL(Sum(TotalCost), 0) 
		from tMiscCost m (nolock)
		inner join tItem i (nolock) on m.ItemKey = i.ItemKey
		Where i.ItemID = '*printsave' and m.ProjectKey = p.ProjectKey) as PrintSave
	,isnull((Select ISNULL(Sum(TotalCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey),0) + 
	 isnull((Select ISNULL(Sum(TotalCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey and tVoucherDetail.PurchaseOrderDetailKey > 0),0) +
	 isnull((Select Sum(ISNULL(TotalCost, 0)) - Sum(ISNULL(AppliedCost, 0)) from tPurchaseOrderDetail pod Where pod.ProjectKey = p.ProjectKey and Closed = 0),0) as TotalExpenses
	,AmountToBill as TotalInvoiced
	,(Select MAX(CheckDate) from tCheck ch (nolock) 
		Inner join tCheckAppl ca (nolock) on ch.CheckKey = ca.CheckKey
		inner join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
		Where i.ProjectKey = p.ProjectKey) as LastPaid
from #Projects p Order By AccountManager, ProjectNumber
GO
