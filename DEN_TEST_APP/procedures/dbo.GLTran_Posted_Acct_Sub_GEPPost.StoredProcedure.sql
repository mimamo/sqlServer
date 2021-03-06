USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLTran_Posted_Acct_Sub_GEPPost]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GLTran_Posted_Acct_Sub_GEPPost    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[GLTran_Posted_Acct_Sub_GEPPost] @parm1 varchar ( 1), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 6) as
       Select * from GLTran
           where Posted  =    @parm1
             and Acct    LIKE @parm2
             and Sub     LIKE @parm3
             and PerPost >=   @parm4
           order by Posted, Acct, Sub, PerPost
GO
