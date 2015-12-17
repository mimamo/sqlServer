USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOHeader_CpnyID_SOTypeID_Statu]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOHeader_CpnyID_SOTypeID_Statu]
	@parm1 varchar( 10 ),
	@parm2 varchar( 4 ),
	@parm3 varchar( 1 )
AS
	SELECT *
	FROM SOHeader
	WHERE CpnyID LIKE @parm1
	   AND SOTypeID LIKE @parm2
	   AND Status LIKE @parm3
	ORDER BY CpnyID,
	   SOTypeID,
	   Status

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
