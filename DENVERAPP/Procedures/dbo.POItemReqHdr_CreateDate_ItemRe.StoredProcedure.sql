USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[POItemReqHdr_CreateDate_ItemRe]    Script Date: 12/21/2015 15:43:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POItemReqHdr_CreateDate_ItemRe]
	@parm1min smalldatetime, @parm1max smalldatetime,
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM POItemReqHdr
	WHERE CreateDate BETWEEN @parm1min AND @parm1max
	   AND ItemReqNbr LIKE @parm2
	ORDER BY CreateDate,
	   ItemReqNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
