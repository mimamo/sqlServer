USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHdr_Terms]    Script Date: 12/21/2015 14:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHdr_Terms]
	@parm1 varchar( 2 )
AS
	SELECT *
	FROM POReqHdr
	WHERE Terms LIKE @parm1
	ORDER BY Terms

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
