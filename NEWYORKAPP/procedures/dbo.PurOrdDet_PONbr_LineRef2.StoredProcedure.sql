USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_PONbr_LineRef2]    Script Date: 12/21/2015 16:01:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PurOrdDet_PONbr_LineRef2] @parm1 varchar ( 10), @parm2 varchar ( 05) As
        Select * from PurOrdDet where
                PONbr = @parm1 And
                LineRef = @parm2
GO
