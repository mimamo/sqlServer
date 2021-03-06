USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA990GvP]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xvr_PA990GvP]

as
select 
'GLTRAN' as 'Source', 
t.acct as 'Acct', 
a.acct_cat as 'AcctCat', 
t.batnbr as 'BatNbr', 
sum(t.dramt-t.cramt) as 'WIPAmt', 
t.jrnltype as 'JrnlType', 
t.perpost as 'PerPost', 
t.projectid as 'ProjectID', 
t.refnbr as 'RefNbr', 
t.taskid as 'TaskID', 
t.trandate as 'TranDate', 
t.trandesc as 'TranDesc', 
t.trantype as 'TranType'
from gltran t
left outer join account a on t.acct=a.acct
where 
(a.acct_cat like 'WIP%' or a.acct_cat='TRANSFER')
and t.posted='P'
group by t.acct, a.acct_cat, t.batnbr, t.jrnltype, t.perpost, t.projectid, t.refnbr, t.taskid, t.trandate, t.trandesc, t.trantype

union all

select 
'PJTRAN', 
a.acct, 
t.acct, 
t.batch_id, 
sum(t.amount), 
t.system_cd, 
t.fiscalno, 
t.project, 
t.voucher_num, 
t.pjt_entity, 
t.trans_date, 
t.tr_comment, 
t.batch_type
from pjtran t
left outer join account a on t.acct=a.acct_cat
where
(t.acct like 'WIP%' or t.acct='TRANSFER')
group by a.acct, t.acct, t.batch_id, t.system_cd, t.fiscalno, t.project, t.voucher_num, t.pjt_entity, t.trans_date, t.tr_comment, t.batch_type


-- Commented out as per Ray and Evan 7/22/2008
--union all
--
--select
--'DENVER',
--'WIP',
--'WIP from Denver',
--'',
--d.WIPAmt,
--'',
--'200610',
--d.Project,
--'',
--'',
--'',
--'',
--''
--from xwrk_DenverWIP d
GO
