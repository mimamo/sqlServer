USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ShipVia_all]    Script Date: 12/21/2015 16:13:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** OBject: Stored Procedure dbo.ShipVia_All Script Date: 5/28/99 from DMG ******/
CREATE PROCEDURE [dbo].[ShipVia_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 )
AS
	SELECT *
	FROM ShipVia
	WHERE CpnyID LIKE @parm1
	   AND ShipViaID LIKE @parm2
	ORDER BY CpnyID,
	   ShipViaID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
