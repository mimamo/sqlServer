USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemXRef_EntityID_AltIDType_In]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ItemXRef_EntityID_AltIDType_In]
	@parm1 varchar( 15 ),
	@parm2 varchar( 1 ),
	@parm3 varchar( 30 )
AS
	SELECT *
	FROM ItemXRef
	WHERE EntityID LIKE @parm1
	   AND AltIDType LIKE @parm2
	   AND InvtID LIKE @parm3
	ORDER BY EntityID,
	   AltIDType,
	   InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
