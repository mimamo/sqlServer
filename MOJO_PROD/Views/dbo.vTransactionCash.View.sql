USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vTransactionCash]    Script Date: 12/21/2015 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vTransactionCash]
AS

/*
|| When      Who Rel     What
|| 5/9/07    CRG 8.4.3   (8874) Created for the Cash Basis Transaction Drilldown
|| 8/20/07   GHL 8.5     Resolved ambiguity about DepartmentKey, OfficeKey
|| 10/5/07   CRG 8.5     Added GLCompanyKey, DepartmentName, OfficeID, OfficeName, GLCompanyID, GLCompanyName
|| 4/24/08   CRG 8.5.0.0 (24089) Fixed Join in Payment section to eliminate cartesian product
|| 10/13/11  GHL 10.459  Added new entity CREDITCARD 
|| 11/03/11  GHL 10.459  Added contribution of credit card payments to real voucher
||                       See logic in spRptCorpPLCash
|| 07/12/13  WDF 10.5.7.0 (176497) Added VoucherID
|| 12/31/13  GHL 10.5.7.5 Added conversion to home currency
*/

--Journal Entries
SELECT 	TransactionKey,
		CompanyKey,
		DateCreated,
		TransactionDate AS PostingDate, --Call it PostingDate since all other Entities use PostingDate
		Entity,
		EntityKey,
		Reference,
		GLAccountKey,
		Debit,
		Credit,
		ClassKey,
		Memo,
		PostMonth,
		PostYear,
		ProjectKey,
		SourceCompanyKey,
		Cleared,
		ClientKey,
		AccountNumber,
		AccountName,
		AccountType,
		ParentAccountKey,
		ClassID,
		ClassName,
		ProjectNumber,
		ProjectName,
		CompanyName,
		ClientID,
		VendorID,
		DepartmentKey,
		DepartmentName,
		OfficeKey,
		OfficeID,
		OfficeName,
		GLCompanyKey,
		GLCompanyID,
		GLCompanyName,
		NULL AS CheckPostingDate, --Used for Invoices with Client Payments (adv bill)
		NULL AS VoucherID,
		CurrencyID
FROM  	vTransaction 
WHERE 	Entity = 'GENJRNL'		

UNION

--Vouchers with Vendor Payments
SELECT 	TransactionKey,
		CompanyKey,
		DateCreated,
		b.PostingDate,
		Entity,
		EntityKey,
		Reference,
		GLAccountKey,
		(t.Debit * b.PaidAmount) / b.TotalAmount, --Debit
		(t.Credit * b.PaidAmount) / b.TotalAmount, --Credit
		ClassKey,
		Memo,
		PostMonth,
		PostYear,
		ProjectKey,
		SourceCompanyKey,
		Cleared,
		ClientKey,
		AccountNumber,
		AccountName,
		AccountType,
		ParentAccountKey,
		ClassID,
		ClassName,
		ProjectNumber,
		ProjectName,
		CompanyName,
		ClientID,
		VendorID,
		t.DepartmentKey,
		t.DepartmentName,
		t.OfficeKey,
		t.OfficeID,
		t.OfficeName,
		t.GLCompanyKey,
		t.GLCompanyID,
		t.GLCompanyName,
		NULL,
		t.VoucherID,
		t.CurrencyID
FROM	vTransaction t
INNER JOIN 
		(SELECT	tVoucher.VoucherKey,
				Sum(tPaymentDetail.Amount) as PaidAmount, 
				tVoucher.VoucherTotal as TotalAmount,
				tPayment.PostingDate
		FROM	tVoucher (nolock)
		INNER JOIN tPaymentDetail (nolock) on tVoucher.VoucherKey = tPaymentDetail.VoucherKey
		INNER JOIN tPayment (nolock) on tPaymentDetail.PaymentKey = tPayment.PaymentKey
		WHERE 	tPayment.Posted = 1
		AND		tVoucher.VoucherTotal <> 0
		GROUP BY tVoucher.VoucherKey, tVoucher.VoucherTotal, tPayment.PostingDate) As b ON t.EntityKey = b.VoucherKey 
WHERE	t.Entity in ('VOUCHER', 'CREDITCARD')
AND		t.AccountType IN (40, 41, 50, 51, 52)

UNION

--Vouchers with payments (against credit cards)
SELECT 	TransactionKey,
		CompanyKey,
		DateCreated,
		b.PostingDate,
		Entity,
		EntityKey,
		Reference,
		GLAccountKey,
		(t.Debit * b.PaidAmount) / b.TotalAmount, --Debit
		(t.Credit * b.PaidAmount) / b.TotalAmount, --Credit
		ClassKey,
		Memo,
		PostMonth,
		PostYear,
		ProjectKey,
		SourceCompanyKey,
		Cleared,
		ClientKey,
		AccountNumber,
		AccountName,
		AccountType,
		ParentAccountKey,
		ClassID,
		ClassName,
		ProjectNumber,
		ProjectName,
		CompanyName,
		ClientID,
		VendorID,
		t.DepartmentKey,
		t.DepartmentName,
		t.OfficeKey,
		t.OfficeID,
		t.OfficeName,
		t.GLCompanyKey,
		t.GLCompanyID,
		t.GLCompanyName,
		b.CheckPostingDate,
		t.VoucherID,
		t.CurrencyID
