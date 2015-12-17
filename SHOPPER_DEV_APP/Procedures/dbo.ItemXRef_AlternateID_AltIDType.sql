USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemXRef_AlternateID_AltIDType]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ItemXRef_AlternateID_AltIDType]
	@parm1 varchar( 30 ),
	@parm2 varchar( 1 ),
	@parm3 varchar( 15 )
AS
	SELECT *
	FROM ItemXRef
	WHERE AlternateID LIKE @parm1
	   AND AltIDType LIKE @parm2
	   AND EntityID LIKE @parm3
	ORDER BY AlternateID,
	   AltIDType,
	   EntityID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
