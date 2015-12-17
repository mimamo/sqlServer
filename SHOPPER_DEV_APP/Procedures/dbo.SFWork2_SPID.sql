USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SFWork2_SPID]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SFWork2_SPID]
	@parm1min smallint, @parm1max smallint
AS
	SELECT *
	FROM SFWork2
	WHERE SPID BETWEEN @parm1min AND @parm1max
	ORDER BY SPID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
