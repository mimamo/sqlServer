USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[InvcType_all]    Script Date: 12/21/2015 15:49:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[InvcType_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM InvcType
	WHERE InvcTypeID LIKE @parm1
	ORDER BY InvcTypeID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
