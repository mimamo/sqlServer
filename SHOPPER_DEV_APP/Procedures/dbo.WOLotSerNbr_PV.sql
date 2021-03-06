USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOLotSerNbr_PV]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[WOLotSerNbr_PV] @parm1 varchar ( 30), @parm2 varchar (10), @parm3 varchar (10), @parm4 varchar (25) as
    Select * from LotSerMst where InvtId = @parm1
                  and SiteId = @parm2
                  and WhseLoc = @parm3
                  and lotsernbr like @Parm4
                  and Status = 'A'
                  and QtyOnHand > 0
                  and (expDate >= getdate() or expDate = '1900-01-01 00:00:00')
                  order by InvtId, SiteID, WhseLoc, LotSerNbr
GO
