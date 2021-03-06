USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AcctHist_Acct_Sub_Count]    Script Date: 12/21/2015 13:35:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AcctHist_Acct_Sub_Count    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AcctHist_Acct_Sub_Count] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24) As
       Select count(Acct) from AcctHist
           where CpnyId = @parm1
             and Acct like @parm2
             and Sub like @parm3
GO
