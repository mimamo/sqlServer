USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ExmptCredit_PayTblId]    Script Date: 12/21/2015 15:42:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[ExmptCredit_PayTblId] @parm1 varchar ( 4), @parm2 varchar ( 4) as
       Select * from ExmptCredit
           where PayTblId  LIKE  @parm1
             and CalYr = @parm2
           order by DedId    ,
                    MarStat  ,
                    ExmptCr  ,
                    ExmptCrId
GO
