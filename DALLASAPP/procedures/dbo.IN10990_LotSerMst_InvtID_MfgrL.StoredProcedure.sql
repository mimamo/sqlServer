USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[IN10990_LotSerMst_InvtID_MfgrL]    Script Date: 12/21/2015 13:44:55 ******/
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
