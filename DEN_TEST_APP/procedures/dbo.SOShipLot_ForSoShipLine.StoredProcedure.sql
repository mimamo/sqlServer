USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipLot_ForSoShipLine]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SOShipLot_ForSoShipLine]
	@CpnyID varchar( 10 ),
	@ShipperID varchar( 15 ),
	@LineRef varchar( 5 )
AS
	SELECT *
	FROM SOShipLot
	WHERE CpnyID = @CpnyID
	   AND ShipperID = @ShipperID
	   AND LineRef = @LineRef
	ORDER BY LotSerRef
GO
