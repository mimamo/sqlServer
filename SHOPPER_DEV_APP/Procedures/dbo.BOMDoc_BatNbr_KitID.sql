USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BOMDoc_BatNbr_KitID]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[BOMDoc_BatNbr_KitID]
	@parm1 varchar( 10 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM BOMDoc
	WHERE BatNbr LIKE @parm1
	   AND KitID LIKE @parm2
	ORDER BY BatNbr,
	   KitID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
