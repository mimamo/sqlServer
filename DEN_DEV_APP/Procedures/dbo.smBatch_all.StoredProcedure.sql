USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smBatch_all]    Script Date: 12/21/2015 14:06:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smBatch_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM smBatch
	WHERE Batnbr LIKE @parm1
	ORDER BY Batnbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
