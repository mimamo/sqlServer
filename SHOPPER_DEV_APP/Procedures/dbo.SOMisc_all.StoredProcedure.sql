USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOMisc_all]    Script Date: 12/21/2015 14:34:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOMisc_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 5 )
AS
	SELECT *
	FROM SOMisc
	WHERE CpnyID = @parm1
	   AND OrdNbr LIKE @parm2
	   AND MiscChrgRef LIKE @parm3
	ORDER BY CpnyID,
	   OrdNbr,
	   MiscChrgRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
