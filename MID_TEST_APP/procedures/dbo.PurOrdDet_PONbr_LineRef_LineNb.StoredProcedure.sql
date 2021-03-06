USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_PONbr_LineRef_LineNb]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PurOrdDet_PONbr_LineRef_LineNb]
	@parm1 varchar( 10 ),
	@parm2 varchar( 5 ),
	@parm3min smallint, @parm3max smallint
AS
	SELECT *
	FROM PurOrdDet
	WHERE PONbr LIKE @parm1
	   AND LineRef LIKE @parm2
	   AND LineNbr BETWEEN @parm3min AND @parm3max
	ORDER BY PONbr,
	   LineRef,
	   LineNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
