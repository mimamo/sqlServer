USE [MID_DEV_APP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view xvr_BI902_MDW
as

SELECT a.*
FROM(
SELECT @RRI_ID as 'RI_ID'
, r.UserId as 'UserID'
, r.SystemDate as 'RunDate'
, r.SystemTime as 'RunTime'
, r.ComputerName as 'TerminalNum'
, p.status_pa
, d.project_billwith
, d.hold_status
, d.acct
, d.source_trx_date
, d.amount
, d.project
, d.pjt_entity
, p.project_desc
, a.sort_num
, p.pm_id01
, x.code_ID
, x.descr
, p.end_date
, d.li_type
, c.[Name]
, d.draft_num
, a.acct_group_cd
, CASE WHEN ISNULL(h.fiscalno, '') > @BegPerNbr
		THEN 'U'
		WHEN ISNULL(h.fiscalno, '') = ''
		THEN 'U'
		ELSE 'B'end as 'Bill_Status'
FROM PJINVDET d LEFT JOIN PJINVHDR h ON d.draft_num = h.draft_num
	JOIN PJPROJ p ON d.project = p.project 
	JOIN PJACCT a ON d.acct = a.acct
	LEFT JOIN xIGProdCode x ON p.pm_id02 = x.code_ID
	LEFT JOIN Customer c ON p.pm_id01 = c.CustId
	JOIN rptRuntime r ON r.RI_ID = @RRI_ID	
WHERE d.hold_status <> 'PG' 
	AND d.fiscalno <= @BegPerNbr
	AND a.acct_group_cd NOT IN ('CM', 'FE')
	AND p.project NOT IN (SELECT JobID FROM xWIPAgingException)
	AND p.contract_type <> 'APS'
	AND (substring(d.acct, 1, 6) <> 'OFFSET' OR d.acct = 'OFFSET PREBILL' OR d.acct = 'PREBILL')
	--AND d.source_trx_date <= @LongAnswer00
) a

GO