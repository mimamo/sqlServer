USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POItemReqHist_ItemReqNbr_LineR]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POItemReqHist_ItemReqNbr_LineR]
	@parm1 varchar( 10 ),
	@parm2 varchar( 5 )
AS
	SELECT *
	FROM POItemReqHist
	WHERE ItemReqNbr LIKE @parm1
	   AND LineRef LIKE @parm2
	ORDER BY ItemReqNbr,
	   LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
