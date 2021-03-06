USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POItemReqHist_all]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POItemReqHist_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 5 ),
	@parm3min smalldatetime, @parm3max smalldatetime,
	@parm4 varchar( 10 ),
	@parm5 varchar( 47 )
AS
	SELECT *
	FROM POItemReqHist
	WHERE ItemReqNbr LIKE @parm1
	   AND LineRef LIKE @parm2
	   AND TranDate BETWEEN @parm3min AND @parm3max
	   AND TranTime LIKE @parm4
	   AND UserID LIKE @parm5
	ORDER BY ItemReqNbr,
	   LineRef,
	   TranDate,
	   TranTime,
	   UserID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
