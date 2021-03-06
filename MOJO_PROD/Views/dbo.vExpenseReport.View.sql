USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vExpenseReport]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vExpenseReport]

/*
|| When     Who Rel      What
|| 07/10/07 QMD 8.5      Expense Type reference changed to tItem
|| 09/21/09 MFT 10.5.1.1 Added VendorID
|| 02/01/10 MFT 10.5.1.7 Added UserKey
|| 02/06/10 GWG 10.5.1.7 Added TransferToKey
|| 06/17/11 MFT 10.5.4.5 Added SalesTax tables, fields
|| 01/13/14 GHL 10.5.7.6 Added CurrencyID
|| 04/21/14 PLC 10.5.7.9 Only print Description if item says use description
|| 06/02/14 MFT 10.5.8.0 (218272) Backed out previous change to description
|| 08/11/14 KMC 10.5.8.3 (225566) Added the Total Tax and Total w/ Tax fields for the Expense Report
*/

AS
SELECT
	tExpenseEnvelope.ExpenseEnvelopeKey,
	tExpenseEnvelope.EnvelopeNumber,
	c.CompanyName,
	a_dc.Address1,
	a_dc.Address2,
	a_dc.Address3,
	a_dc.City, a_dc.State,
	a_dc.PostalCode,
	tUser.UserKey,
	tUser.FirstName,
	tUser.LastName,
	tUser.Email,
	tUser1.UserKey as ApprUserKey,
	tUser1.FirstName AS ApprFirstName,
	tUser1.LastName AS ApprLastName,
	tUser1.Email as ApprEmail,
	tExpenseEnvelope.StartDate,
	tExpenseEnvelope.EndDate,
	tExpenseEnvelope.Status,
	tExpenseEnvelope.DateCreated,
	tExpenseEnvelope.DateSubmitted,
	tExpenseEnvelope.DateApproved,
	tExpenseEnvelope.ApprovalComments,
	tExpenseEnvelope.Comments as HeaderComments,
	ISNULL(tExpenseEnvelope.Paid,0) AS Paid,
	tExpenseEnvelope.VoucherKey,
	tExpenseReceipt.ExpenseDate,
	tItem.ItemName,
	tProject.ProjectNumber,
	tProject.ProjectName,
	tExpenseReceipt.PaperReceipt,
	tExpenseReceipt.ActualQty,
	tExpenseReceipt.ActualUnitCost,
	tExpenseReceipt.ActualCost,
	tExpenseReceipt.Description,
	tExpenseReceipt.Comments,
	tExpenseReceipt.ExpenseReceiptKey,
	tExpenseReceipt.Markup,
	tExpenseReceipt.TransferToKey,
	ISNULL(tExpenseReceipt.Markup,0) / 100 as MarkupPct,
	tExpenseReceipt.BillableCost,
	tTask.TaskID,
	v.VendorID,
	tExpenseReceipt.Taxable AS Taxable1,
	st1.SalesTaxID AS SalesTax1ID,
	st1.SalesTaxName AS SalesTax1Name,
	tExpenseReceipt.SalesTaxAmount AS SalesTax1Amount,
	tExpenseReceipt.Taxable2 AS Taxable2,
	st2.SalesTaxID AS SalesTax2ID,
	st2.SalesTaxName AS SalesTax2Name,
	tExpenseReceipt.SalesTax2Amount,
	tExpenseReceipt.SalesTax1Amount + tExpenseReceipt.SalesTax2Amount AS TotalSalesTaxAmount,
	tExpenseReceipt.ActualCost + tExpenseReceipt.SalesTax1Amount + tExpenseReceipt.SalesTax2Amount AS TotalAmountWithTax,
	tExpenseEnvelope.CurrencyID
FROM tExpenseEnvelope
	INNER JOIN tCompany c (NOLOCK) ON tExpenseEnvelope.CompanyKey = c.CompanyKey
	LEFT OUTER JOIN tExpenseReceipt (NOLOCK) ON  tExpenseEnvelope.ExpenseEnvelopeKey = tExpenseReceipt.ExpenseEnvelopeKey
	LEFT OUTER JOIN tTask (NOLOCK) ON  tExpenseReceipt.TaskKey = tTask.TaskKey
	LEFT OUTER JOIN tUser (NOLOCK) ON tExpenseEnvelope.UserKey = tUser.UserKey
	LEFT OUTER JOIN tUser tUser1 (NOLOCK) ON  tUser.ExpenseApprover = tUser1.UserKey
	LEFT OUTER JOIN tProject (NOLOCK) ON  tExpenseReceipt.ProjectKey = tProject.ProjectKey
	LEFT OUTER JOIN tItem (NOLOCK) ON tExpenseReceipt.ItemKey = tItem.ItemKey
	LEFT OUTER JOIN tAddress a_dc (NOLOCK) ON c.DefaultAddressKey  = a_dc.AddressKey
	LEFT OUTER JOIN tCompany v (NOLOCK) ON tExpenseEnvelope.VendorKey = v.CompanyKey
	LEFT OUTER JOIN tSalesTax st1 (NOLOCK) ON tExpenseEnvelope.SalesTaxKey = st1.SalesTaxKey
	LEFT OUTER JOIN tSalesTax st2 (NOLOCK) ON tExpenseEnvelope.SalesTax2Key = st2.SalesTaxKey
GO
