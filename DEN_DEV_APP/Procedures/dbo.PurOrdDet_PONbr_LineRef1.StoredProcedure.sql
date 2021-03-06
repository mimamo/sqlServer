USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_PONbr_LineRef1]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdDet_PONbr_LineRef1    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurOrdDet_PONbr_LineRef1] @parm1 varchar ( 10), @parm2 varchar ( 05) As
        Select * from PurOrdDet where
                PONbr = @parm1 And
                VouchStage <> 'F'
                and PurchaseType in ('GD','SP','SE','SW')
                And LineRef Like @parm2
        Order By POnbr, LineRef
GO
