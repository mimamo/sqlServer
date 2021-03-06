USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCompanyPerformance]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCompanyPerformance]
	@CompanyKey int
	
AS --Encrypt

/*
|| When      Who Rel     What
|| 6/7/07    CRG 8.4.3   Updated Project performance to use CreatedDate rather than StartDate.
*/

	DECLARE	@Month int,
			@Year int,
			@Count int
	
	CREATE TABLE #tCompanyPerf
		(xMonth int,
		xYear int,
		MonthName varchar(25),
		CalendarEvents int,
		Projects int,
		Quotes int,
		POs int,
		Vouchers int,
		Invoices int,
		JournalEntries int,
		Checks int,
		Payments int,
		Requests int,
		TimeSheets int,
		ExpenseEnvelopes int,
		Forms int,
		Approvals int)
		
	SELECT	@Month = MONTH(GETDATE())
	SELECT	@Year = YEAR(GETDATE())
	SELECT	@Count = 1
	
	WHILE @Count <= 12
	BEGIN
	
		INSERT	#tCompanyPerf (xMonth, xYear) VALUES (@Month, @Year)
		
		SELECT	@Month = @Month - 1
		
		IF @Month = 0
		BEGIN
			SELECT	@Month = 12
			SELECT	@Year = @Year - 1
		END
		
		SELECT	@Count = @Count + 1
	END
	
	UPDATE	#tCompanyPerf
	SET		CalendarEvents = 
				(SELECT	COUNT(*)
				FROM	tCalendar (NOLOCK)
				WHERE	CompanyKey = @CompanyKey
				AND		MONTH(EventStart) = #tCompanyPerf.xMonth
				AND		YEAR(EventStart) = #tCompanyPerf.xYear)
				
	UPDATE	#tCompanyPerf
	SET		Projects = 
				(SELECT	COUNT(*)
				FROM	tProject (NOLOCK)
				WHERE	CompanyKey = @CompanyKey
				AND		MONTH(CreatedDate) = #tCompanyPerf.xMonth
				AND		YEAR(CreatedDate) = #tCompanyPerf.xYear)
	
	UPDATE	#tCompanyPerf
	SET		Quotes = 
				(SELECT	COUNT(*)
				FROM	tQuote (NOLOCK)
				WHERE	CompanyKey = @CompanyKey
				AND		MONTH(QuoteDate) = #tCompanyPerf.xMonth
				AND		YEAR(QuoteDate) = #tCompanyPerf.xYear)
	
	UPDATE	#tCompanyPerf
	SET		POs = 
				(SELECT	COUNT(*)
				FROM	tPurchaseOrder (NOLOCK)
				WHERE	CompanyKey = @CompanyKey
				AND		MONTH(DateCreated) = #tCompanyPerf.xMonth
				AND		YEAR(DateCreated) = #tCompanyPerf.xYear)

	UPDATE	#tCompanyPerf
	SET		Vouchers = 
				(SELECT	COUNT(*)
				FROM	tVoucher (NOLOCK)
				WHERE	CompanyKey = @CompanyKey
				AND		MONTH(InvoiceDate) = #tCompanyPerf.xMonth
				AND		YEAR(InvoiceDate) = #tCompanyPerf.xYear)

	UPDATE	#tCompanyPerf
	SET		Invoices = 
				(SELECT	COUNT(*)
				FROM	tInvoice (NOLOCK)
				WHERE	CompanyKey = @CompanyKey
				AND		MONTH(InvoiceDate) = #tCompanyPerf.xMonth
				AND		YEAR(InvoiceDate) = #tCompanyPerf.xYear)

	UPDATE	#tCompanyPerf
	SET		JournalEntries = 
				(SELECT	COUNT(*)
				FROM	tJournalEntry (NOLOCK)
				WHERE	CompanyKey = @CompanyKey
				AND		MONTH(EntryDate) = #tCompanyPerf.xMonth
				AND		YEAR(EntryDate) = #tCompanyPerf.xYear)

	UPDATE	#tCompanyPerf
	SET		Checks = 
				(SELECT	COUNT(*)
				FROM	tCheck ch (NOLOCK), tCompany c (NOLOCK)
				WHERE	ch.ClientKey = c.CompanyKey
				AND		c.OwnerCompanyKey = @CompanyKey
				AND		MONTH(ch.CheckDate) = #tCompanyPerf.xMonth
				AND		YEAR(ch.CheckDate) = #tCompanyPerf.xYear)

	UPDATE	#tCompanyPerf
	SET		Payments = 
				(SELECT	COUNT(*)
				FROM	tPayment (NOLOCK)
				WHERE	CompanyKey = @CompanyKey
				AND		MONTH(PaymentDate) = #tCompanyPerf.xMonth
				AND		YEAR(PaymentDate) = #tCompanyPerf.xYear)

	UPDATE	#tCompanyPerf
	SET		Requests = 
				(SELECT	COUNT(*)
				FROM	tRequest (NOLOCK)
				WHERE	CompanyKey = @CompanyKey
				AND		MONTH(DateAdded) = #tCompanyPerf.xMonth
				AND		YEAR(DateAdded) = #tCompanyPerf.xYear)

	UPDATE	#tCompanyPerf
	SET		TimeSheets = 
				(SELECT	COUNT(*)
				FROM	tTimeSheet (NOLOCK)
				WHERE	CompanyKey = @CompanyKey
				AND		MONTH(DateCreated) = #tCompanyPerf.xMonth
				AND		YEAR(DateCreated) = #tCompanyPerf.xYear)


	UPDATE	#tCompanyPerf
	SET		ExpenseEnvelopes = 
				(SELECT	COUNT(*)
				FROM	tExpenseEnvelope (NOLOCK)
				WHERE	CompanyKey = @CompanyKey
				AND		MONTH(DateCreated) = #tCompanyPerf.xMonth
				AND		YEAR(DateCreated) = #tCompanyPerf.xYear)

	UPDATE	#tCompanyPerf
	SET		Forms = 
				(SELECT	COUNT(*)
				FROM	tForm (NOLOCK)
				WHERE	CompanyKey = @CompanyKey
				AND		MONTH(DateCreated) = #tCompanyPerf.xMonth
				AND		YEAR(DateCreated) = #tCompanyPerf.xYear)

	UPDATE	#tCompanyPerf
	SET		Approvals = 
				(SELECT	COUNT(*)
				FROM	tApproval a (NOLOCK), tProject p (NOLOCK)
				WHERE	a.ProjectKey = p.ProjectKey
				AND		p.CompanyKey = @CompanyKey
				AND		MONTH(DateCreated) = #tCompanyPerf.xMonth
				AND		YEAR(DateCreated) = #tCompanyPerf.xYear)

	SELECT	*
	FROM	#tCompanyPerf
	ORDER BY xYear desc, xMonth desc
GO
