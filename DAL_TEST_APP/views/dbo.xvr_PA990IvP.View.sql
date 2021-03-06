USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA990IvP]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA990IvP]

as
select 
'PJTRAN' as 'Source',
t.acct as 'Acct',
t.amount as 'Amount',
t.amount as 'CostAmt',
t.amount as 'OrigAmt',
t.batch_id as 'BatchID',
t.batch_type as 'BatchType',
t.fiscalno as 'TranFiscalNo',
t.fiscalno as 'InvDetFiscalNo',
t.fiscalno as 'InvHdrFiscalNo',
t.project as 'Project',
t.system_cd as 'SystemCd',
t.trans_date as 'TransDate',
t.tr_comment as 'TransComment',
t.user1 as 'TranMigrationID',
t.tr_id04 as 'OrigBatNbr',
' ' as 'BillStatus'
from pjtran t
where 
(t.acct like 'WIP%' or t.acct='TRANSFER')

union all

select 
'PJINVDET' as 'Source',
d.acct as 'Acct',
d.amount as 'Amount',
d.cost_amt as 'CostAmt',
d.orig_amount as' OrigAmt',
'',
'',
left(d.in_id12,6) as 'FiscalNo',
left(d.in_id12,6) as 'InvDetFiscalNo',
isnull(h.fiscalno,'190001') as 'InvHdrFiscalNo',
d.project as 'Project',
'',
d.source_trx_date as 'SrcTrxDate', 
d.comment as 'TranComment',
d.user1 as 'TranMigrationID',
'',
d.bill_status as 'BillStatus'
from pjinvdet d
left outer join pjinvhdr h on d.draft_num=h.draft_num
left outer join xwrk_TransactionDetails td on d.user1=convert(varchar,td.TranMigrationID)
where
(d.acct like 'WIP%' or d.acct='TRANSFER')
and (isnull(td.Client_Invoice,'')='' or rtrim(td.Client_Invoice)='')
GO
