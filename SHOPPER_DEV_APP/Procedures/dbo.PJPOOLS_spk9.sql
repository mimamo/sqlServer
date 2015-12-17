USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPOOLS_spk9]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PJPOOLS_spk9] @parm1 varchar (6), @parm2 varchar (10), @parm3 varchar (24), @parm4 varchar (10), @parm5 varchar(6) as
select *  from  PJPOOLS
where
 period = @parm1 and
 gl_acct = @parm2 and
 gl_subacct = @parm3 and
 cpnyid = @parm4 and
 grpid = @parm5
GO
