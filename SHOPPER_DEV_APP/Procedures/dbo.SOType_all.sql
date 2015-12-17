USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOType_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOType_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 4 )
AS
	SELECT *
	FROM SOType
	WHERE CpnyID LIKE @parm1
	   AND SOTypeID LIKE @parm2
	ORDER BY CpnyID,
	   SOTypeID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
