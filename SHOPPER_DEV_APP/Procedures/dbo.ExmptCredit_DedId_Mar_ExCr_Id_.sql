USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ExmptCredit_DedId_Mar_ExCr_Id_]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[ExmptCredit_DedId_Mar_ExCr_Id_] @parm1 varchar ( 10), @parm2 varchar ( 4) ,@parm3 varchar ( 1), @parm4 varchar ( 1), @parm5 varchar ( 4) as
       Select * from ExmptCredit
           where ExmptCredit.DedId      =     @parm1
             and ExmptCredit.CalYr      =     @parm2
             and ExmptCredit.MarStat    LIKE  @parm3
             and ExmptCredit.ExmptCr    LIKE  @parm4
             and ExmptCredit.ExmptCrId  LIKE  @parm5
           order by ExmptCredit.DedId,
                    ExmptCredit.MarStat,
                    ExmptCredit.ExmptCr,
                    ExmptCredit.ExmptCrId
GO
