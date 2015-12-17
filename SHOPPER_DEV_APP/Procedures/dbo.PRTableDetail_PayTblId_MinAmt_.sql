USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTableDetail_PayTblId_MinAmt_]    Script Date: 12/16/2015 15:55:30 ******/
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
