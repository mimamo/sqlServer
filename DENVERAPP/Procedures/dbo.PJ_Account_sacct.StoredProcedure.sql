USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_Account_sacct]    Script Date: 12/21/2015 15:43:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJ_Account_sacct] @parm1 varchar (16)   as
select account.acct, account.descr, substring(account.accttype, 2,1) from  PJ_Account, Account
where pj_account.acct  =  @parm1
          and account.acct = pj_account.gl_acct
          and pj_account.acct <> ' '
order by pj_account.gl_acct
GO
