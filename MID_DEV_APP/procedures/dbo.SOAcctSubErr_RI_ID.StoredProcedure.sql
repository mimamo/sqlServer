USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOAcctSubErr_RI_ID]    Script Date: 12/21/2015 14:17:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOAcctSubErr_RI_ID]
	@parm1min smallint, @parm1max smallint
AS
	SELECT *
	FROM SOAcctSubErr
	WHERE RI_ID BETWEEN @parm1min AND @parm1max
	ORDER BY RI_ID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
