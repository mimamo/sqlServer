USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[AP_POReceipt_RcptNbr_Vouch]    Script Date: 12/21/2015 16:13:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AP_POReceipt_RcptNbr_Vouch    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[AP_POReceipt_RcptNbr_Vouch] @parm1 varchar ( 10) As
        Select * From POReceipt Where
                POReceipt.RcptNbr = @parm1
                And POReceipt.Rlsed = 1
                And VouchStage <> 'F'
GO
