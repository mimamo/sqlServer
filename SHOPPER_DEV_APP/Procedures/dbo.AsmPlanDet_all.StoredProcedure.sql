USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AsmPlanDet_all]    Script Date: 12/21/2015 14:34:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AsmPlanDet_all]
	@parm1 varchar( 6 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM AsmPlanDet
	WHERE PlanID LIKE @parm1
	   AND InvtID LIKE @parm2
	ORDER BY PlanID,
	   InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
