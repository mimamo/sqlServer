USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Wrk10400_GLTran_all]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Wrk10400_GLTran_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 2 ),
	@parm3min int, @parm3max int
AS
	SELECT *
	FROM Wrk10400_GLTran
	WHERE BatNbr LIKE @parm1
	   AND Module LIKE @parm2
	   AND RecordID BETWEEN @parm3min AND @parm3max
	ORDER BY BatNbr,
	   Module,
	   RecordID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
