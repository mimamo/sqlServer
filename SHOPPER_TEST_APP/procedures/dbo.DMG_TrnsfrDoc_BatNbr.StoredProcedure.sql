USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_TrnsfrDoc_BatNbr]    Script Date: 12/21/2015 16:07:02 ******/
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
