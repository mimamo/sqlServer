USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_Account_sPK3]    Script Date: 12/21/2015 15:37:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJ_Account_sPK3] @parm1 varchar (10)   as
Select * From PJ_Account, Account, PJACCT
Where
Pj_Account.gl_Acct =    Account.Acct and
Pj_Account.Acct    =    PJACCT.acct  and
Pj_Account.gl_Acct =    @parm1       and
Account.Active     =    1
Order by
Pj_Account.gl_Acct
GO
