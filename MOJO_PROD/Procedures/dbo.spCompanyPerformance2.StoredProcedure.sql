USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCompanyPerformance2]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCompanyPerformance2]
	@Month int,
	@Year int
	
AS --Encrypt

/*
|| When      Who Rel     What
|| 6/7/07    CRG 8.4.3.3 Updated Project performance to use CreatedDate rather than StartDate.
*/

	SELECT	c.CompanyKey,c.CompanyName, p.ProductVersion, p.DateJoined
	,(SELECT COUNT(*) FROM tCalendar (NOLOCK)
		WHERE tCalendar.CompanyKey = c.CompanyKey
		AND		MONTH(EventStart) = @Month
		AND		YEAR(EventStart) = @Year) as CalendarEvents
	,(SELECT COUNT(*)
		FROM	tProject (NOLOCK)
		WHERE tProject.CompanyKey = c.CompanyKey
		AND		MONTH(CreatedDate) = @Month
		AND		YEAR(CreatedDate) = @Year) as Projects
	,(SELECT COUNT(*)
		FROM	tEstimate (NOLOCK)
		inner join tProject on tEstimate.ProjectKey = tProject.ProjectKey
		WHERE tProject.CompanyKey = c.CompanyKey
		AND		MONTH(StartDate) = @Month
		AND		YEAR(StartDate) = @Year) as Estimates
	,(SELECT COUNT(*)
		FROM	tApproval (NOLOCK)
		inner join tProject on tApproval.ProjectKey = tProject.ProjectKey
		WHERE tProject.CompanyKey = c.CompanyKey
		AND		MONTH(DateCreated) = @Month
		AND		YEAR(DateCreated) = @Year) as Approvals
	,(SELECT COUNT(*)
		FROM	tQuote (NOLOCK)
		WHERE tQuote.CompanyKey = c.CompanyKey
		AND		MONTH(QuoteDate) = @Month
		AND		YEAR(QuoteDate) = @Year) as Quotes
	,(SELECT COUNT(*)
		FROM	tPurchaseOrder (NOLOCK)
		WHERE tPurchaseOrder.CompanyKey = c.CompanyKey
		AND		MONTH(DateCreated) = @Month
		AND		YEAR(DateCreated) = @Year) as POs
	,(SELECT COUNT(*)
		FROM	tVoucher (NOLOCK)
		WHERE tVoucher.CompanyKey = c.CompanyKey
		AND		MONTH(InvoiceDate) = @Month
		AND		YEAR(InvoiceDate) = @Year) as Vouchers
	,(SELECT COUNT(*)
		FROM	tInvoice (NOLOCK)
		WHERE tInvoice.CompanyKey = c.CompanyKey
		AND		MONTH(InvoiceDate) = @Month
		AND		YEAR(InvoiceDate) = @Year) as Invoices
	,(SELECT COUNT(*)
		FROM	tCheck ch (NOLOCK)
		INNER JOIN tCompany cl on ch.ClientKey = cl.CompanyKey
		WHERE cl.OwnerCompanyKey = c.CompanyKey
		AND		MONTH(CheckDate) = @Month
		AND		YEAR(CheckDate) = @Year) as Checks
	,(SELECT COUNT(*)
		FROM	tPayment (NOLOCK)
		WHERE tPayment.CompanyKey = c.CompanyKey
		AND		MONTH(PaymentDate) = @Month
		AND		YEAR(PaymentDate) = @Year) as Payments
	,(SELECT COUNT(*)
		FROM	tJournalEntry (NOLOCK)
		WHERE tJournalEntry.CompanyKey = c.CompanyKey
		AND		MONTH(EntryDate) = @Month
		AND		YEAR(EntryDate) = @Year) as JournalEntries
	,(SELECT COUNT(*)
		FROM	tRequest (NOLOCK)
		WHERE tRequest.CompanyKey = c.CompanyKey
		AND		MONTH(DateAdded) = @Month
		AND		YEAR(DateAdded) = @Year) as Requests
	,(SELECT COUNT(*)
		FROM	tTimeSheet (NOLOCK)
		WHERE tTimeSheet.CompanyKey = c.CompanyKey
		AND		MONTH(DateCreated) = @Month
		AND		YEAR(DateCreated) = @Year) as TimeSheets
	,(SELECT COUNT(*)
		FROM	tExpenseEnvelope (NOLOCK)
		WHERE tExpenseEnvelope.CompanyKey = c.CompanyKey
		AND		MONTH(StartDate) = @Month
		AND		YEAR(StartDate) = @Year) as ExpenseReports
	,(SELECT COUNT(*)
		FROM	tUser (NOLOCK)
		WHERE tUser.CompanyKey = c.CompanyKey
		AND		UserID is not null
		AND		Active = 1) as Users
	,(SELECT COUNT(*)
		FROM	tForm (NOLOCK)
		WHERE tForm.CompanyKey = c.CompanyKey
		AND		MONTH(DateCreated) = @Month
		AND		YEAR(DateCreated) = @Year) as Forms
	FROM	tCompany c (nolock) 
	inner join tPreference p (nolock) on p.CompanyKey = c.CompanyKey
	Where c.OwnerCompanyKey is null and c.Locked = 0
	ORDER BY CompanyName
GO
