USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WORequest_InvtID]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WORequest_InvtID]
	@parm1 varchar( 30 )
AS
	SELECT *
	FROM WORequest
	WHERE InvtID LIKE @parm1
	ORDER BY InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
