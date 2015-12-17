USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RcptACst_RcptNbr_InvcType]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RcptACst_RcptNbr_InvcType    Script Date: 4/16/98 7:50:27 PM ******/
Create Proc [dbo].[RcptACst_RcptNbr_InvcType] @parm1 varchar ( 10), @parm2 varchar ( 10) as
    Select * from RcptACst where
        RcptNbr = @parm1 and
                InvcTypeID = @parm2
        Order by RcptNbr, InvcTypeID
GO
