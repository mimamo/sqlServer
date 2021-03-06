USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_PONbr_LineRef]    Script Date: 12/21/2015 16:01:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdDet_PONbr_LineRef    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurOrdDet_PONbr_LineRef] @parm1 varchar ( 10), @parm2 varchar ( 05) As
        Select * from PurOrdDet
            where PONbr = @parm1
              And LineRef Like @parm2
              And PurchaseType IN ('DL','FR','GI','GP','GS','MI','GN')
        Order By POnbr, LineRef, InvtId, QtyOrd, QtyRcvd
GO
