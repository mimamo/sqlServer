USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCompanyPerformanceDaily]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCompanyPerformanceDaily]
	@UsageDate smalldatetime
AS --Encrypt

/*
|| When      Who Rel     What
|| 6/12/08   CRG 8.5.1.3 Created for new Daily performance check
*/

	DECLARE @NextDay smalldatetime
	SELECT	@NextDay = DATEADD(day, 1, @UsageDate)

	SELECT	c.CompanyKey,c.CompanyName, p.ProductVersion, p.DateJoined, @UsageDate AS UsageDate
	,(SELECT COUNT(*) FROM tCalendar (NOLOCK)
		WHERE	tCalendar.CompanyKey = c.CompanyKey
		AND		EventStart >= @UsageDate
		AND		EventStart < @NextDay) as CalendarEvents
	,(SELECT COUNT(*)
		FROM	tProject (NOLOCK)
		WHERE	tProject.CompanyKey = c.CompanyKey
		AND		CreatedDate >= @UsageDate
		AND		CreatedDate < @NextDay) as Projects
	,(SELECT COUNT(*)
		FROM	tEstimate (NOLOCK)
		INNER JOIN tProject on tEstimate.ProjectKey = tProject.ProjectKey
		WHERE	tProject.CompanyKey = c.CompanyKey
		AND		StartDate >= @UsageDate
		AND		StartDate < @NextDay) as Estimates
	,(SELECT COUNT(*)
		FROM	tApproval (NOLOCK)
		inner join tProject on tApproval.ProjectKey = tProject.ProjectKey
		WHERE	tProject.CompanyKey = c.CompanyKey
		AND		DateCreated >= @UsageDate
		AND		DateCreated < @NextDay) as Approvals
	,(SELECT COUNT(*)
		FROM	tQuote (NOLOCK)
		WHERE	tQuote.CompanyKey = c.CompanyKey
		AND		QuoteDate >= @UsageDate
		AND		QuoteDate < @NextDay) as Quotes
	,(SELECT COUNT(*)
		FROM	tPurchaseOrder (NOLOCK)
		WHERE	tPurchaseOrder.CompanyKey = c.CompanyKey
		AND		DateCreated >= @UsageDate
		AND		DateCreated < @NextDay) as POs
	,(SELECT COUNT(*)
		FROM	tVoucher (NOLOCK)
		WHERE	tVoucher.CompanyKey = c.CompanyKey
		AND		InvoiceDate >= @UsageDate
		AND		InvoiceDate < @NextDay) as Vouchers
	,(SELECT COUNT(*)
		FROM	tInvoice (NOLOCK)
		WHERE	tInvoice.CompanyKey = c.CompanyKey
		AND		InvoiceDate >= @UsageDate
		AND		InvoiceDate < @NextDay) as Invoices
	,(SELECT COUNT(*)
		FROM	tCheck ch (NOLOCK)
		INNER JOIN tCompany cl on ch.ClientKey = cl.CompanyKey
		WHERE	cl.OwnerCompanyKey = c.CompanyKey
		AND		CheckDate >= @UsageDate
		AND		CheckDate < @NextDay) as Checks
	,(SELECT COUNT(*)
		FROM	tPayment (NOLOCK)
		WHERE tPayment.CompanyKey = c.CompanyKey
		AND		PaymentDate >= @UsageDate
		AND		PaymentDate < @NextDay) as Payments
	,(SELECT COUNT(*)
		FROM	tJournalEntry (NOLOCK)
		WHERE tJournalEntry.CompanyKey = c.CompanyKey
		AND		EntryDate >= @UsageDate
		AND		EntryDate < @NextDay) as JournalEntries
	,(SELECT COUNT(*)
		FROM	tRequest (NOLOCK)
		WHERE tRequest.CompanyKey = c.CompanyKey
		AND		DateAdded >= @UsageDate
		AND		DateAdded < @NextDay) as Requests
	,(SELECT COUNT(*)
		FROM	tTimeSheet (NOLOCK)
		WHERE tTimeSheet.CompanyKey = c.CompanyKey
		AND		DateCreated >= @UsageDate
		AND		DateCreated < @NextDay) as TimeSheets
	,(SELECT COUNT(*)
		FROM	tExpenseEnvelope (NOLOCK)
		WHERE tExpenseEnvelope.CompanyKey = c.CompanyKey
		AND		StartDate >= @UsageDate
		AND		StartDate < @NextDay) as ExpenseReports
	,(SELECT COUNT(*)
		FROM	tUser (NOLOCK)
		WHERE tUser.CompanyKey = c.CompanyKey
		AND		UserID is not null
		AND		Active = 1) as Users
	,(SELECT COUNT(*)
		FROM	tForm (NOLOCK)
		WHERE tForm.CompanyKey = c.CompanyKey
		AND		DateCreated >= @UsageDate
		AND		DateCreated < @NextDay) as Forms
	FROM	tCompany c (nolock) 
	inner join tPreference p (nolock) on p.CompanyKey = c.CompanyKey
	Where c.OwnerCompanyKey is null and c.Locked = 0
	ORDER BY CompanyName
GO
