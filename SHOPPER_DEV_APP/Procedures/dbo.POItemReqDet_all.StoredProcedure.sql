USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POItemReqDet_all]    Script Date: 12/21/2015 14:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POItemReqDet_all]
	@parm1 varchar( 10 ),
	@parm2min smallint, @parm2max smallint
AS
	SELECT *
	FROM POItemReqDet
	WHERE ItemReqNbr LIKE @parm1
	   AND LineNbr BETWEEN @parm2min AND @parm2max
	ORDER BY ItemReqNbr,
	   LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
