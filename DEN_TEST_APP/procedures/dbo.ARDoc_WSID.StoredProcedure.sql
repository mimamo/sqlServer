USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_WSID]    Script Date: 12/21/2015 15:36:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ARDoc_WSID] @parm1 int
AS
	SELECT *
	FROM ARDoc
	WHERE WSID = @parm1
	ORDER BY WSID
GO
