USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FrtTermDet_all]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FrtTermDet_all]
	@parm1 varchar( 10 ),
	@parm2min float, @parm2max float
AS
	SELECT *
	FROM FrtTermDet
	WHERE FrtTermsID LIKE @parm1
	   AND MinOrderVal BETWEEN @parm2min AND @parm2max
	ORDER BY FrtTermsID,
	   MinOrderVal

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
