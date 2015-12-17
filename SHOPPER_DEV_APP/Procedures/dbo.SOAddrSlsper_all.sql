USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOAddrSlsper_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOAddrSlsper_all]
	@parm1 varchar( 15 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM SOAddrSlsper
	WHERE CustID LIKE @parm1
	   AND ShipToID LIKE @parm2
	   AND SlsPerID LIKE @parm3
	ORDER BY CustID,
	   ShipToID,
	   SlsPerID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
