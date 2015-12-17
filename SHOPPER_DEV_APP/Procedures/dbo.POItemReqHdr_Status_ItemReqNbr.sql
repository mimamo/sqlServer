USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POItemReqHdr_Status_ItemReqNbr]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POItemReqHdr_Status_ItemReqNbr]
	@parm1 varchar( 2 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM POItemReqHdr
	WHERE Status LIKE @parm1
	   AND ItemReqNbr LIKE @parm2
	ORDER BY Status,
	   ItemReqNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
