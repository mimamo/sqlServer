USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Territory_All]    Script Date: 12/16/2015 15:55:11 ******/
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
