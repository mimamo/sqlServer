USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[IN10530_Return_all]    Script Date: 12/21/2015 16:01:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IN10530_Return_all]
	@parm1 varchar( 21 )
AS
	SELECT *
	FROM IN10530_Return
	WHERE ComputerName LIKE @parm1
	ORDER BY ComputerName

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
