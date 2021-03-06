USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_PONbr_PV]    Script Date: 12/21/2015 15:37:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReceipt_PONbr_PV    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[POReceipt_PONbr_PV] @parm1 varchar ( 10), @parm2 varchar ( 10) As
        Select distinct POReceipt.* From POReceipt
        inner join potran on potran.rcptnbr = POReceipt.rcptnbr
                Where potran.PONbr = @parm1
                And POReceipt.Rlsed = 1
                And POReceipt.VouchStage <> 'F'
                And POReceipt.RcptNbr LIKE @parm2
        Order By POReceipt.PONbr, POReceipt.RcptNbr
GO
