USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[AllocDest_Acct_Sub]    Script Date: 12/21/2015 16:13:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AllocDest_Acct_Sub    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AllocDest_Acct_Sub] @parm1 varchar ( 10), @parm2 varchar ( 24) as
       Select * from AllocDest
           where Acct LIKE @parm1
             and Sub  LIKE @parm2
           order by Acct, Sub
GO
