USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ProdMgr_All]    Script Date: 12/21/2015 13:44:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_ProdMgr_All]
	@ProdMgrID varchar(10)
AS
	SELECT *
	FROM ProdMgr
	WHERE ProdMgrID LIKE @ProdMgrID
	ORDER BY ProdMgrID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
