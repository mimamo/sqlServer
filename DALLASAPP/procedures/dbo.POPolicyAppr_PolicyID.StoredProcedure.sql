USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[POPolicyAppr_PolicyID]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POPolicyAppr_PolicyID]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM POPolicyAppr
	WHERE PolicyID LIKE @parm1
	ORDER BY PolicyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
