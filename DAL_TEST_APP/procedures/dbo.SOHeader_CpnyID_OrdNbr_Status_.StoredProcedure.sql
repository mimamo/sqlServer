USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOHeader_CpnyID_OrdNbr_Status_]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOHeader_CpnyID_OrdNbr_Status_]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 1 ),
	@parm4min smallint, @parm4max smallint
AS
	SELECT *
	FROM SOHeader
	WHERE CpnyID LIKE @parm1
	   AND OrdNbr LIKE @parm2
	   AND Status LIKE @parm3
	   AND CreditChk BETWEEN @parm4min AND @parm4max
	ORDER BY CpnyID,
	   OrdNbr,
	   Status,
	   CreditChk

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
