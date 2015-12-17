USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POTran_RcptNbr_NotVouched]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POTran_RcptNbr_NotVouched    Script Date: 4/16/98 7:50:26 PM ******/
Create proc [dbo].[POTran_RcptNbr_NotVouched] @parm1 varchar ( 10) as
        Select * from POTran where RcptNbr = @parm1
            and VouchStage <> 'F'
            Order by RcptNbr, LineNbr
GO
