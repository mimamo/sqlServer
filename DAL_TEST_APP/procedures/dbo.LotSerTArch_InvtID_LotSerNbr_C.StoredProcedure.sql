USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerTArch_InvtID_LotSerNbr_C]    Script Date: 12/21/2015 13:57:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerTArch_InvtID_LotSerNbr_C]
	@parm1 varchar( 30 ),
	@parm2 varchar( 25 ),
	@parm3 varchar( 15 )
AS
	SELECT *
	FROM LotSerTArch
	WHERE InvtID LIKE @parm1
	   AND LotSerNbr LIKE @parm2
	   AND CustID LIKE @parm3
	ORDER BY InvtID,
	   LotSerNbr,
	   CustID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
