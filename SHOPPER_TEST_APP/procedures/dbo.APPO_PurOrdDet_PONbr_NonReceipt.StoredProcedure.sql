USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APPO_PurOrdDet_PONbr_NonReceipt]    Script Date: 12/21/2015 16:06:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[APPO_PurOrdDet_PONbr_NonReceipt] @parm1 varchar ( 10) as
    Select * from PurOrdDet where PONbr = @parm1
         and RcptStage <> 'X'
GO
