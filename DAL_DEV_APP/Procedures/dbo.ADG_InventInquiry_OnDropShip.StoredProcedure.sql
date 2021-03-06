USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_InventInquiry_OnDropShip]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_InventInquiry_OnDropShip]
	@CpnyID 	VARCHAR(10),
	@InvtID		VARCHAR(30)
as
    SELECT Purorddet.*
             FROM PurchOrd P, PurOrdDet
             WHERE InvtId = @InvtId AND
                   OpenLine = 1 AND
                   PurOrdDet.QtyOrd <> 0 AND
                   PurOrdDet.PONbr = P.PONbr AND
		   	 P.POType = 'DP' AND
                   P.CpnyID LIKE @CpnyID
            ORDER BY PurOrdDet.InvtId, PurOrdDet.PONbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
