USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ACCOUNT_sactive]    Script Date: 12/21/2015 14:34:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ACCOUNT_sactive] @parm1 varchar (10)  as
Select * from Account
where Acct like @parm1 and Active <> 0
Order by Acct
GO
