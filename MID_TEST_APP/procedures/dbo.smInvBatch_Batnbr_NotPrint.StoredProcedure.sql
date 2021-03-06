USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smInvBatch_Batnbr_NotPrint]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smInvBatch_Batnbr_NotPrint]
	@parm1 varchar(10),
	@parm2 varchar(10)
As
	SELECT * FROM smInvBatch
	WHERE EditScrnNbr LIKE @parm1 AND
		   Batnbr LIKE @parm2 AND
		   Status = 'N'
	ORDER BY EditScrnNbr, Batnbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
