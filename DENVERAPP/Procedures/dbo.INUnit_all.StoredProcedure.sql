USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[INUnit_all]    Script Date: 12/21/2015 15:42:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INUnit_all]
	@parm1 varchar( 1 ),
	@parm2 varchar( 6 ),
	@parm3 varchar( 30 ),
	@parm4 varchar( 6 ),
	@parm5 varchar( 6 )
AS
	SELECT *
	FROM INUnit
	WHERE UnitType LIKE @parm1
	   AND ClassID LIKE @parm2
	   AND InvtId LIKE @parm3
	   AND FromUnit LIKE @parm4
	   AND ToUnit LIKE @parm5
	ORDER BY UnitType,
	   ClassID,
	   InvtId,
	   FromUnit,
	   ToUnit

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
