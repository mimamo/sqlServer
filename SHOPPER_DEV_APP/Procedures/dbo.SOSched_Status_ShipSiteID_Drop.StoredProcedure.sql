USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOSched_Status_ShipSiteID_Drop]    Script Date: 12/21/2015 14:34:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOSched_Status_ShipSiteID_Drop]
	@parm1 varchar( 1 ),
	@parm2 varchar( 10 ),
	@parm3min smallint, @parm3max smallint,
	@parm4min smalldatetime, @parm4max smalldatetime
AS
	SELECT *
	FROM SOSched
	WHERE Status LIKE @parm1
	   AND ShipSiteID LIKE @parm2
	   AND DropShip BETWEEN @parm3min AND @parm3max
	   AND CancelDate BETWEEN @parm4min AND @parm4max
	ORDER BY Status,
	   ShipSiteID,
	   DropShip,
	   CancelDate

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
