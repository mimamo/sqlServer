USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTick_ShipNbr]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTick_ShipNbr] @parm1 varchar(10) , @parm2 varchar(15)  AS
Select * from EDShipTicket where CpnyID = @parm1 and ShipperID like @parm2 order by CpnyID, ShipperID
GO
