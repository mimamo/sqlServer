USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AllocSrc_Acct_Sub]    Script Date: 12/21/2015 15:36:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AllocSrc_Acct_Sub    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AllocSrc_Acct_Sub] @parm1 varchar ( 10), @parm2 varchar ( 24) as
       Select * from AllocSrc
           where Acct LIKE @parm1
             and Sub  LIKE @parm2
           order by Acct, Sub
GO
