USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_Account_SLABACCT]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJ_Account_SLABACCT] @parm1 varchar (10)   as
Select * From Account, PJ_Account, PJAcct
Where
Account.Acct = Pj_Account.gl_Acct and
Pj_Account.Acct = PJAcct.acct and
Account.Acct like @parm1 and
Account.Active = 1 and
PJAcct.id5_sw = 'L'
Order by account.Acct
GO
