USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_BatNbr_CpnyID_INTranLi]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerT_BatNbr_CpnyID_INTranLi]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 5 ),
	@parm4 varchar( 10 ),
	@parm5 varchar( 2 )
AS
	SELECT *
	FROM LotSerT
	WHERE BatNbr LIKE @parm1
	   AND CpnyID LIKE @parm2
	   AND INTranLineRef LIKE @parm3
	   AND SiteID LIKE @parm4
	   AND TranType LIKE @parm5
	ORDER BY BatNbr,
	   CpnyID,
	   INTranLineRef,
	   SiteID,
	   TranType

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
