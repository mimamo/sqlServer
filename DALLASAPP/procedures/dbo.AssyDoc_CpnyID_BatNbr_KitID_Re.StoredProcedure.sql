USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[AssyDoc_CpnyID_BatNbr_KitID_Re]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AssyDoc_CpnyID_BatNbr_KitID_Re]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 30 ),
	@parm4 varchar( 15 )
AS
	SELECT *
	FROM AssyDoc
	WHERE CpnyID LIKE @parm1
	   AND BatNbr LIKE @parm2
	   AND KitID LIKE @parm3
	   AND RefNbr LIKE @parm4
	ORDER BY CpnyID,
	   BatNbr,
	   KitID,
	   RefNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
