USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POUserSubAcct_all]    Script Date: 12/21/2015 15:37:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POUserSubAcct_all]
	@parm1 varchar( 47 ),
	@parm2 varchar( 24 )
AS
	SELECT *
	FROM POUserSubAcct
	WHERE UserID LIKE @parm1
	   AND Sub LIKE @parm2
	ORDER BY UserID,
	   Sub

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
