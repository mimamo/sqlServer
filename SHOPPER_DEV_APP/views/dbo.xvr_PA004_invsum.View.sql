USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_PA004_invsum]    Script Date: 12/21/2015 14:33:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[xvr_PA004_invsum]

AS
SELECT a.*, h.invoice_type, h.draft_num 
FROM (SELECT ISNULL(b.user2, '') as 'tr_id12'--transaction id of originating cost transaction
, max(e.invoice_num) as 'invoice_num'
, min(e.ih_id12) as 'ih_id12'
, min(e.invoice_date) as 'invoice_date'
, sum(ISNULL(d.Amount, 0)) as 'Amount'
, min(d.in_id12) as 'in_id12'
FROM PJINVDET d (nolock) JOIN PJINVHDR e (nolock) on d.draft_num = e.draft_num 
	LEFT JOIN PJTRAN b (nolock) on d.in_id12 = b.tr_id23 --transaction id of allocated transaction that ALTERd billing record
WHERE (d.bill_status = 'B' 
	AND rtrim(b.user2) <> '') --million dollar issue fix
GROUP BY b.user2) a LEFT JOIN PJINVHDR h ON a.invoice_num = h.invoice_num
GO
