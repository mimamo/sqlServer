USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_PA007_ActCom]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA007_ActCom]

AS

SELECT c.*
FROM (
SELECT b.Project, b.Task, b.Acct, b.PONbr, b.VendorID, b.VouchNum, b.VouchLine, b.EmployeeID, b.TranDate, b.Amount, b.Units, b.MarkupAmount
, b.BilledAmount, b.TranType, b.InvoiceNbr, b.InvFiscalNo, b.InvoiceDate, b.Description, b.AcctGroup, b.ClientInvNbr, b.OrigInvNbr, b.Invoice_Type, b.OrigTranID
, b.inv_format_cd, b.inv_attach_cd, b.TransferDate, v.[Name] as 'VendName', p.pm_id01 as 'CustID', p.pm_id02 as 'ProdCode', p.project_desc
, c.[Name] as 'ClientName', x.descr as 'Product'
, CASE WHEN t.pjt_entity = '28501' 
		THEN 'TAirfare' 
		WHEN t.pjt_entity = '28502' 
		THEN 'THotel' 
		WHEN t.pjt_entity = '28503' 
		THEN 'TMeals'
		WHEN t.pjt_entity = '28504' 
		THEN 'TCarRentalTaxi' 
		WHEN t.pjt_entity = '28505' 
		THEN 'TMileage' 
		WHEN t.pjt_entity = '28506' 
		THEN 'TOther'  
		ELSE 'Other' end as 'FunctionBucket'
FROM PJPENT t JOIN PJPROJ p on t.project = p.project
	LEFT JOIN (
SELECT t.project as 'Project'
, t.pjt_entity as 'Task'
, ISNULL(a.acct, '') as 'Acct'
, ISNULL(a.tr_id03, '') as 'PONbr'
, ISNULL(a.vendor_num, '') as 'VendorID'
, ISNULL(a.voucher_num, '') as 'VouchNum'
, ISNULL(a.voucher_line, '') as 'VouchLine'
, ISNULL(a.employee, '') as 'EmployeeID'
, ISNULL(a.trans_date, '01/02/2000') as 'TranDate'
, ISNULL(CASE WHEN ISNULL(d.ih_id12, '') = ''
				THEN a.amount 
				WHEN ISNULL(d.ih_id12, '') <> ''
				THEN -a.amount --void invoice fix
				ELSE 0 end, 0) as 'Amount'
, ISNULL(a.units, 0) as 'Units'
, 0 as 'MarkupAmount'
, ISNULL(d.amount, 0) as 'BilledAmount'
, '' as 'TranType'
, ISNULL(a.tr_id02, '') as 'InvoiceNbr'
, ISNULL(a.tr_id08, '01/01/1900') as 'InvoiceDate'
, ISNULL(a.tr_comment, '') as 'Description'
, ISNULL(c.acct_group_cd, 'WP') as 'AcctGroup'
, ISNULL(d.invoice_num,'') as 'ClientInvNbr'
, ISNULL(d.ih_id12,'') as 'OrigInvNbr'
, ISNULL(d.invoice_type,'') as 'Invoice_Type'
, ISNULL(a.user2, '') as 'OrigTranID'
, d.inv_format_cd
, d.inv_attach_cd
, CASE WHEN a.batch_type = 'TFR'
		THEN a.crtd_datetime
		ELSE '01/01/1900' end as 'TransferDate'
, d.InvFiscalNo
FROM PJPENT t (nolock) LEFT JOIN PJTRAN a (nolock) on t.Project = a.project 
		AND t.pjt_entity = a.pjt_entity 
		AND GetDate() >= a.trans_date
	LEFT JOIN PJACCT c (nolock) on c.acct = a.acct 
	LEFT JOIN xvr_PA007_invsum d (nolock) on d.tr_id12 = a.user2 
		AND GetDate() >= d.invoice_date 
WHERE (c.acct_group_cd in ('FE', 'WA', 'LB','PB')  or 
		ISNULL(a.acct,'') = '') 

UNION ALL	--select for 'WP' and related 'CM' amounts

SELECT a.Project
, a.Task
, a.Acct
, a.PONbr
, a.VendorID
, a.VouchNum
, a.VouchLine
, a.EmployeeID
, a.TranDate
, SUM(a.Amount) as 'Amount'
, SUM(a.Units) as 'Units'
, SUM(a.MarkupAmount) as 'MarkupAmount'
, SUM(a.BilledAmount) as 'BilledAmount'
, a.TranType
, a.InvoiceNbr
, a.InvoiceDate
, a.Description
, a.AcctGroup
, a.ClientInvNbr
, a.OrigInvNbr
, a.Invoice_Type
, a.OrigTranID
, a.inv_format_cd
, a.inv_attach_cd
, a.TransferDate
, a.InvFiscalNo
FROM (
SELECT t.project as 'Project'
, t.pjt_entity as 'Task'
, CASE WHEN c.acct_group_cd = 'CM'
		THEN 'BILLABLE'
		ELSE ISNULL(RTRIM(a.acct), '') end as 'Acct'
, ISNULL(a.tr_id03, '') as 'PONbr'
, ISNULL(a.vendor_num, '') as 'VendorID'
, ISNULL(a.voucher_num, '') as 'VouchNum'
, ISNULL(a.voucher_line, '') as 'VouchLine'
, ISNULL(a.employee, '') as 'EmployeeID'
, ISNULL(a.trans_date, '01/02/2000') as 'TranDate'
, SUM(CASE WHEN c.acct_group_cd = 'CM'
			THEN 0
			ELSE CASE WHEN ISNULL(d.ih_id12, '') = ''
						THEN a.amount 
						ELSE 0 end end) as 'Amount'
, SUM(a.units) as 'Units'
, SUM(CASE WHEN c.acct_group_cd = 'CM'
			THEN a.amount
			ELSE 0 end) as 'MarkupAmount'
, SUM(CASE WHEN c.acct_group_cd = 'CM'
			THEN 0
			ELSE CASE WHEN ISNULL(d.invoice_type, '') = 'REVD' 
						THEN 0 
						ELSE ISNULL(d.amount, 0) end end) as 'BilledAmount'
, '' as 'TranType'
, ISNULL(a.tr_id02, '') as 'InvoiceNbr'
, ISNULL(a.tr_id08, '01/01/1900') as 'InvoiceDate'
, ISNULL(a.tr_comment, '') as 'Description'
, 'WP' as 'AcctGroup'
, ISNULL(d.invoice_num, '') as 'ClientInvNbr'
, ISNULL(d.ih_id12, '') as 'OrigInvNbr'
, ISNULL(d.invoice_type, '') as 'Invoice_Type' 
, ISNULL(a.user2, '') as 'OrigTranID'
, d.inv_format_cd
, d.inv_attach_cd
, CASE WHEN a.batch_type = 'TFR'
		THEN a.crtd_datetime
		ELSE '01/01/1900' end as 'TransferDate'
, d.InvFiscalNo
FROM PJPENT t (nolock) LEFT JOIN PJTRAN a (nolock) on t.Project = a.project 
		AND t.pjt_entity = a.pjt_entity
		AND GetDate() >= a.trans_date
	LEFT JOIN PJACCT c (nolock) on c.acct = a.acct 
	LEFT JOIN xvr_PA007_invsum d (nolock) on d.tr_id12 = a.user2
		AND GetDate() >= d.invoice_date
WHERE c.acct_group_cd in ('WP', 'CM')
GROUP BY t.project, t.pjt_entity, a.acct, a.tr_id03, a.vendor_num, a.employee, a.trans_date, a.tr_id02, a.tr_id08, a.tr_comment, d.invoice_num, d.ih_id12, d.invoice_type
, c.acct_group_cd, a.voucher_num, a.voucher_line, a.user2, d.inv_format_cd, d.inv_attach_cd, a.batch_type, a.crtd_datetime, d.InvFiscalNo) a
GROUP BY a.Project, a.Task, a.Acct, a.PONbr, a.VendorID, a.EmployeeID, a.TranDate, a.TranType, a.InvoiceNbr, a.InvoiceDate, a.Description, a.AcctGroup
, a.ClientInvNbr, a.OrigInvNbr, a.Invoice_Type, a.VouchNum, a.VouchLine, a.OrigTranID, a.inv_format_cd, a.inv_attach_cd, a.TransferDate, a.InvFiscalNo) b ON t.project = b.project
		AND t.pjt_entity = b.task
	LEFT JOIN Vendor v ON b.VendorID = v.vendID
	LEFT JOIN xIGProdCode x ON p.pm_id02 = x.code_ID
	LEFT JOIN Customer c ON p.pm_id01 = c.custID) c
WHERE c.InvoiceDate <> '01/01/1900'
	AND c.BilledAmount <> 0
GO
