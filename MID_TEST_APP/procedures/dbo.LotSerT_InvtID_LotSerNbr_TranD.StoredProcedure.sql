USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_InvtID_LotSerNbr_TranD]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerT_InvtID_LotSerNbr_TranD]
	@parm1 varchar( 30 ),
	@parm2 varchar( 25 ),
	@parm3min smalldatetime, @parm3max smalldatetime,
	@parm4min smalldatetime, @parm4max smalldatetime
AS
	SELECT *
	FROM LotSerT
	WHERE InvtID LIKE @parm1
	   AND LotSerNbr LIKE @parm2
	   AND TranDate BETWEEN @parm3min AND @parm3max
	   AND TranTime BETWEEN @parm4min AND @parm4max
	ORDER BY InvtID,
	   LotSerNbr,
	   TranDate,
	   TranTime

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
