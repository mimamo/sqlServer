USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INArchTran_all]    Script Date: 12/21/2015 14:06:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INArchTran_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 10 ),
	@parm4min int, @parm4max int
AS
	SELECT *
	FROM INArchTran
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND CpnyID LIKE @parm3
	   AND RecordID BETWEEN @parm4min AND @parm4max
	ORDER BY InvtID,
	   SiteID,
	   CpnyID,
	   RecordID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
