USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_Account_sPK0]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJ_Account_sPK0] @parm1 varchar (10)   as
select * from PJ_Account
where gl_acct  like  @parm1
order by gl_acct
GO
