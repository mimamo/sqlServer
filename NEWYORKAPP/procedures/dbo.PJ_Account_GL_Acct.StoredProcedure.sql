USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_Account_GL_Acct]    Script Date: 12/21/2015 16:01:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJ_Account_GL_Acct] @parm1 varchar (16)  as
select count(*) from PJ_Account
where gl_acct = @parm1
GO
