USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJInvHdr_ASID]    Script Date: 12/21/2015 13:57:07 ******/
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
