USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[OptDepExcl_DepExclOpt_DepExclF]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[OptDepExcl_DepExclOpt_DepExclF]
	@parm1 varchar( 30 ),
	@parm2 varchar( 4 )
AS
	SELECT *
	FROM OptDepExcl
	WHERE DepExclOpt LIKE @parm1
	   AND DepExclFtr LIKE @parm2
	ORDER BY DepExclOpt,
	   DepExclFtr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
