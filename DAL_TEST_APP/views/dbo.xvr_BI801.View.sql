USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_BI801]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BI801]

AS

SELECT c.*
, ISNULL(i.invoice_num, '') as 'D3InvoiceNum'
, ISNULL(i.invoice_date, '') as 'D3InvoiceDate'
, ISNULL(i.end_date, '') as 'D3EndDate'
, ISNULL(i.curygross_amt, 0) as 'D3InvoiceAmount'
, ISNULL(i.invoice_type, '') as 'D3InvoiceType'
, ISNULL(i.ih_id12, '') as 'D3PreviousInvoice'
, ISNULL(i.project_billwith, '') as 'D3ProjcetBillwith'
, ISNULL(i.fiscalno, '') as 'D3FiscalNo'
, ISNULL(i.crtd_user, '') as 'D3Biller'
FROM (
SELECT b.*
, ISNULL(i.invoice_num, '') as 'D2InvoiceNum'
, ISNULL(i.invoice_date, '') as 'D2InvoiceDate'
, ISNULL(i.end_date, '') as 'D2EndDate'
, ISNULL(i.curygross_amt, 0) as 'D2InvoiceAmount'
, ISNULL(i.invoice_type, '') as 'D2InvoiceType'
, ISNULL(i.ih_id12, '') as 'D2PreviousInvoice'
, ISNULL(i.project_billwith, '') as 'D2ProjcetBillwith'
, ISNULL(i.fiscalno, '') as 'D2FiscalNo'
, ISNULL(i.crtd_user, '') as 'D2Biller' 
FROM (
SELECT a.invoice_num as 'RInvoiceNum'
, a.invoice_date as 'RInvoiceDate'
, a.end_date as 'REndDate'
, a.curygross_amt as 'RInvoiceAmount'
, a.invoice_type as 'RInvoiceType'
, a.ih_id12 as 'RPreviousInvoice'
, a.project_billwith as 'RProjectBillwith'
, a.fiscalno as 'RFiscalno'
, a.crtd_user as 'RBiller'
, i.invoice_num as 'DInvoiceNum'
, i.invoice_date as 'DInvoiceDate'
, i.end_date as 'DEndDate'
, i.curygross_amt as 'DInvoiceAmount'
, i.invoice_type as 'DInvoiceType'
, i.ih_id12 as 'DPreviousInvoice'
, i.project_billwith as 'DProjcetBillwith'
, i.fiscalno as 'DFiscalNo'
, i.crtd_user as 'DBiller'
FROM
(SELECT invoice_num, invoice_date, end_date, curygross_amt, invoice_type, ih_id12, project_billwith, fiscalno, crtd_user
FROM PJINVHDR
WHERE invoice_type = 'REVR'
) a LEFT JOIN PJINVHDR i ON a.ih_id12 = i.invoice_num
) b LEFT JOIN PJINVHDR i ON b.DPreviousInvoice = i.invoice_num
	AND b.DPreviousInvoice <> ''
) c LEFT JOIN PJINVHDR i ON c.D2PreviousInvoice = i.invoice_num
	AND c.D2PreviousInvoice <> ''
GO
