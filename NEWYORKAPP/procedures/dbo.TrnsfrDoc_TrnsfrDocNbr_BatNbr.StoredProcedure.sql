USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[TrnsfrDoc_TrnsfrDocNbr_BatNbr]    Script Date: 12/21/2015 16:01:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[TrnsfrDoc_TrnsfrDocNbr_BatNbr]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM TrnsfrDoc
	WHERE TrnsfrDocNbr LIKE @parm1
	   AND BatNbr LIKE @parm2
	ORDER BY TrnsfrDocNbr,
	   BatNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
