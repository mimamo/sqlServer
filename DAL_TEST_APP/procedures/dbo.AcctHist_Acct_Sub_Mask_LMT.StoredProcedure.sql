USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AcctHist_Acct_Sub_Mask_LMT]    Script Date: 12/21/2015 13:56:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[AcctHist_Acct_Sub_Mask_LMT] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 10), @parm5 varchar ( 4) As
Select Acct, Sub  from AcctHist
where CpnyId = @parm1
and Acct like @parm2
and Sub like @parm3
and ledgerid like @parm4
and FiscYr like @parm5
order by CpnyID, Acct, Sub
GO
