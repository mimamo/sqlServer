USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SlsperPlan_all]    Script Date: 12/21/2015 16:13:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SlsperPlan_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM SlsperPlan
	WHERE CpnyId LIKE @parm1
	   AND SlsperID LIKE @parm2
	   AND PlanID LIKE @parm3
	ORDER BY CpnyId,
	   SlsperID,
	   PlanID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
