USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGetApprovalList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGetApprovalList]
	(
		@CompanyKey int,
		@UserKey int,
		@SubmittedForApproval tinyint = 0
	)
AS

DECLARE @ClientVendorLogin tinyint

IF @SubmittedForApproval = 0
	Select
		 b.*
		,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
		,c.CustomerID
		,c.CompanyName
		,u.FirstName + ' ' + u.LastName as AccountManager
		,Case b.BillingMethod
			When 1 then 'Time & Materials'
			When 2 then 'Fixed Fee'
			When 3 then 'Retainer'
			else 'Master Worksheet' end as MethodName
		,ISNULL(p.EstLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.ApprovedCOExpense, 0) as BudgetAmount
		,(Select Sum(TotalAmount) from tInvoiceLine (nolock)
			inner join tInvoice (nolock) on tInvoice.InvoiceKey = tInvoiceLine.InvoiceKey
			Where tInvoiceLine.ProjectKey = b.ProjectKey and tInvoice.AdvanceBill = 0) as AmountBilled
	From
		tBilling b (NOLOCK) 
		left outer join tProject p (NOLOCK) on b.ProjectKey = p.ProjectKey
		left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		left outer join tUser u (nolock) on p.AccountManager = u.UserKey
	Where
		b.CompanyKey = @CompanyKey and
		b.Approver = @UserKey and
		b.Status in (1, 3)
	Order By CompanyName, ProjectNumber
ELSE
	BEGIN
		Select @ClientVendorLogin = ISNULL(ClientVendorLogin, 0)
		From tUser (nolock) Where UserKey = @UserKey

		Select
			 b.*
			,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
			,c.CustomerID
			,c.CompanyName
			,u.FirstName + ' ' + u.LastName as AccountManager
			,Case b.BillingMethod
				When 1 then 'Time & Materials'
				When 2 then 'Fixed Fee'
				When 3 then 'Retainer'
				else 'Master Worksheet' end as MethodName
			,ISNULL(p.EstLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.ApprovedCOExpense, 0) as BudgetAmount
			,(Select Sum(TotalAmount) from tInvoiceLine (nolock)
				inner join tInvoice (nolock) on tInvoice.InvoiceKey = tInvoiceLine.InvoiceKey
				Where tInvoiceLine.ProjectKey = b.ProjectKey and tInvoice.AdvanceBill = 0) as AmountBilled
		From
			tBilling b (NOLOCK) 
			left outer join tProject p (NOLOCK) on b.ProjectKey = p.ProjectKey
			left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
			left outer join tUser u (nolock) on p.AccountManager = u.UserKey
		Where
			b.CompanyKey = @CompanyKey and
			@ClientVendorLogin = 0 and
			b.Status = 2
		Order By CompanyName, ProjectNumber
	END
GO
