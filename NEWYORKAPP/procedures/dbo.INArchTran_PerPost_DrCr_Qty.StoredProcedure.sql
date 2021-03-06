USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[INArchTran_PerPost_DrCr_Qty]    Script Date: 12/21/2015 16:01:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INArchTran_PerPost_DrCr_Qty]
	@parm1 varchar( 6 ),
	@parm2 varchar( 1 ),
	@parm3min float, @parm3max float
AS
	SELECT *
	FROM INArchTran
	WHERE PerPost LIKE @parm1
	   AND DrCr LIKE @parm2
	   AND Qty BETWEEN @parm3min AND @parm3max
	ORDER BY PerPost,
	   DrCr,
	   Qty

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
