USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_Account_sPK1]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJ_Account_sPK1] @parm1 varchar (10)   as
Select * From Account, PJ_Account
Where
Account.Acct = Pj_Account.gl_Acct and
Account.Acct like @parm1 and
Account.Active = 1 Order by account.Acct
GO
