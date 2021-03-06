USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[VendorRebate_CustID_InvtID_Exp]    Script Date: 12/21/2015 15:49:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[VendorRebate_CustID_InvtID_Exp]
	@parm1 varchar( 15 ),
	@parm2 varchar( 30 ),
	@parm3min smalldatetime, @parm3max smalldatetime
AS
	SELECT *
	FROM VendorRebate
	WHERE CustID LIKE @parm1
	   AND InvtID LIKE @parm2
	   AND ExpireDate BETWEEN @parm3min AND @parm3max
	ORDER BY CustID,
	   InvtID,
	   ExpireDate

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
