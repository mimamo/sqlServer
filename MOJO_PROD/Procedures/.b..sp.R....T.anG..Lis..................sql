USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranGetList]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRecurTranGetList]
	@CompanyKey int,
	@UserKey int = 0,
	@AutomaticMode int = 0,
	@AllUsers tinyint = 0

AS

  /*
  || When     Who Rel    What
  || 03/02/10 GHL 10.519 Added Automatic mode for Task Manager
  ||                     The stored proc should operate in 3 modes
  ||                     1) On the listing, pull all records for the company
  ||                     2) On the reminder widget, pull active records for a user and reminder option = 'Show Reminder'
  ||                     3) In the Task Manager, pull active records for the server and reminder option = 'Automatically Create'
  ||
  ||                     Parameters:
  ||                     1) CK > 0, UK = 0, Automatic Mode = 0
  ||                     2) CK > 0, UK > 0, Automatic Mode = 0
  ||                     3) CK = X, UK = X, Automatic Mode = 1 where X = Don't Care
  || 01/31/11 RLB 10.540 (101180) Added Vendor ID and Amount to Schedule Transaction Widget
  || 11/03/11 GHL 10.549 Added support of credit card charges
  || 08/21/12 MFT 10.559 Added @AllUsers parameter to support GLCompany restrictions, put @AutomaticMode test first
  ||                     @UserKey is always expected and used when not in AutomaticMode
  */

