USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJInvHdr_WSID]    Script Date: 12/21/2015 16:07:13 ******/
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
