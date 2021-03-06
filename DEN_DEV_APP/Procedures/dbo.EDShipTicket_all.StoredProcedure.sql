USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTicket_all]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTicket_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 20 )
AS
	SELECT *
	FROM EDShipTicket
	WHERE CpnyId LIKE @parm1
	   AND ShipperId LIKE @parm2
	   AND BOLNbr LIKE @parm3
	ORDER BY CpnyId,
	   ShipperId,
	   BOLNbr
GO
