USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SFWork1_all]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SFWork1_all]
	@parm1min int, @parm1max int
AS
	SELECT *
	FROM SFWork1
	WHERE ID BETWEEN @parm1min AND @parm1max
	ORDER BY ID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
