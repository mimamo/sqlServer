USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POProjAppr_all]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POProjAppr_all]
	@parm1 varchar( 16 ),
	@parm2 varchar( 2 ),
	@parm3 varchar( 2 ),
	@parm4 varchar( 1 ),
	@parm5 varchar( 2 ),
	@parm6min smalldatetime, @parm6max smalldatetime
AS
	SELECT *
	FROM POProjAppr
	WHERE Project LIKE @parm1
	   AND DocType LIKE @parm2
	   AND RequestType LIKE @parm3
	   AND Budgeted LIKE @parm4
	   AND Authority LIKE @parm5
	   AND EffDate BETWEEN @parm6min AND @parm6max
	ORDER BY Project,
	   DocType,
	   RequestType,
	   Budgeted,
	   Authority,
	   EffDate

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
