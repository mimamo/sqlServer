USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_RcptNbr_Rlsd]    Script Date: 12/21/2015 14:17:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReceipt_RcptNbr_Rlsd    Script Date: 2/28/02 6:30:41 PM ******/
Create Procedure [dbo].[POReceipt_RcptNbr_Rlsd] @parm1 varchar ( 10) As
        Select * From POReceipt Where
                POReceipt.RcptNbr = @parm1
                And POReceipt.Rlsed = 1
                And POReceipt.CreateAD = 0
                And Poreceipt.VouchStage <> 'F'
GO
