USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIDetail_PIID_InvtID_LotSerNbr]    Script Date: 12/21/2015 14:34:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PIDetail_PIID_InvtID_LotSerNbr]
	@parm1 varchar( 10 ),
	@parm2 varchar( 30 ),
	@parm3 varchar( 25 ),
	@parm4 varchar( 10 )
AS
	SELECT *
	FROM PIDetail
	WHERE PIID LIKE @parm1
	   AND InvtID LIKE @parm2
	   AND LotSerNbr LIKE @parm3
	   AND WhseLoc LIKE @parm4
	ORDER BY PIID,
	   InvtID,
	   LotSerNbr,
	   WhseLoc

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
