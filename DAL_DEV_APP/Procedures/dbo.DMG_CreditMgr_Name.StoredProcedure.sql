USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CreditMgr_Name]    Script Date: 12/21/2015 13:35:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_CreditMgr_Name]
	@parm1 varchar(10)
AS
	SELECT CreditMgrName
	FROM CreditMgr
	WHERE CreditMgrID = @parm1

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
