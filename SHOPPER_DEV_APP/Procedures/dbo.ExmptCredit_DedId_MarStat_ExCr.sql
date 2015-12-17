USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ExmptCredit_DedId_MarStat_ExCr]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[ExmptCredit_DedId_MarStat_ExCr] @parm1 varchar ( 10), @parm2 varchar ( 1), @parm3 varchar ( 1) as
       Select * from ExmptCredit
           where ExmptCredit.DedId      LIKE  @parm1
             and ExmptCredit.MarStat    LIKE  @parm2
             and ExmptCredit.ExmptCr    LIKE  @parm3
           order by ExmptCredit.DedId,
                    ExmptCredit.MarStat,
                    ExmptCredit.ExmptCr,
                    ExmptCredit.ExmptCrId
GO
