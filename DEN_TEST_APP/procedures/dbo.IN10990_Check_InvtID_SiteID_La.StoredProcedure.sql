USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[IN10990_Check_InvtID_SiteID_La]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IN10990_Check_InvtID_SiteID_La]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 1 ),
	@parm4 varchar( 25 ),
	@parm5 varchar( 15 ),
	@parm6min smalldatetime, @parm6max smalldatetime
AS
	SELECT *
	FROM IN10990_Check
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND LayerType LIKE @parm3
	   AND SpecificCostID LIKE @parm4
	   AND RcptNbr LIKE @parm5
	   AND RcptDate BETWEEN @parm6min AND @parm6max
	ORDER BY InvtID,
	   SiteID,
	   LayerType,
	   SpecificCostID,
	   RcptNbr,
	   RcptDate

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
