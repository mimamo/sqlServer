USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ProdMgr_all]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ProdMgr_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM ProdMgr
	WHERE ProdMgrID LIKE @parm1
	ORDER BY ProdMgrID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
