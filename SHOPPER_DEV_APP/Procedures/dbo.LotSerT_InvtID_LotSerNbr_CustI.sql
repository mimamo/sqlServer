USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_InvtID_LotSerNbr_CustI]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerT_InvtID_LotSerNbr_CustI]
	@parm1 varchar( 30 ),
	@parm2 varchar( 25 ),
	@parm3 varchar( 15 )
AS
	SELECT *
	FROM LotSerT
	WHERE InvtID LIKE @parm1
	   AND LotSerNbr LIKE @parm2
	   AND CustID LIKE @parm3
	ORDER BY InvtID,
	   LotSerNbr,
	   CustID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
