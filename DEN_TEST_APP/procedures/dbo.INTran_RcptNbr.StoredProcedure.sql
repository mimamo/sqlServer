USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_RcptNbr]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INTran_RcptNbr]
	@parm1 varchar( 15 )
AS
	SELECT *
	FROM INTran
	WHERE RcptNbr LIKE @parm1
	ORDER BY RcptNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
