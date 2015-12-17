USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPackIndicator_all]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDPackIndicator_all]
	@parm1min smallint, @parm1max smallint,
	@parm2 varchar( 30 ),
	@parm3 varchar( 1 )
AS
	SELECT *
	FROM EDPackIndicator
	WHERE IndicatorType BETWEEN @parm1min AND @parm1max
	   AND InvtID LIKE @parm2
	   AND PackIndicator LIKE @parm3
	ORDER BY IndicatorType,
	   InvtID,
	   PackIndicator

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
