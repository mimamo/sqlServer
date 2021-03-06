USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOLine_OrdNbr_LineRef_CpnyID]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOLine_OrdNbr_LineRef_CpnyID]
	@parm1 varchar( 15 ),
	@parm2 varchar( 5 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM SOLine
	WHERE OrdNbr LIKE @parm1
	   AND LineRef LIKE @parm2
	   AND CpnyID LIKE @parm3
	ORDER BY OrdNbr,
	   LineRef,
	   CpnyID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
