USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_TrnsfrDoc_BatNbr]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_TrnsfrDoc_BatNbr]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM TrnsfrDoc
	WHERE BatNbr = @parm1
	   OR S4Future11 = @parm1
	ORDER BY BatNbr, S4Future11

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
