USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[IN10990_LotSerMst_ShipContCode]    Script Date: 12/21/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IN10990_LotSerMst_ShipContCode]
	@parm1 varchar( 20 ),
	@parm2 varchar( 30 ),
	@parm3 varchar( 25 )
AS
	SELECT *
	FROM IN10990_LotSerMst
	WHERE ShipContCode LIKE @parm1
	   AND InvtID LIKE @parm2
	   AND LotSerNbr LIKE @parm3
	ORDER BY ShipContCode,
	   InvtID,
	   LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
