USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCReceipt_LineNbr]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCReceipt_LineNbr]
	@parm1min smallint, @parm1max smallint
AS
	SELECT *
	FROM LCReceipt
	WHERE LineNbr BETWEEN @parm1min AND @parm1max
	ORDER BY LineNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
