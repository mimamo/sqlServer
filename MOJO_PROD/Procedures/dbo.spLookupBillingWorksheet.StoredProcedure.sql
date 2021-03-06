USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLookupBillingWorksheet]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLookupBillingWorksheet]
	(
		@CompanyKey int,
		@BillingKey int
	)
AS --Encrypt

  /*
  || When     Who Rel     What
  || 05/23/07 GHL 8.4.2.2 Bug 9323. Changed inner join with tProject to left outer join
  ||                      so that retainer worksheets without ProjectKey can be added to master worksheet 
  || 07/06/07 GHL 8.5     Added filter on GLCompanyKey   
  || 10/02/13 GHL 10.573  Added filter on CurrencyID
  */
  
Declare @ClientKey int, @BillingMethod smallint, @ParentCompany int
Declare @UseGLCompany int, @GLCompanyKey int
Declare @MultiCurrency int, @CurrencyID varchar(10)

Select @UseGLCompany = ISNULL(UseGLCompany, 0) 
      ,@MultiCurrency = ISNULL(MultiCurrency, 0)
from tPreference (NOLOCK) where CompanyKey = @CompanyKey

Select @ClientKey = ClientKey, @BillingMethod = BillingMethod
	, @GLCompanyKey = GLCompanyKey, @CurrencyID = CurrencyID
from tBilling (nolock) 
Where BillingKey = @BillingKey

Select @ParentCompany = ParentCompanyKey from tCompany (nolock) Where CompanyKey = @ClientKey

Select
	 b.CompanyKey
	,b.BillingKey
	,b.ParentWorksheetKey
	,b.BillingID
	,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
	,Case b.Status
		When 1 then 'In Review'
		When 2 then 'Sent for Approval'
		When 3 then 'Rejected'
		When 4 then 'Approved'
		When 5 then 'Billed' end as WorksheetStatus
	,u.FirstName + ' ' + u.LastName as AccountManager
From
	tBilling b (NOLOCK) 
	inner join tCompany c (nolock) on b.ClientKey = c.CompanyKey
	left outer join tProject p (NOLOCK) on b.ProjectKey = p.ProjectKey
	left outer join tUser u (nolock) on p.AccountManager = u.UserKey
Where
	b.CompanyKey = @CompanyKey and
	b.Status < 5 and
	(c.CompanyKey = @ClientKey or c.ParentCompanyKey = @ClientKey or c.ParentCompanyKey = @ParentCompany or c.CompanyKey = @ParentCompany) and
	b.ParentWorksheet = 0 and
	b.AdvanceBill = 0 and
	b.ParentWorksheetKey is null and
	(@UseGLCompany = 0 OR (isnull(b.GLCompanyKey, 0) = isnull(@GLCompanyKey, 0)) ) and
	(@MultiCurrency = 0 OR (isnull(b.CurrencyID, '') = isnull(@CurrencyID, '')) ) 

Order By b.Status, p.ProjectNumber
GO
