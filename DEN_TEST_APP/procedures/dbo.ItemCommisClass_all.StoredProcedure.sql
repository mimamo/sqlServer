USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemCommisClass_all]    Script Date: 12/21/2015 15:36:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ItemCommisClass_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM ItemCommisClass
	WHERE ClassID LIKE @parm1
	ORDER BY ClassID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
