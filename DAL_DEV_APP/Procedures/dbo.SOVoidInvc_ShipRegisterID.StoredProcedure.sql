USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOVoidInvc_ShipRegisterID]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOVoidInvc_ShipRegisterID]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM SOVoidInvc
	WHERE ShipRegisterID LIKE @parm1
	ORDER BY ShipRegisterID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
