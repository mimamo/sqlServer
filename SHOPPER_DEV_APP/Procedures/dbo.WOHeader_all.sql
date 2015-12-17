USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOHeader_all]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOHeader_all]
	@parm1 varchar( 16 )
AS
	SELECT *
	FROM WOHeader
	WHERE WONbr LIKE @parm1
	ORDER BY WONbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
