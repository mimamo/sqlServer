USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqDet_SeqNbr]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqDet_SeqNbr]
	@parm1 varchar( 4 )
AS
	SELECT *
	FROM POReqDet
	WHERE SeqNbr LIKE @parm1
	ORDER BY SeqNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
