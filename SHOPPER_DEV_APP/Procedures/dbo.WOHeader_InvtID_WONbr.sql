USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOHeader_InvtID_WONbr]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOHeader_InvtID_WONbr]
	@parm1 varchar( 30 ),
	@parm2 varchar( 16 )
AS
	SELECT *
	FROM WOHeader
	WHERE InvtID LIKE @parm1
	   AND WONbr LIKE @parm2
	ORDER BY InvtID,
	   WONbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
