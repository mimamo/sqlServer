USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRTableDetail_PayTblId_MinAmt_]    Script Date: 12/21/2015 16:01:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTableDetail_PayTblId_MinAmt_] @parm1 varchar ( 4), @parm2 varchar ( 4) as
       Select * from PRTableDetail
           where PayTblId  LIKE  @parm1
             and CalYr = @parm2
           order by  PayTblId     ,
                     MinAmt   DESC
GO
