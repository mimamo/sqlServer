USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[xvr_PA005_ActCom]    Script Date: 12/21/2015 16:12:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA005_ActCom]

AS
SELECT t.project as 'Project'
, t.pjt_entity as 'Task'
, ISNULL(a.acct, '') as 'Acct'
, ISNULL(a.tr_id03, '') as 'PONbr'
, ISNULL(a.vendor_num, '') as 'VendorID'
, ISNULL(a.voucher_num, '') as 'VouchNum'
, ISNULL(a.voucher_line, '') as 'VouchLine'
, ISNULL(a.employee, '') as 'EmployeeID'
, ISNULL(a.trans_date, '01/02/2000') as 'TranDate'
, ISNULL(CASE WHEN t.pjt_entity = '00000'AND ISNULL(a.acct, '') = 'LABOR'
				THEN 0
				WHEN ISNULL(d.ih_id12, '') = ''
				THEN a.amount 
				WHEN ISNULL(d.ih_id12, '') <> ''
				THEN -a.amount --void invoice fix
				ELSE 0 end, 0) as 'Amount'
, ISNULL(a.units, 0) as 'Units'
, 0 as 'MarkupAmount'
, ISNULL(d.amount, 0) as 'BilledAmount'
, '' as 'TranType'
, ISNULL(a.tr_id02, '') as 'InvoiceNbr'
, ISNULL(a.tr_id08, '') as 'InvoiceDate'
, ISNULL(c.acct_group_cd, 'WP') as 'AcctGroup'
, ISNULL(d.invoice_num,'') as 'ClientInvNbr'
, ISNULL(d.ih_id12,'') as 'OrigInvNbr'
, ISNULL(d.invoice_type,'') as 'Invoice_Type'
, ISNULL(a.tr_comment,'') as 'GLDescription'
, ISNULL(g.tr_comment, '') as 'GLComment'
, ISNULL(a.user2, '') as 'OrigTranID'
FROM PJPENT t (nolock) LEFT JOIN PJTRAN a (nolock) on t.Project = a.project 
		AND t.pjt_entity = a.pjt_entity 
		AND GetDate() >= a.trans_date
	LEFT JOIN PJACCT c (nolock) on  	c.acct = a.acct 
	LEFT JOIN xvr_PA005_invsum d (nolock) on d.tr_id12 = a.user2 
		AND GetDate() >= d.invoice_date 
	LEFT JOIN PJCHARGD g (nolock) ON a.detail_num = g.detail_num
		AND a.project = g.project
		AND a.pjt_entity = g.pjt_entity
		AND a.acct = g.acct
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
, a.AcctGroup
, a.ClientInvNbr
, a.OrigInvNbr
, a.Invoice_Type
, a.GLDescription
, a.GLComment
, a.OrigTranID
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
, ISNULL(SUM(CASE WHEN t.pjt_entity = '00000' AND ISNULL(a.acct, '') = 'LABOR'
			THEN 0
			WHEN c.acct_group_cd = 'CM'
			THEN 0
			ELSE CASE WHEN ISNULL(d.ih_id12, '') = ''
						THEN a.amount 
						ELSE 0 end end), 0) as 'Amount'
, ISNULL(SUM(a.units), 0) as 'Units'
, ISNULL(SUM(CASE WHEN c.acct_group_cd = 'CM'
			THEN a.amount
			ELSE 0 end), 0) as 'MarkupAmount'
, ISNULL(SUM(CASE WHEN c.acct_group_cd = 'CM'
			THEN 0
			ELSE CASE WHEN ISNULL(d.invoice_type, '') = 'REVD' 
						THEN 0 
						ELSE ISNULL(d.amount, 0) end end), 0) as 'BilledAmount'
, '' as 'TranType'
, ISNULL(a.tr_id02, '') as 'InvoiceNbr'
, ISNULL(a.tr_id08, '') as 'InvoiceDate'
, 'WP' as 'AcctGroup'
, ISNULL(d.invoice_num, '') as 'ClientInvNbr'
, ISNULL(d.ih_id12, '') as 'OrigInvNbr'
, ISNULL(d.invoice_type, '') as 'Invoice_Type' 
, ISNULL(a.tr_comment,'') as 'GLDescription'
, ISNULL(g.tr_comment, '') as 'GLComment'
, ISNULL(a.user2, '') as 'OrigTranID'
FROM PJPENT t (nolock) LEFT JOIN PJTRAN a (nolock) on t.Project = a.project 
		AND t.pjt_entity = a.pjt_entity
		AND GetDate() >= a.trans_date
	LEFT JOIN PJACCT c (nolock) on c.acct = a.acct 
	LEFT JOIN xvr_PA005_invsum d (nolock) on d.tr_id12 = a.user2
		AND GetDate() >= d.invoice_date
	LEFT JOIN PJCHARGD g (nolock) ON a.detail_num = g.detail_num
		AND a.project = g.project
		AND a.pjt_entity = g.pjt_entity
		AND a.acct = g.acct
WHERE c.acct_group_cd in ('WP', 'CM')
GROUP BY t.project, t.pjt_entity, a.acct, a.tr_id03, a.vendor_num, a.employee, a.trans_date, a.tr_id02, a.tr_id08, a.tr_comment, d.invoice_num, d.ih_id12, d.invoice_type
, c.acct_group_cd, g.tr_comment, a.voucher_num, a.voucher_line, a.user2) a
GROUP BY a.Project, a.Task, a.Acct, a.PONbr, a.VendorID, a.EmployeeID, a.TranDate, a.TranType, a.InvoiceNbr, a.InvoiceDate, a.AcctGroup
, a.ClientInvNbr, a.OrigInvNbr, a.Invoice_Type, a.GLComment, a.GLDescription, a.VouchNum, a.VouchLine, a.OrigTranID

UNION ALL

SELECT a.project as 'Project'
, a.pjt_entity as 'Task'
, a.acct as 'Acct'
, a.purchase_order_num as 'PONbr'
, a.vendor_num as 'VendorID'
, a.voucher_num as 'VouchNum'
, a.voucher_line as 'VouchLine'
, '' as 'EmployeeID'
, a.po_date as 'TranDate'
, ISNULL(CASE WHEN a.pjt_entity = '00000' AND ISNULL(a.acct, '') = 'LABOR'
	THEN 0
	ELSE a.amount end, 0) as 'Amount'
, 0 as 'Units'
, 0 as 'MarkupAmount'
, 0 as 'BilledAmount'
, 'PO' as 'TranType'
, '' as 'InvoiceNbr'
, '' as 'InvoiceDate'
, b.acct_group_cd as 'AcctGroup'
, '' as 'ClientInvNbr'
, '' as 'OrigInvNbr'
, '' as 'Invoice_Type'
, a.tr_comment as 'Description'
, '' as 'Comment'
, CONVERT(varchar(50), a.detail_num) as 'OrigTranID'
FROM PJCOMDET a (nolock) JOIN PJACCT b on a.acct = b.acct
WHERE GetDate() >= a.po_date
GO
