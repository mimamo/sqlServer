USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOLine_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOLine_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 5 )
AS
	SELECT *
	FROM SOLine
	WHERE CpnyID = @parm1
	   AND OrdNbr LIKE @parm2
	   AND LineRef LIKE @parm3
	ORDER BY CpnyID,
	   OrdNbr,
	   LineRef

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
