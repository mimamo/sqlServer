USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_Account_GL_Acct]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJ_Account_GL_Acct] @parm1 varchar (16)  as
select count(*) from PJ_Account
where gl_acct = @parm1
GO
