USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AsmPlan_all]    Script Date: 12/21/2015 16:06:57 ******/
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
