USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdSh_SOShipLine]    Script Date: 12/21/2015 14:05:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_UpdSh_SOShipLine]
	@CpnyID 	varchar(10),
	@ShipperID 	varchar(15),
	@LineRef 	varchar(5)
AS
	SELECT *
	FROM SOShipLine (UPDLOCK)
	WHERE CpnyID = @CpnyID
	   AND ShipperID LIKE @ShipperID
	   AND LineRef LIKE @LineRef
	ORDER BY CpnyID, ShipperID, LineRef
GO
