USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_spartprj]    Script Date: 12/21/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_spartprj] @parm1 varchar (16)   as
select  sum(eac_amount), sum(eac_units),
sum (total_budget_amount), sum(total_budget_units),
pjacct.acct, pjacct.acct_type, pjacct.sort_num
from  PJPTDROL, PJACCT
where PJPTDROL.project like  @parm1 and
PJPTDROL.acct = PJACCT.acct and
(PJACCT.acct_type = 'RV' or PJACCT.acct_type = 'EX')
group by pjacct.sort_num,
pjacct.acct,
pjacct.acct_type
order by PJACCT.sort_num, PJACCT.acct
GO
