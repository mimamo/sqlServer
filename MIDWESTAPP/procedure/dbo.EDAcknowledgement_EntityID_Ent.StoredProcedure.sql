USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDAcknowledgement_EntityID_Ent]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDAcknowledgement_EntityID_Ent]
	@parm1 varchar( 35 ),
	@parm2min smallint, @parm2max smallint
AS
	SELECT *
	FROM EDAcknowledgement
	WHERE EntityID LIKE @parm1
	   AND EntityType BETWEEN @parm2min AND @parm2max
	ORDER BY EntityID,
	   EntityType

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
