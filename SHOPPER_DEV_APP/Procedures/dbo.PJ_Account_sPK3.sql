USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_Account_sPK3]    Script Date: 12/16/2015 15:55:25 ******/
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
