USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AsmPlan_all]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AsmPlan_all]
	@parm1 varchar( 6 )
AS
	SELECT *
	FROM AsmPlan
	WHERE PlanID LIKE @parm1
	ORDER BY PlanID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
