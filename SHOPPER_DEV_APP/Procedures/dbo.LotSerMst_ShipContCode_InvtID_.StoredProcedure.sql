USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_ShipContCode_InvtID_]    Script Date: 12/21/2015 14:34:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerMst_ShipContCode_InvtID_]
	@parm1 varchar( 20 ),
	@parm2 varchar( 30 ),
	@parm3 varchar( 25 )
AS
	SELECT *
	FROM LotSerMst
	WHERE ShipContCode LIKE @parm1
	   AND InvtID LIKE @parm2
	   AND LotSerNbr LIKE @parm3
	ORDER BY ShipContCode,
	   InvtID,
	   LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
