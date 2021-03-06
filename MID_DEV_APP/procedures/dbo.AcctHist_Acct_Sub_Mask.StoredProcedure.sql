USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AcctHist_Acct_Sub_Mask]    Script Date: 12/21/2015 14:17:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AcctHist_Acct_Sub_Mask    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AcctHist_Acct_Sub_Mask] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24) As
       Select Acct, Sub  from AcctHist
           where CpnyId = @parm1
             and Acct like @parm2
             and Sub like @parm3
           order by CpnyID, Acct, Sub
GO
