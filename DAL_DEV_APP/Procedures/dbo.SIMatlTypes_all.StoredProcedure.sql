USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SIMatlTypes_all]    Script Date: 12/21/2015 13:35:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SIMatlTypes_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM SIMatlTypes
	WHERE MaterialType LIKE @parm1
	ORDER BY MaterialType

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