FROM	vTransaction t
INNER JOIN 
		(SELECT vcc.VoucherKey, 
				real_v.VoucherTotal AS TotalAmount,
				SUM(vcc.Amount * invDet.PaidAmount / invDet.TotalAmount) AS PaidAmount,
				invDet.CheckPostingDate,
				real_v.PostingDate
		FROM	tVoucherCC vcc (NOLOCK)
		INNER JOIN tVoucher real_v (NOLOCK) ON vcc.VoucherKey = real_v.VoucherKey
		INNER JOIN 
				(SELECT	tVoucher.VoucherKey,
						SUM(tPaymentDetail.Amount) AS PaidAmount,
						tVoucher.VoucherTotal AS TotalAmount,
						tPayment.PostingDate AS CheckPostingDate
				FROM	tPayment (NOLOCK)
				INNER JOIN tPaymentDetail (NOLOCK) ON tPayment.PaymentKey = tPaymentDetail.PaymentKey
				INNER JOIN tVoucher (NOLOCK) ON tPaymentDetail.VoucherKey = tVoucher.VoucherKey
				WHERE	tVoucher.CreditCard = 1
				AND		tPayment.Posted = 1
				AND		tVoucher.VoucherTotal <> 0
				GROUP BY tVoucher.VoucherKey, tVoucher.VoucherTotal, tPayment.PostingDate) AS invDet ON vcc.VoucherCCKey = invDet.VoucherKey
		GROUP BY vcc.VoucherKey, real_v.VoucherTotal, invDet.CheckPostingDate, real_v.PostingDate) AS b ON t.EntityKey = b.VoucherKey
WHERE	t.Entity = 'VOUCHER' -- only real vouchers
AND		t.AccountType IN (40, 41, 50, 51, 52)

UNION

--Invoices with Client Payments (non adv bill)
SELECT 	TransactionKey,
		CompanyKey,
		DateCreated,
		b.PostingDate,
		Entity,
		EntityKey,
		Reference,
		GLAccountKey,
		(t.Debit * b.PaidAmount) / b.TotalAmount, --Debit
		(t.Credit * b.PaidAmount) / b.TotalAmount, --Credit
		ClassKey,
		Memo,
		PostMonth,
		PostYear,
		ProjectKey,
		SourceCompanyKey,
		Cleared,
		ClientKey,
		AccountNumber,
		AccountName,
		AccountType,
		ParentAccountKey,
		ClassID,
		ClassName,
		ProjectNumber,
		ProjectName,
		CompanyName,
		ClientID,
		VendorID,
		t.DepartmentKey,
		t.DepartmentName,
		t.OfficeKey,
		t.OfficeID,
		t.OfficeName,
		t.GLCompanyKey,
		t.GLCompanyID,
		t.GLCompanyName,
		NULL,
		NULL,
		t.CurrencyID
FROM	vTransaction t
INNER JOIN 
		(SELECT	tInvoice.InvoiceKey,
				Sum(tCheckAppl.Amount) as PaidAmount, 
				tInvoice.InvoiceTotalAmount as TotalAmount,
				tCheck.PostingDate
		FROM	tCheck (nolock)
		INNER JOIN tCheckAppl (nolock) on tCheck.CheckKey = tCheckAppl.CheckKey
		INNER JOIN tInvoice (nolock) on tCheckAppl.InvoiceKey = tInvoice.InvoiceKey
		WHERE 	tInvoice.AdvanceBill = 0
		AND		tCheck.Posted = 1
		AND		tInvoice.InvoiceTotalAmount <> 0
		GROUP BY tInvoice.InvoiceKey, tInvoice.InvoiceTotalAmount, tCheck.PostingDate) As b ON t.EntityKey = b.InvoiceKey 
WHERE	t.Entity = 'INVOICE'
AND		t.AccountType IN (40, 41, 50, 51, 52)

UNION

--Invoices with client payments (adv bill)
SELECT 	TransactionKey,
		CompanyKey,
		DateCreated,
		b.PostingDate,
		Entity,
		EntityKey,
		Reference,
		GLAccountKey,
		(t.Debit * b.PaidAmount) / b.TotalAmount, --Debit
		(t.Credit * b.PaidAmount) / b.TotalAmount, --Credit
		ClassKey,
		Memo,
		PostMonth,
		PostYear,
		ProjectKey,
		SourceCompanyKey,
		Cleared,
		ClientKey,
		AccountNumber,
		AccountName,
		AccountType,
		ParentAccountKey,
		ClassID,
		ClassName,
		ProjectNumber,
		ProjectName,
		CompanyName,
		ClientID,
		VendorID,
		t.DepartmentKey,
		t.DepartmentName,
		t.OfficeKey,
		t.OfficeID,
		t.OfficeName,
		t.GLCompanyKey,
		t.GLCompanyID,
		t.GLCompanyName,
		b.CheckPostingDate,
		NULL,
		t.CurrencyID
