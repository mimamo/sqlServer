USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_PA942_BillHist]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA942_BillHist]

AS

SELECT b.Project, sum(b.Amount) as 'InvoiceAmt', sum(b.Payment) as 'Payment', ROUND(sum(b.Amount) - sum(b.Payment), 2) as 'Balance'
FROM (
SELECT 'ARDoc' as 'Source'
, ProjectID as 'Project'
, DocType as 'DocType'
, RefNbr as 'InvoiceNbr'
, '' as 'CheckNbr'
, DocDate as 'DocDate'
, CASE WHEN DocType in ('IN', 'DM', 'FI', 'SC', 'CS')
	THEN OrigDocAmt 
	ELSE -OrigDocAmt end as 'Amount'
, CASE WHEN DocType = 'CS'
		THEN OrigDocAmt
		ELSE 0 end as 'Payment'
FROM ARDoc(nolock)
WHERE GetDate() >= DocDate
	AND doctype in ('IN', 'DM', 'CM', 'FI', 'SB', 'SC', 'CS')
	AND projectid <> ''

UNION ALL

SELECT 'PJARPay' as 'Source'
, a.Project as 'Project'
, a.DocType as 'DocType'
, a.InvoiceNbr as 'InvoiceNbr'
, a.CheckNbr as 'CheckNbr'
, a.DocDate as 'DocDate'
, 0 as 'Amount'
, a.Amount as 'Payment'
FROM (SELECT c.adjgdoctype as 'DocType'
, c.adjgrefnbr as 'CheckNbr'
, c.adjgdocdate as 'DocDate'
, c.CuryAdjgAmt as 'Amount'
, a.custid as 'CustID'
, a.discount_amt as 'Discount'
, a.invoice_refnbr as 'InvoiceNbr'
, a.Invoice_type as 'InvoiceType'
, b.projectid as 'Project'
, c.recordid as 'AdjRecordid'
FROM PJARPay a (nolock) JOIN ARDoc b (nolock) on a.custid = b.custid 
		AND	a.invoice_type = b.doctype 
		AND	a.invoice_refnbr = b.refnbr 
	JOIN ARADJUST c (nolock) on	a.custid = c.custid 
		AND	a.invoice_type = c.AdjdDocType 
		AND	a.invoice_refnbr = c.AdjdRefNbr
WHERE GetDate() >= c.adjgdocdate 
	AND a.doctype = 'PA') a) b
GROUP BY b.Project
HAVING (sum(b.Amount) <> 0 AND sum(b.Payment) <> 0)
	AND sum(b.Amount) - sum(b.Payment) <> 0
GO
