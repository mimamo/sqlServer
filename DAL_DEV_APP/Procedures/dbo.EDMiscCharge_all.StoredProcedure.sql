USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDMiscCharge_all]    Script Date: 12/21/2015 13:35:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDMiscCharge_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM EDMiscCharge
	WHERE MiscChrgID LIKE @parm1
	   AND Code LIKE @parm2
	ORDER BY MiscChrgID,
	   Code

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
