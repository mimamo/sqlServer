USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_InvtId_PO]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdDet_InvtId_PO    Script Date: 4/16/98 7:50:26 PM ******/
create proc [dbo].[PurOrdDet_InvtId_PO] @parm1 varchar(30), @parm2 varchar (10) as
    Select purorddet.*
             from PurchOrd P, PurOrdDet
             where InvtId = @parm1 and
                   OpenLine = 1 and
                   PurOrdDet.QtyOrd <> 0 and
                   PurOrdDet.PONbr = P.PONbr and
			 P.POType = 'OR' and
			p.Status IN ('O','P') and
                   P.CpnyID LIKE @parm2
            order by PurOrdDet.InvtId, PurOrdDet.PONbr
GO
