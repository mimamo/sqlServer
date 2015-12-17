USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SO40125_Wrk_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SO40125_Wrk_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM SO40125_Wrk
	WHERE SlsperID LIKE @parm1
	ORDER BY SlsperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
