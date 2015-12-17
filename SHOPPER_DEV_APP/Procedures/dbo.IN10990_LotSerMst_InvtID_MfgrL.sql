USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IN10990_LotSerMst_InvtID_MfgrL]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IN10990_LotSerMst_InvtID_MfgrL]
	@parm1 varchar( 30 ),
	@parm2 varchar( 25 )
AS
	SELECT *
	FROM IN10990_LotSerMst
	WHERE InvtID LIKE @parm1
	   AND MfgrLotSerNbr LIKE @parm2
	ORDER BY InvtID,
	   MfgrLotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
