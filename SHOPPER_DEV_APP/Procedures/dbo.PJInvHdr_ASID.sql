USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJInvHdr_ASID]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PJInvHdr_ASID] @parm1 int
AS
	SELECT *
	FROM PJInvHdr
	WHERE ASID = @parm1
	ORDER BY ASID
GO
