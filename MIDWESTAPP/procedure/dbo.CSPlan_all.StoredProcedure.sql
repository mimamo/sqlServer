USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[CSPlan_all]    Script Date: 12/21/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CSPlan_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM CSPlan
	WHERE PlanID LIKE @parm1
	ORDER BY PlanID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
