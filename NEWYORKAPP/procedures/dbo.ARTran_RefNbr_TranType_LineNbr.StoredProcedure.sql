USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_RefNbr_TranType_LineNbr]    Script Date: 12/21/2015 16:00:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARTran_RefNbr_TranType_LineNbr    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARTran_RefNbr_TranType_LineNbr] @parm1 varchar ( 10), @parm2 varchar ( 2), @parm3beg smallint, @parm3end smallint as
    Select * from ARTran where RefNbr = @parm1
                           and TranType = @parm2
                           and LineNbr between @parm3beg and @parm3end
                         order by RefNbr, TranType, LineNbr
GO
