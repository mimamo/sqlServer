USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Territory_All]    Script Date: 12/21/2015 13:56:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Territory_All]
	@SlsPerId varchar(10)
AS
	SELECT *
	FROM Territory
	WHERE Territory LIKE @SlsPerId
	ORDER BY Territory

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
