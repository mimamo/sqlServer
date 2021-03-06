USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_CpnyID_ShipperI]    Script Date: 12/21/2015 16:13:10 ******/
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
