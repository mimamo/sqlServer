USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[MiscCharge_all]    Script Date: 12/21/2015 13:44:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[MiscCharge_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM MiscCharge
	WHERE MiscChrgID LIKE @parm1
	ORDER BY MiscChrgID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
