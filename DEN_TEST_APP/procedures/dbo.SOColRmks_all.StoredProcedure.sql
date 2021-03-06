USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOColRmks_all]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOColRmks_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3min smalldatetime, @parm3max smalldatetime
AS
	SELECT *
	FROM SOColRmks
	WHERE CpnyID LIKE @parm1
	   AND CustID LIKE @parm2
	   AND EntryDate BETWEEN @parm3min AND @parm3max
	ORDER BY CpnyID,
	   CustID,
	   EntryDate

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
