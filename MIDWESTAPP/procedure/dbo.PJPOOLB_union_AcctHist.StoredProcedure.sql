USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPOOLB_union_AcctHist]    Script Date: 12/21/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PJPOOLB_union_AcctHist] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24) As
       Select Acct, Sub  from AcctHist
           where CpnyId = @parm1
             and Acct like @parm2
             and Sub like @parm3
	union
	select alloc_gl_acct 'Acct', alloc_gl_subacct 'Sub'
	from pjpoolb
           where alloc_cpnyid = @parm1
             and alloc_gl_acct like @parm2
             and alloc_gl_subacct like @parm3
GO
