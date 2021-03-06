USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_Account_sPK4]    Script Date: 12/21/2015 13:57:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJ_Account_sPK4] @parm1 varchar (10)   as
Select * From PJ_Account, Account, PJACCT
Where
Pj_Account.gl_Acct =    Account.Acct and
Pj_Account.Acct    =    PJACCT.acct  and
Pj_Account.gl_Acct =    @parm1       and
Account.Active     =    1
Order by
Pj_Account.gl_Acct
GO
