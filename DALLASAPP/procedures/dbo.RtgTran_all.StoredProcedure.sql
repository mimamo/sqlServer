USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[RtgTran_all]    Script Date: 12/21/2015 13:45:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RtgTran_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3min smallint, @parm3max smallint
AS
	SELECT *
	FROM RtgTran
	WHERE CpnyID LIKE @parm1
	   AND RefNbr LIKE @parm2
	   AND LineNbr BETWEEN @parm3min AND @parm3max
	ORDER BY CpnyID,
	   RefNbr,
	   LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
