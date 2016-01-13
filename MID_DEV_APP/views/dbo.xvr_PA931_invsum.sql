USE [mid_dev_app]
GO

/****** Object:  View [dbo].[xvr_PA007_invsum]    Script Date: 01/04/2016 15:11:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[xvr_PA931_invsum]

AS

SELECT a.*, h.invoice_type
FROM (SELECT ISNULL(b.user2, '') as 'tr_id12'--transaction id of originating cost transaction
, max(e.invoice_num) as 'invoice_num'
, min(e.ih_id12) as 'ih_id12'
, min(e.invoice_date) as 'invoice_date'
, sum(ISNULL(d.Amount, 0)) as 'Amount'
, e.inv_format_cd
, e.inv_attach_cd
, e.fiscalno as 'InvFiscalNo'
FROM mid_dev_app.dbo.PJINVDET d (nolock)
inner join mid_dev_app.dbo.PJINVHDR e (nolock) 
	on d.draft_num = e.draft_num 
left join mid_dev_app.dbo.PJTRAN b (nolock) 
	on d.in_id12 = b.tr_id23 --transaction id of allocated transaction that ALTERd billing record
WHERE rtrim(b.user2) <> '' --million dollar issue fix
	AND d.bill_status = 'B'
GROUP BY b.user2, e.inv_format_cd, e.inv_attach_cd, e.fiscalno) a LEFT JOIN PJINVHDR h ON a.invoice_num = h.invoice_num




GO


