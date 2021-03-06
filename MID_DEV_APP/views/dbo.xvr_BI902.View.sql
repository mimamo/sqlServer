USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_BI902]    Script Date: 12/21/2015 14:17:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BI902]

AS

SELECT p.status_pa
, d.project_billwith
, d.hold_status
, d.acct
, d.source_trx_date
, d.amount
, d.project
, d.pjt_entity
, p1.project_desc
, a.sort_num
, p.pm_id01
, x.code_ID
, x.descr
, p.end_date
, d.li_type
, c.[Name]
, d.draft_num
, a.acct_group_cd
, CASE WHEN h.fiscalno > '200911'
		THEN 'U'
		WHEN h.fiscalno = ''
		THEN 'U'
		ELSE 'B'end as 'Bill_Status'
FROM PJINVDET d LEFT JOIN PJINVHDR h ON d.draft_num = h.draft_num
	JOIN PJPROJ p ON d.project_billwith = p.project 
	JOIN PJACCT a ON d.acct = a.acct
	JOIN PJPROJ p1 ON d.project = p1.project
	LEFT JOIN xIGProdCode x ON p.pm_id02 = x.code_ID
	LEFT JOIN Customer c ON p.pm_id01 = c.CustId
WHERE d.hold_status <> 'PG' 
	--AND d.source_trx_date < '2010-02-05'
	AND d.fiscalno <= '201002'
	AND a.acct_group_cd NOT IN ('CM', 'FE')
	AND p1.project NOT IN (SELECT JobID FROM xWIPAgingException)
	AND p.contract_type <> 'APS'
	AND (substring(d.acct, 1, 6) <> 'OFFSET' OR d.acct = 'OFFSET PREBILL')
GO
