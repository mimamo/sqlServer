USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CreditMgr_All]    Script Date: 12/21/2015 15:36:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_CreditMgr_All]
	@CreditMgrID varchar(10)
AS
	SELECT *
	FROM CreditMgr
	WHERE CreditMgrID LIKE @CreditMgrID
	ORDER BY CreditMgrID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
