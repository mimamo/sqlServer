USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_BI800]    Script Date: 12/21/2015 14:10:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BI800]

AS

SELECT h.invoice_num as 'RvrslInvNum'
, h.invoice_date as 'RvrslInvDate'
, h.curygross_amt as 'RvrslInvAmount'
, h.fiscalno as 'RvrslFiscalno'
, h.project_billwith as 'RvrslJobID'
, h.crtd_user as 'RvrslBiller'
, a.invoice_num as 'OrgInvNum'
, a.invoice_date as 'OrgInvDate'
, a.curygross_amt as 'OrgInvAmount'
, a.project_billwith as 'OrgJobID'
, a.fiscalno as 'OrgFiscalNo'
, a.crtd_user as 'OrgBiller'
FROM
(SELECT invoice_num, invoice_date, end_date, curygross_amt, invoice_type, ih_id12, project_billwith, fiscalno, crtd_user
FROM PJINVHDR
WHERE invoice_type = 'REVD') a LEFT JOIN PJINVHDR h ON a.invoice_num = h.ih_id12
GO
