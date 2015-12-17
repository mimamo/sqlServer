USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_CpnyID_ShipperI]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainerDet_CpnyID_ShipperI]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 )
AS
	SELECT *
	FROM EDContainerDet
	WHERE CpnyID LIKE @parm1
	   AND ShipperID LIKE @parm2
	ORDER BY CpnyID,
	   ShipperID
GO
