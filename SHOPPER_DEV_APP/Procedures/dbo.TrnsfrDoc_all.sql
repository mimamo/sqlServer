USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TrnsfrDoc_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[TrnsfrDoc_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM TrnsfrDoc
	WHERE TrnsfrDocNbr LIKE @parm1
	   AND CpnyID LIKE @parm2
	ORDER BY TrnsfrDocNbr,
	   CpnyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
