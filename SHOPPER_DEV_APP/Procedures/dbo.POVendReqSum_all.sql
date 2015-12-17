USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POVendReqSum_all]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POVendReqSum_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 60 )
AS
	SELECT *
	FROM POVendReqSum
	WHERE ReqNbr LIKE @parm1
	   AND Name LIKE @parm2
	ORDER BY ReqNbr,
	   Name

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
