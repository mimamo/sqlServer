USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_Account_sPK5]    Script Date: 12/21/2015 16:01:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJ_Account_sPK5] @parm1 varchar (250) , @parm2 varchar (10)  as
Select * From Account, PJ_Account
Where
Account.Acct = Pj_Account.gl_Acct and
Account.Acct <> @parm1 and
Account.Acct like @parm2 and
Account.Active = 1 Order by account.Acct
GO
