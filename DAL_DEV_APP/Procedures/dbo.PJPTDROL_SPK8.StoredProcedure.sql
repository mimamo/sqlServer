USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_SPK8]    Script Date: 12/21/2015 13:35:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_SPK8] @parm1 varchar (16)   as
SELECT
p.project,
p.acct,
p.act_amount,
p.total_budget_amount,
p.com_amount,
a.acct_type
FROM  pjptdrol p, pjacct a
WHERE
p.project = @parm1 and
p.acct    = a.acct    and
(a.acct_type = 'EX' or
a.acct_type = 'RV')
Order by
p.project,
p.acct
GO
