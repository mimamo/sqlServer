USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RcptACst_RcptNbr_LineNbr]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RcptACst_RcptNbr_LineNbr    Script Date: 4/16/98 7:50:27 PM ******/
Create Proc [dbo].[RcptACst_RcptNbr_LineNbr] @parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint as
    Select * from RcptACst where
        RcptNbr = @parm1 and
                LineNbr between @parm2beg and @parm2end
        Order by RcptNbr, LineNbr
GO
