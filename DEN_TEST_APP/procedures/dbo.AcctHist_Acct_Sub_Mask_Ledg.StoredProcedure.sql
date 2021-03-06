USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AcctHist_Acct_Sub_Mask_Ledg]    Script Date: 12/21/2015 15:36:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[AcctHist_Acct_Sub_Mask_Ledg] @parm1 varchar ( 10),
	@parm2 varchar ( 10), @parm3 varchar ( 24), @Parm4  Varchar(10), @Parm5 Varchar(4) As
       	Select Acct, Sub from AcctHist
           where CpnyId = @parm1
             and Acct like @parm2
             and Sub like @parm3
             and LedgerID = @parm4
             and Fiscyr = @parm5
        order by CpnyID, Acct, Sub
GO
