USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_all]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INTran_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 10 ),
	@parm4min int, @parm4max int
AS
	SELECT *
	FROM INTran
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
