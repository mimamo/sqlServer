USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustItem_all]    Script Date: 12/21/2015 14:17:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CustItem_all]
	@parm1 varchar( 15 ),
	@parm2 varchar( 30 ),
	@parm3 varchar( 4 )
AS
	SELECT *
	FROM CustItem
	WHERE CustID LIKE @parm1
	   AND InvtID LIKE @parm2
	   AND FiscYr LIKE @parm3
	ORDER BY CustID,
	   InvtID,
	   FiscYr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
