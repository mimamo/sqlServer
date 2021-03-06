USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipHeader_CustID_Status_Cpn]    Script Date: 12/21/2015 15:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipHeader_CustID_Status_Cpn]
	@parm1 varchar( 15 ),
	@parm2 varchar( 1 ),
	@parm3 varchar( 10 ),
	@parm4 varchar( 15 )
AS
	SELECT *
	FROM SOShipHeader
	WHERE CustID LIKE @parm1
	   AND Status LIKE @parm2
	   AND CpnyID LIKE @parm3
	   AND ShipperID LIKE @parm4
	ORDER BY CustID,
	   Status,
	   CpnyID,
	   ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
