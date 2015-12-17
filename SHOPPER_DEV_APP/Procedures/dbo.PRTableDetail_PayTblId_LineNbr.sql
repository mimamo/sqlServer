USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTableDetail_PayTblId_LineNbr]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTableDetail_PayTblId_LineNbr] @parm1 varchar ( 4), @parm2 varchar( 4), @parm3beg smallint, @parm3end smallint as
       Select * from PRTableDetail
           where PayTblId       =  @parm1
             and CalYr = @parm2
             and LineNbr  BETWEEN  @parm3beg and @parm3end
           order by PayTblId, LineNbr
GO
