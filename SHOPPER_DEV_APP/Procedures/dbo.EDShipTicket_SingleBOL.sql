USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_SingleBOL]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTicket_SingleBOL] @parm1 varchar(20), @parm2 varchar(10), @parm3 varchar(15)  AS
Select * from EDShipTicket where BOLNbr = @parm1 and CpnyID like @parm2 and ShipperID like @parm3 order by BOLNbr, CpnyID, ShipperID
GO
