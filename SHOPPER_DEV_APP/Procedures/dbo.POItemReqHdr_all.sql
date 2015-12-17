USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POItemReqHdr_all]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POItemReqHdr_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM POItemReqHdr
	WHERE ItemReqNbr LIKE @parm1
	ORDER BY ItemReqNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
