USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BOMDoc_all]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[BOMDoc_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM BOMDoc
	WHERE CpnyID LIKE @parm1
	   AND RefNbr LIKE @parm2
	ORDER BY CpnyID,
	   RefNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
