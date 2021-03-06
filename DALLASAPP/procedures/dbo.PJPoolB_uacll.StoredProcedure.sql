USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPoolB_uacll]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- this proc uses a 'like' for ledger ID not an =
Create Proc [dbo].[PJPoolB_uacll] @parm1 varchar (10),
	@parm2 varchar ( 10), @parm3 varchar (24), @Parm4  Varchar(10), @Parm5 Varchar(4), @parm6 varchar(6) As
    Select Acct, Sub from AcctHist
     where CpnyId = @parm1
        and Acct like @parm2
        and Sub like @parm3
        and LedgerID like @parm4	-- by removing may cause curn
        and Fiscyr = @parm5    -- by removing may cause curn
    union
    select alloc_gl_acct 'Acct', alloc_gl_subacct 'Sub'
     from PJPoolB
      where alloc_cpnyid = @parm1
        and alloc_gl_acct like @parm2
        and alloc_gl_subacct like @parm3
        and period = @parm6    -- by removing may cause curn
GO
