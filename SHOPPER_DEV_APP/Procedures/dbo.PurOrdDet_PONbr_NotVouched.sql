USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_PONbr_NotVouched]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdDet_PONbr_NotVouched    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurOrdDet_PONbr_NotVouched] @parm1 varchar ( 10) as
    Select * from PurOrdDet where PONbr = @parm1
         and VouchStage <> 'F'
         order by PONbr, LineNbr
GO
