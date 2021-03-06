USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerTArch_all]    Script Date: 12/21/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerTArch_all]
	@parm1 varchar( 25 ),
	@parm2min int, @parm2max int
AS
	SELECT *
	FROM LotSerTArch
	WHERE LotSerNbr LIKE @parm1
	   AND RecordID BETWEEN @parm2min AND @parm2max
	ORDER BY LotSerNbr,
	   RecordID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
