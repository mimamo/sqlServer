USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_Account_sPK2]    Script Date: 12/21/2015 13:57:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJ_Account_sPK2] @parm1 varchar (10)   as
select * from PJ_Account
where gl_acct  =  @parm1
order by gl_acct
GO
