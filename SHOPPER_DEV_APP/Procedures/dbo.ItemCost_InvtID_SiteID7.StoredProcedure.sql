USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemCost_InvtID_SiteID7]    Script Date: 12/21/2015 14:34:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ItemCost_InvtID_SiteID7]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 2 )

AS
	SELECT *
	FROM ItemCost
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND LayerType LIKE @parm3
	ORDER BY InvtID,
	   SiteID,
	   LayerType,
	   SpecificCostID,
	   RcptDate,
	   RcptNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
