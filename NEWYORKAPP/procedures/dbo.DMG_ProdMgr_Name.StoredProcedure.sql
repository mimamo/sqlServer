USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ProdMgr_Name]    Script Date: 12/21/2015 16:00:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_ProdMgr_Name]
	@parm1 varchar(10)
AS
	SELECT	Descr
	FROM 	ProdMgr
	WHERE 	ProdMgrID = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
