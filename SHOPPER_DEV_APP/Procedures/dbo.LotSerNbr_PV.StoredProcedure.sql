USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerNbr_PV]    Script Date: 12/21/2015 14:34:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerNbr_PV    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo. LotSerNbr_PV Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerNbr_PV] @parm1 varchar ( 30), @parm2 varchar (10), @parm3 varchar (10), @parm4 varchar (25) as
    Select * from LotSerMst where InvtId = @parm1
                  and SiteId = @parm2
                  and WhseLoc = @parm3
                  and lotsernbr like @Parm4
                  and Status = 'A'
                  and QtyOnHand > 0
                  order by InvtId, SiteID, WhseLoc, LotSerNbr
GO
