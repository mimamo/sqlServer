USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOLine_InvtID_Status]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOLine_InvtID_Status]
	@parm1 varchar( 30 ),
	@parm2 varchar( 1 )
AS
	SELECT *
	FROM SOLine
	WHERE InvtID LIKE @parm1
	   AND Status LIKE @parm2
	ORDER BY InvtID,
	   Status

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
