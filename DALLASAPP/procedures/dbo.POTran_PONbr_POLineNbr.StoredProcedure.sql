USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[POTran_PONbr_POLineNbr]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POTran_PONbr_POLineNbr]
	@parm1 varchar( 10 ),
	@parm2min smallint, @parm2max smallint
AS
	SELECT *
	FROM POTran
	WHERE PONbr LIKE @parm1
	   AND POLineNbr BETWEEN @parm2min AND @parm2max
	ORDER BY PONbr,
	   POLineNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
