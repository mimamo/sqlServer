USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Salesperson_All]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Salesperson_All]
	@SlsPerId varchar(10)
AS
	SELECT *
	FROM Salesperson
	WHERE SlsperId LIKE @SlsPerId
	ORDER BY SlsperId

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
