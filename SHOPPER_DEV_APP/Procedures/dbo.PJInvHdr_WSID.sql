USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJInvHdr_WSID]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PJInvHdr_WSID] @parm1 int
AS
	SELECT *
	FROM PJInvHdr
	WHERE WSID = @parm1
	ORDER BY WSID
GO
