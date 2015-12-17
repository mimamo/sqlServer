USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APPO_PurOrdDet_PONbr_NotVouched]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[APPO_PurOrdDet_PONbr_NotVouched] @parm1 varchar ( 10) as
    Select * from PurOrdDet where PONbr = @parm1
         and VouchStage <> 'F'
 	and not exists(select 'x' from aptran where
		ponbr = @parm1 and
		APTran.POLineRef = PurOrdDet.LineRef and
		aptran.rlsed = 0)
        order by PONbr, LineNbr
GO
