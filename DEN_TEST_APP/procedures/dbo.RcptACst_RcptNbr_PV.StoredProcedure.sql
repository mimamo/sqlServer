USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[RcptACst_RcptNbr_PV]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReceipt_PONbr_PV    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[RcptACst_RcptNbr_PV] @parm1 varchar ( 15), @parm2 varchar ( 10) As
        Select * From RcptACst
                Where Vendid = @parm1
                And VouchStage <> 'F'
                And RcptNbr LIKE @parm2
        Order By RcptNbr
GO
