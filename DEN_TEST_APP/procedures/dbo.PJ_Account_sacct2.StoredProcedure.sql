USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_Account_sacct2]    Script Date: 12/21/2015 15:37:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJ_Account_sacct2] @parm1 varchar (16), @parm2 varchar (10)   as
select * from  PJ_Account, Account, PJAcct
where
Pj_Account.Acct       = @parm1 and
Pj_Account.GL_Acct Like @parm2 and
Pj_Account.Acct       = PJACCT.acct  and
Pj_account.Gl_Acct    = Account.acct and
Account.Active        = 1 and
PJACCT.Acct_Status    = 'A'
order by
Pj_Account.Gl_Acct
GO
