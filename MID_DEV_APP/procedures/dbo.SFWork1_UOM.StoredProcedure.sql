USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SFWork1_UOM]    Script Date: 12/21/2015 14:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SFWork1_UOM]
	@parm1 varchar( 6 )
AS
	SELECT *
	FROM SFWork1
	WHERE UOM LIKE @parm1
	ORDER BY UOM

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
