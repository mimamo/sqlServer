USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PmtType_all]    Script Date: 12/21/2015 14:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PmtType_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 4 )
AS
	SELECT *
	FROM PmtType
	WHERE CpnyID LIKE @parm1
	   AND PmtTypeID LIKE @parm2
	ORDER BY CpnyID,
	   PmtTypeID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