IF @AutomaticMode = 0
	BEGIN --UI MODE
		IF ISNULL(@AllUsers, 0) = 0
			BEGIN --USER-SPECIFIC
				select rt.*,
					CASE
						WHEN rt.Entity = 'INVOICE' THEN (Select InvoiceNumber from tInvoice (nolock) Where InvoiceKey = rt.EntityKey)
						WHEN rt.Entity = 'RECEIPT' THEN (Select ReferenceNumber from tCheck (nolock) Where CheckKey = rt.EntityKey)
						WHEN rt.Entity IN('VOUCHER', 'CREDITCARD') THEN (Select InvoiceNumber from tVoucher (nolock) Where VoucherKey = rt.EntityKey)
						WHEN rt.Entity = 'PAYMENT' THEN (Select CheckNumber from tPayment (nolock) Where PaymentKey = rt.EntityKey)
						WHEN rt.Entity = 'GENJRNL' THEN (Select JournalNumber from tJournalEntry (nolock) Where JournalEntryKey = rt.EntityKey)
					end as TransactionReference
					,CASE
						WHEN rt.Entity = 'INVOICE' THEN (Select CustomerID from tInvoice i (nolock) inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey Where InvoiceKey = rt.EntityKey)
						WHEN rt.Entity = 'RECEIPT' THEN (Select CustomerID from tCheck ck (nolock) inner join tCompany c (nolock) on ck.ClientKey = c.CompanyKey Where CheckKey = rt.EntityKey)
						WHEN rt.Entity IN('VOUCHER', 'CREDITCARD') THEN (Select VendorID from tVoucher v (nolock) inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey Where VoucherKey = rt.EntityKey)
						WHEN rt.Entity = 'PAYMENT' THEN (Select VendorID from tPayment p (nolock) inner join tCompany c (nolock) on p.VendorKey = c.CompanyKey Where PaymentKey = rt.EntityKey)
						WHEN rt.Entity = 'GENJRNL' THEN 'None'
						end as VendorID
					,CASE
						WHEN rt.Entity = 'INVOICE' THEN (Select InvoiceTotalAmount from tInvoice (nolock) Where InvoiceKey = rt.EntityKey)
						WHEN rt.Entity = 'RECEIPT' THEN (Select CheckAmount from tCheck (nolock) Where CheckKey = rt.EntityKey)
						WHEN rt.Entity IN('VOUCHER', 'CREDITCARD') THEN (Select VoucherTotal from tVoucher (nolock) Where VoucherKey = rt.EntityKey)
						WHEN rt.Entity = 'PAYMENT' THEN (Select PaymentAmount from tPayment (nolock) Where PaymentKey = rt.EntityKey)
						WHEN rt.Entity = 'GENJRNL' THEN (ISNULL((Select SUM(DebitAmount) from tJournalEntry je (nolock) inner join tJournalEntryDetail jed (nolock) on je.JournalEntryKey = jed.JournalEntryKey Where je.JournalEntryKey = rt.EntityKey), 0))
					end as Amount
				 ,case
					when rt.Entity = 'INVOICE' then (ISNULL((
					select count(*) from tInvoice i (nolock) where i.CompanyKey = rt.CompanyKey and i.RecurringParentKey = rt.EntityKey and i.InvoiceKey <> rt.EntityKey
					), 0))
					when rt.Entity = 'RECEIPT' then (ISNULL((
					select count(*) from tCheck c (nolock) where c.CompanyKey = rt.CompanyKey and c.RecurringParentKey = rt.EntityKey and c.CheckKey <> rt.EntityKey
					), 0))
					when rt.Entity IN('VOUCHER', 'CREDITCARD') then (ISNULL((
					select count(*) from tVoucher v (nolock) where v.CompanyKey = rt.CompanyKey and v.RecurringParentKey = rt.EntityKey and v.VoucherKey <> rt.EntityKey
					), 0))
					when rt.Entity = 'PAYMENT' then (ISNULL((
					select count(*) from tPayment p (nolock) where p.CompanyKey = rt.CompanyKey and p.RecurringParentKey = rt.EntityKey and p.PaymentKey <> rt.EntityKey
					), 0))
					when rt.Entity = 'GENJRNL' then (ISNULL((
					select count(*) from tJournalEntry je (nolock) where je.CompanyKey = rt.CompanyKey and je.RecurringParentKey = rt.EntityKey and je.JournalEntryKey <> rt.EntityKey
					), 0))
					end as NumberGenerated
				From tRecurTran rt (nolock)
					inner join tRecurTranUser rtu (nolock) on rt.RecurTranKey = rtu.RecurTranKey
				Where CompanyKey = @CompanyKey
					and rtu.UserKey = @UserKey
					and ReminderOption = 'Show Reminder'
					and (NextDate is null OR NextDate <= DATEADD(d, ISNULL(DaysInAdvance, 0), GETDATE()))
					and Active = 1
					and NumberRemaining > 0
				Order By Entity, NextDate
			END --USER-SPECIFIC
		ELSE
			BEGIN --ALL USERS
				------------------------------------------------------------
				--GL Company restrictions
				DECLARE @RestrictToGLCompany tinyint
				DECLARE @tGLCompanies table (GLCompanyKey int)
				SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
				FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey
				
				IF @RestrictToGLCompany = 0
					BEGIN --@RestrictToGLCompany = 0
						--All GLCompanyKeys + 0 to get NULLs
						INSERT INTO @tGLCompanies VALUES(0)
						INSERT INTO @tGLCompanies
							SELECT GLCompanyKey
							FROM tGLCompany (nolock)
							WHERE CompanyKey = @CompanyKey
					END --@RestrictToGLCompany = 0
				ELSE
					BEGIN --@RestrictToGLCompany = 1
						 --Only GLCompanyKeys @UserKey has access to
						INSERT INTO @tGLCompanies
							SELECT GLCompanyKey
							FROM tUserGLCompanyAccess (nolock)
							WHERE UserKey = @UserKey
					END --@RestrictToGLCompany = 1
				--GL Company restrictions
				------------------------------------------------------------
				SELECT *
					,TransactionReference
					,CASE
						WHEN rt.Entity = 'INVOICE' THEN (ISNULL((
						SELECT COUNT(*) FROM tInvoice i (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(i.GLCompanyKey, 0) WHERE i.CompanyKey = rt.CompanyKey and i.RecurringParentKey = rt.EntityKey and i.InvoiceKey <> rt.EntityKey
						), 0))
						WHEN rt.Entity = 'RECEIPT' THEN (ISNULL((
						SELECT COUNT(*) FROM tCheck c (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(c.GLCompanyKey, 0) WHERE c.CompanyKey = rt.CompanyKey and c.RecurringParentKey = rt.EntityKey and c.CheckKey <> rt.EntityKey
						), 0))
						WHEN rt.Entity IN('VOUCHER', 'CREDITCARD') THEN (ISNULL((
						SELECT COUNT(*) FROM tVoucher v (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(v.GLCompanyKey, 0) WHERE v.CompanyKey = rt.CompanyKey and v.RecurringParentKey = rt.EntityKey and v.VoucherKey <> rt.EntityKey
						), 0))
						WHEN rt.Entity = 'PAYMENT' THEN (ISNULL((
						SELECT COUNT(*) FROM tPayment p (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(p.GLCompanyKey, 0) WHERE p.CompanyKey = rt.CompanyKey and p.RecurringParentKey = rt.EntityKey and p.PaymentKey <> rt.EntityKey
						), 0))
						WHEN rt.Entity = 'GENJRNL' THEN (ISNULL((
						SELECT COUNT(*) FROM tJournalEntry je (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(je.GLCompanyKey, 0) WHERE je.CompanyKey = rt.CompanyKey and je.RecurringParentKey = rt.EntityKey and je.JournalEntryKey <> rt.EntityKey
						), 0))
					END AS NumberGenerated
				FROM
					tRecurTran rt (nolock)
					INNER JOIN (
						SELECT
							RecurTranKey,
							CASE
								WHEN Entity = 'INVOICE' THEN (Select InvoiceNumber from tInvoice i (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(i.GLCompanyKey, 0) Where InvoiceKey = EntityKey)
								WHEN Entity = 'RECEIPT' THEN (Select ReferenceNumber from tCheck c (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(c.GLCompanyKey, 0) Where CheckKey = EntityKey)
								WHEN Entity IN ('VOUCHER', 'CREDITCARD') THEN (Select InvoiceNumber from tVoucher v (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(v.GLCompanyKey, 0) Where VoucherKey = EntityKey)
								WHEN Entity = 'PAYMENT' THEN (Select CheckNumber from tPayment p (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(p.GLCompanyKey, 0) Where PaymentKey = EntityKey)
								WHEN Entity = 'GENJRNL' THEN (Select JournalNumber from tJournalEntry je (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(je.GLCompanyKey, 0) Where JournalEntryKey = EntityKey)
							END AS TransactionReference,
							CASE
								WHEN Entity = 'INVOICE' THEN (Select InvoiceKey from tInvoice i (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(i.GLCompanyKey, 0) Where InvoiceKey = EntityKey)
								WHEN Entity = 'RECEIPT' THEN (Select CheckKey from tCheck c (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(c.GLCompanyKey, 0) Where CheckKey = EntityKey)
								WHEN Entity IN ('VOUCHER', 'CREDITCARD') THEN (Select VoucherKey from tVoucher v (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(v.GLCompanyKey, 0) Where VoucherKey = EntityKey)
								WHEN Entity = 'PAYMENT' THEN (Select PaymentKey from tPayment p (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(p.GLCompanyKey, 0) Where PaymentKey = EntityKey)
								WHEN Entity = 'GENJRNL' THEN (Select JournalEntryKey from tJournalEntry je (nolock) INNER JOIN @tGLCompanies glc ON glc.GLCompanyKey = ISNULL(je.GLCompanyKey, 0) Where JournalEntryKey = EntityKey)
							END AS EntityKey
						FROM tRecurTran
						) a ON rt.RecurTranKey = a.RecurTranKey AND rt.EntityKey = a.EntityKey
				WHERE rt.CompanyKey = @CompanyKey
				ORDER BY rt.Entity, rt.NextDate
			END --ALL USERS
	END --UI MODE
ELSE
	--AUTOMATIC MODE
	select rt.RecurTranKey, rt.Entity, rt.EntityKey
	,CASE
		WHEN rt.Entity = 'INVOICE' THEN (Select InvoiceNumber from tInvoice (nolock) Where InvoiceKey = rt.EntityKey)
		WHEN rt.Entity = 'RECEIPT' THEN (Select ReferenceNumber from tCheck (nolock) Where CheckKey = rt.EntityKey)
		WHEN rt.Entity IN('VOUCHER', 'CREDITCARD') THEN (Select InvoiceNumber from tVoucher (nolock) Where VoucherKey = rt.EntityKey)
		WHEN rt.Entity = 'PAYMENT' THEN (Select CheckNumber from tPayment (nolock) Where PaymentKey = rt.EntityKey)
		WHEN rt.Entity = 'GENJRNL' THEN (Select JournalNumber from tJournalEntry (nolock) Where JournalEntryKey = rt.EntityKey)
	end as TransactionReference
	from   tRecurTran rt (nolock)
	inner  join tCompany c (nolock) on rt.CompanyKey = c.CompanyKey
	Where  c.Active = 1
	and    c.Locked = 0
	and    rt.ReminderOption = 'Automatically Create'
	and    (rt.NextDate is null OR rt.NextDate <= DATEADD(d, ISNULL(rt.DaysInAdvance, 0), GETDATE()))
	and    rt.Active = 1
	and    rt.NumberRemaining > 0
GO
