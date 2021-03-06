USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipLine_ShipperID_ReNbr]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipLine_ShipperID_ReNbr] @parm1 varchar(10), @parm2 varchar(10) as

update shl
set shl.LineNbr = -32768 + (convert(int, shl.LineRef) - 1) * power(2, case when 16 - ceiling(log(sh.LineCntr)/log(2)) < 8 then 16 - ceiling(log(sh.LineCntr)/log(2)) else 8 end)
from SOShipLine shl
inner join SOShipHeader sh on sh.CpnyID = shl.CpnyID and sh.ShipperID = shl.ShipperID
where sh.CpnyID = @parm1 and sh.ShipperID = @parm2
GO
