USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Inspection_all]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Inspection_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 2 )
AS
	SELECT *
	FROM Inspection
	WHERE InvtID LIKE @parm1
	   AND InspID LIKE @parm2
	ORDER BY InvtID,
	   InspID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
