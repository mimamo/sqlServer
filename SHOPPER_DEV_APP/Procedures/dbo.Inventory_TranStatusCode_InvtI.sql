USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_TranStatusCode_InvtI]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Inventory_TranStatusCode_InvtI]
	@parm1 varchar( 2 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM Inventory
	WHERE TranStatusCode LIKE @parm1
	   AND InvtID LIKE @parm2
	ORDER BY TranStatusCode,
	   InvtID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
