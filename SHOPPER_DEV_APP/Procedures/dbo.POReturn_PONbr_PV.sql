USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReturn_PONbr_PV]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReturn_PONbr_PV    Script Date: 11/24/99 7:50:26 PM ******/
Create Procedure [dbo].[POReturn_PONbr_PV] @parm1 varchar ( 10), @parm2 varchar ( 10) As
        Select distinct r.* From POReceipt r
	inner join potran t on t.rcptnbr = r.rcptnbr
        Where
		t.PONbr = @parm1
                And r.Rlsed = 1
                And r.VouchStage <> 'F'
		And r.RcptType = 'X'
                And r.RcptNbr LIKE @parm2
        Order By r.PONbr, r.RcptNbr
GO