FROM	vTransaction t
INNER JOIN 
		(SELECT iab.InvoiceKey, 
				inv.InvoiceTotalAmount AS TotalAmount,
				SUM(iab.Amount * invDet.PaidAmount / invDet.TotalAmount) AS PaidAmount,
				invDet.CheckPostingDate,
				inv.PostingDate
		FROM	tInvoiceAdvanceBill iab (NOLOCK)
		INNER JOIN tInvoice inv (NOLOCK) ON iab.InvoiceKey = inv.InvoiceKey
		INNER JOIN 
				(SELECT	tInvoice.InvoiceKey,
						SUM(tCheckAppl.Amount) AS PaidAmount,
						tInvoice.InvoiceTotalAmount AS TotalAmount,
						tCheck.PostingDate AS CheckPostingDate
				FROM	tCheck (NOLOCK)
				INNER JOIN tCheckAppl (NOLOCK) ON tCheck.CheckKey = tCheckAppl.CheckKey
				INNER JOIN tInvoice (NOLOCK) ON tCheckAppl.InvoiceKey = tInvoice.InvoiceKey
				WHERE	tInvoice.AdvanceBill = 1
				AND		tCheck.Posted = 1
				AND		tInvoice.InvoiceTotalAmount <> 0
				GROUP BY tInvoice.InvoiceKey, tInvoice.InvoiceTotalAmount, tCheck.PostingDate) AS invDet ON iab.AdvBillInvoiceKey = invDet.InvoiceKey
		GROUP BY iab.InvoiceKey, inv.InvoiceTotalAmount, invDet.CheckPostingDate, inv.PostingDate) AS b ON t.EntityKey = b.InvoiceKey
WHERE	t.Entity = 'INVOICE'
AND		t.AccountType IN (40, 41, 50, 51, 52)

UNION

--Payments and Expense Accounts
SELECT 	TransactionKey,
		t.CompanyKey,
		DateCreated,
		p.PostingDate,
		Entity,
		EntityKey,
		Reference,
		t.GLAccountKey,
		round(pd.Amount * p.ExchangeRate, 2), --Debit
		0, --Credit
		t.ClassKey,
		t.Memo,
		PostMonth,
		PostYear,
		ProjectKey,
		SourceCompanyKey,
		Cleared,
		ClientKey,
		AccountNumber,
		AccountName,
		AccountType,
		ParentAccountKey,
		ClassID,
		ClassName,
		ProjectNumber,
		ProjectName,
		CompanyName,
		ClientID,
		VendorID,
		t.DepartmentKey,
		t.DepartmentName,
		t.OfficeKey,
		t.OfficeID,
		t.OfficeName,
		t.GLCompanyKey,
		t.GLCompanyID,
		t.GLCompanyName,
		NULL,
		NULL,
		t.CurrencyID
FROM	vTransaction t
INNER JOIN tPayment p (NOLOCK) ON t.EntityKey = p.PaymentKey
INNER JOIN tPaymentDetail pd (NOLOCK) ON pd.PaymentKey = p.PaymentKey AND pd.GLAccountKey = t.GLAccountKey
WHERE	t.Entity = 'PAYMENT'
AND		t.AccountType IN (40, 41, 50, 51, 52)
AND		p.Posted = 1
AND		ISNULL(pd.VoucherKey, 0) = 0

UNION

--Receipts and Expense Accounts
SELECT 	TransactionKey,
		t.CompanyKey,
		DateCreated,
		c.PostingDate,
		Entity,
		EntityKey,
		Reference,
		t.GLAccountKey,
		0, --Debit
		round(cappl.Amount * c.ExchangeRate,2),  --Credit
		t.ClassKey,
		t.Memo,
		PostMonth,
		PostYear,
		ProjectKey,
		SourceCompanyKey,
		Cleared,
		t.ClientKey,
		AccountNumber,
		AccountName,
		AccountType,
		ParentAccountKey,
		ClassID,
		ClassName,
		ProjectNumber,
		ProjectName,
		CompanyName,
		ClientID,
		VendorID,
		t.DepartmentKey,
		t.DepartmentName,
		t.OfficeKey,
		t.OfficeID,
		t.OfficeName,
		t.GLCompanyKey,
		t.GLCompanyID,
		t.GLCompanyName,
		NULL,
		NULL,
		t.CurrencyID
FROM	vTransaction t
INNER JOIN tCheck c (NOLOCK) ON t.EntityKey = c.CheckKey
INNER JOIN tCheckAppl cappl (NOLOCK) ON c.CheckKey = cappl.CheckKey
WHERE	t.Entity = 'RECEIPT'
AND		t.AccountType IN (40, 41, 50, 51, 52)
AND		c.Posted = 1
AND		ISNULL(cappl.InvoiceKey, 0) = 0
GO
