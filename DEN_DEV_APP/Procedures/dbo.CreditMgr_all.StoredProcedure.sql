USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CreditMgr_all]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CreditMgr_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM CreditMgr
	WHERE CreditMgrID LIKE @parm1
	ORDER BY CreditMgrID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
