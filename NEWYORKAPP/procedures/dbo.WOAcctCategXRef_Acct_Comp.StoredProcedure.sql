USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOAcctCategXRef_Acct_Comp]    Script Date: 12/21/2015 16:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOAcctCategXRef_Acct_Comp]
	@parm1 varchar( 16 )
AS
	SELECT *
	FROM WOAcctCategXRef
	WHERE Acct_Comp LIKE @parm1
	ORDER BY Acct_Comp

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
