USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AssyDoc_all]    Script Date: 12/21/2015 14:34:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AssyDoc_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 10 ),
	@parm4 varchar( 10 )
AS
	SELECT *
	FROM AssyDoc
	WHERE KitID LIKE @parm1
	   AND RefNbr LIKE @parm2
	   AND BatNbr LIKE @parm3
	   AND CpnyID LIKE @parm4
	ORDER BY KitID,
	   RefNbr,
	   BatNbr,
	   CpnyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
