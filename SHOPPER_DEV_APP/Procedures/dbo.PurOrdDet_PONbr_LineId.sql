USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_PONbr_LineId]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PurOrdDet_PONbr_LineId] @parm1 varchar ( 10), @parm2 smallint as
    Select * from PurOrdDet where PONbr = @parm1
         and LineId = @parm2
         order by PONbr, LineId
GO
