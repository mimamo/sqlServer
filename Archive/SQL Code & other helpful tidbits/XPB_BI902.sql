declare @BegPerNbr int
set @BegPerNbr = '201212'

SELECT a.*
FROM(
SELECT p.status_pa
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
WHERE d.hold_status <> 'PG' 
	AND d.fiscalno <= @BegPerNbr
	AND a.acct_group_cd NOT IN ('CM', 'FE')
	AND p.project NOT IN (SELECT JobID FROM xWIPAgingException)
	AND p.contract_type <> 'APS'
	AND (substring(d.acct, 1, 6) <> 'OFFSET' OR d.acct = 'OFFSET PREBILL' OR d.acct = 'PREBILL')
	--AND d.source_trx_date <= @LongAnswer00
	and p.project IN ('00017812AGY','00017912AGY','00017612AGY','00017712AGY','00018012AGY','00017512AGY')
) a

-- Update Prebill entries
select project, amount, * from PJTran 
where acct = 'prebill' 
and project = '00017512agy'
and project IN ('00017812AGY','00017912AGY','00017612AGY','00017712AGY','00018012AGY','00017512AGY')

select * from Batch where BatNbr = '0000020001'


-- pjchargh - pj charge header
select * from PJCHARGH

-- pjchargd - pj charge detail
select * from PJCHARGD where project IN ('00017812AGY','00017912AGY','00017612AGY','00017712AGY','00018012AGY','00017512AGY')

-- Original Wrong amounts
/*
Original befor change	
project	amount
00017512AGY     	90497
00017612AGY     	22544.83
00017712AGY     	45645.42
00017812AGY     	52789.92
00017912AGY     	95083.33
00018012AGY     	19624.66
*/

-- correct the prebill records
update pjtran set amount = '45645.42', curytranamt = '45645.42' where project = '00017812AGY'
update pjtran set amount = '52789.92', curytranamt = '52789.92' where project = '00017912AGY'
update pjtran set amount = '90497', curytranamt = '90497' where project = '00017612AGY'
update pjtran set amount = '22544.83', curytranamt = '22544.83' where project = '00017712AGY'
update pjtran set amount = '95083.33', curytranamt = '95083.33' where project = '00018012AGY'
update pjtran set amount = '19624.66', curytranamt = '19624.66' where project = '00017512AGY'
update pjchargd set amount = '45645.42' where project = '00017812AGY'
update pjchargd set amount = '52789.92' where project = '00017912AGY'
update pjchargd set amount = '90497' where project = '00017612AGY'
update pjchargd set amount = '22544.83' where project = '00017712AGY'
update pjchargd set amount = '95083.33' where project = '00018012AGY'
update pjchargd set amount = '19624.66' where project = '00017512AGY'
