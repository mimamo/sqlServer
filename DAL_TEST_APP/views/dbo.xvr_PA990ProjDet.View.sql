USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA990ProjDet]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA990ProjDet]

as


select 
'PJINVDET' as 'Source', 
d.project as 'Project',
d.acct as 'AcctCat',
d.amount as 'Amount',
d.cost_amt as 'CostAmt',
d.orig_amount as 'OrigAmt',
d.units as 'Units',
d.bill_status as 'BillStatus',
case when left(d.in_id12,6)='' then d.fiscalno else left(d.in_id12,6) end as 'CreatedFiscalNo',
h.fiscalno as 'BilledFiscalNo',
d.in_id12 as 'RecordKey',
d.user1 as 'TranMigID',
d.crtd_prog as 'CrtdProg'
from pjinvdet d
left outer join pjinvhdr h on d.draft_num=h.draft_num
where 
(d.acct like 'WIP%' or d.acct='TRANSFER')

union all

select 
'PJTRAN', 
t.project,
t.acct,
t.amount,
t.amount,
t.amount,
t.units,
'',
t.fiscalno,
'',
t.tr_id23,
t.user1,
t.crtd_prog
from pjtran t
where
(t.acct like 'WIP%' or t.acct='TRANSFER')
GO
