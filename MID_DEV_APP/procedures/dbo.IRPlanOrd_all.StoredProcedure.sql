USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRPlanOrd_all]    Script Date: 12/21/2015 14:17:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRPlanOrd_all]
	@parm1 varchar( 15 )
AS
	SELECT *
	FROM IRPlanOrd
	WHERE PlanOrdNbr LIKE @parm1
	ORDER BY PlanOrdNbr
GO
