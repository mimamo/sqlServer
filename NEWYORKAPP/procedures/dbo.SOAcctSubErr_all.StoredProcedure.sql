USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOAcctSubErr_all]    Script Date: 12/21/2015 16:01:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOAcctSubErr_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 31 ),
	@parm4 varchar( 15 ),
	@parm5 varchar( 5 )
AS
	SELECT *
	FROM SOAcctSubErr
	WHERE CpnyID LIKE @parm1
	   AND Acct LIKE @parm2
	   AND Sub LIKE @parm3
	   AND ShipperID LIKE @parm4
	   AND ErrorRef LIKE @parm5
	ORDER BY CpnyID,
	   Acct,
	   Sub,
	   ShipperID,
	   ErrorRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
