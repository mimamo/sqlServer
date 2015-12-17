USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POAlloc_PONbr_POLineRef]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POAlloc_PONbr_POLineRef]
	@parm1 varchar ( 10),
	@parm2 varchar ( 10),
	@parm3 varchar ( 05)

AS
	SELECT *
	FROM POAlloc
	WHERE	CpnyID = @Parm1
	        AND PONbr = @parm2
        	AND POLineRef = @parm3
        	ORDER BY PONbr, POLineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
