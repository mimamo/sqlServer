USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CSPlanDetail_all]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CSPlanDetail_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 5 )
AS
	SELECT *
	FROM CSPlanDetail
	WHERE PlanID LIKE @parm1
	   AND LineRef LIKE @parm2
	ORDER BY PlanID,
	   LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
