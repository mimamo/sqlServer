USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TempInvtTot_all]    Script Date: 12/21/2015 14:34:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[TempInvtTot_all]
	@parm1 varchar( 30 )
AS
	SELECT *
	FROM TempInvtTot
	WHERE InvtId LIKE @parm1
	ORDER BY InvtId

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
