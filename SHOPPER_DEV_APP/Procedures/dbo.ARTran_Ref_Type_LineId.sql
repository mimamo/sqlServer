USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_Ref_Type_LineId]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARTran_Ref_Type_LineId    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARTran_Ref_Type_LineId] @parm1 varchar ( 10), @parm2 varchar ( 2), @parm3beg int, @parm3end int as
    Select * from ARTran
      where RefNbr = @parm1
        and TranType = @parm2
        and LineId between @parm3beg and @parm3end
        order by RefNbr, TranType, LineNbr
GO
