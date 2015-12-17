USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOHeader_S4Future02]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOHeader_S4Future02]
	@parm1 varchar( 30 )
AS
	SELECT *
	FROM SOHeader
	WHERE S4Future02 LIKE @parm1
	ORDER BY S4Future02

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
