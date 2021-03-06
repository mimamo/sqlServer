USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerTArch_CpnyID_BatNbr_RefN]    Script Date: 12/21/2015 15:42:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerTArch_CpnyID_BatNbr_RefN]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 15 ),
	@parm4 varchar( 5 ),
	@parm5 varchar( 5 )
AS
	SELECT *
	FROM LotSerTArch
	WHERE CpnyID LIKE @parm1
	   AND BatNbr LIKE @parm2
	   AND RefNbr LIKE @parm3
	   AND INTranLineRef LIKE @parm4
	   AND LotSerRef LIKE @parm5
	ORDER BY CpnyID,
	   BatNbr,
	   RefNbr,
	   INTranLineRef,
	   LotSerRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
