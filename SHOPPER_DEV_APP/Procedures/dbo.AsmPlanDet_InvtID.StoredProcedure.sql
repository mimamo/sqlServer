USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AsmPlanDet_InvtID]    Script Date: 12/21/2015 14:34:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AsmPlanDet_InvtID]
	@parm1 varchar( 30 )
AS
	SELECT *
	FROM AsmPlanDet
	WHERE InvtID LIKE @parm1
	ORDER BY InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
