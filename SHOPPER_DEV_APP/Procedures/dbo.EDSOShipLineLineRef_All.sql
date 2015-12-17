USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLineLineRef_All]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[EDSOShipLineLineRef_All] @parm1 varchar(10),@parm2 varchar(15),@parm3 varchar(30) , @parm4 varchar (5) as SELECT * FROM SOShipLine WHERE CpnyID = @parm1 AND ShipperID = @parm2 AND invtid = @parm3 and LineRef LIKE @parm4 oRDER BY CpnyID, ShipperID,invtid,LineRef
GO
