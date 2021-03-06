USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_BatNbr_Acct_Sub_ChkNbr]    Script Date: 12/21/2015 15:49:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRDoc_BatNbr_Acct_Sub_ChkNbr] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 10) as
       Select * from PRDoc
           where BatNbr  =     @parm1
             and Acct    LIKE  @parm2
             and Sub     LIKE  @parm3
             and ChkNbr  LIKE  @parm4
           order by BatNbr  ,
                    Acct    ,
                    Sub     ,
                    ChkNbr
GO
