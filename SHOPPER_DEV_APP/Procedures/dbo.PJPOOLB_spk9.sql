USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPOOLB_spk9]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PJPOOLB_spk9] @parm1 varchar (6),
	@parm2 varchar (10),
	@parm3 varchar (24),
	@parm4 varchar (10),
	@parm5 varchar (6),
	@parm6 varchar (10),
	@parm7 varchar (24) as

select *  from  PJPOOLB
where
 period = @parm1 and
 alloc_gl_acct = @parm2 and
 alloc_gl_subacct = @parm3 and
 alloc_cpnyid = @parm4 and
 grpid = @parm5 and
 basis_gl_acct = @parm6 and
 basis_gl_subacct = @parm7
GO
