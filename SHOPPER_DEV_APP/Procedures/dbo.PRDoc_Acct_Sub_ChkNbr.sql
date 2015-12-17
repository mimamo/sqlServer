USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_Acct_Sub_ChkNbr]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRDoc_Acct_Sub_ChkNbr] @parm1 varchar ( 10), @parm2 varchar ( 24), @parm3 varchar ( 10) as
       Select * from PRDoc
           where Acct    =  @parm1
             and Sub     =  @parm2
             and ChkNbr  =  @parm3
           order by Acct  ,
                    Sub   ,
                    ChkNbr
GO
