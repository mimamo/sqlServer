USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[InventoryADG_all]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[InventoryADG_all]
	@parm1 varchar( 30 )
AS
	SELECT *
	FROM InventoryADG
	WHERE InvtID LIKE @parm1
	ORDER BY InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
