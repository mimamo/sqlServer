USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SlsPrcDet_all]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SlsPrcDet_all]
	@parm1 varchar( 15 ),
	@parm2 varchar( 5 )
AS
	SELECT *
	FROM SlsPrcDet
	WHERE SlsPrcID LIKE @parm1
	   AND DetRef LIKE @parm2
	ORDER BY SlsPrcID,
	   DetRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
