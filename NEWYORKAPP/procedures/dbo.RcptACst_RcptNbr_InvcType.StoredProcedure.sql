USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[RcptACst_RcptNbr_InvcType]    Script Date: 12/21/2015 16:01:14 ******/
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
