USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smBatch_Release]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smBatch_Release]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM smBatch
	WHERE Batnbr LIKE @parm1
	   AND Status = 'B'
	   AND Handling in ('L','R','N')
	ORDER BY
	   Batnbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
