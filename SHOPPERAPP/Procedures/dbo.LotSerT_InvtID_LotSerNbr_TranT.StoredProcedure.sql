USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_InvtID_LotSerNbr_TranT]    Script Date: 12/21/2015 16:13:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerT_InvtID_LotSerNbr_TranT]
	@parm1 varchar( 30 ),
	@parm2 varchar( 25 ),
	@parm3 varchar( 2 ),
	@parm4min smalldatetime, @parm4max smalldatetime,
	@parm5min smalldatetime, @parm5max smalldatetime
AS
	SELECT *
	FROM LotSerT
	WHERE InvtID LIKE @parm1
	   AND LotSerNbr LIKE @parm2
	   AND TranType LIKE @parm3
	   AND TranDate BETWEEN @parm4min AND @parm4max
	   AND TranTime BETWEEN @parm5min AND @parm5max
	ORDER BY InvtID,
	   LotSerNbr,
	   TranType,
	   TranDate,
	   TranTime

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
