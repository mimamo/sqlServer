USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TrnsfrDoc_CpnyID_BatNbr_Trnsfr]    Script Date: 12/21/2015 14:18:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[TrnsfrDoc_CpnyID_BatNbr_Trnsfr]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM TrnsfrDoc
	WHERE CpnyID LIKE @parm1
	   AND BatNbr LIKE @parm2
	   AND TrnsfrDocNbr LIKE @parm3
	ORDER BY CpnyID,
	   BatNbr,
	   TrnsfrDocNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
