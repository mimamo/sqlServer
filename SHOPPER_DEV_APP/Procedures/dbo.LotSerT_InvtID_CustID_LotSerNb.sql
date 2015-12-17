USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_InvtID_CustID_LotSerNb]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerT_InvtID_CustID_LotSerNb]
	@parm1 varchar( 30 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 25 )
AS
	SELECT *
	FROM LotSerT
	WHERE InvtID LIKE @parm1
	   AND CustID LIKE @parm2
	   AND LotSerNbr LIKE @parm3
	ORDER BY InvtID,
	   CustID,
	   LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
