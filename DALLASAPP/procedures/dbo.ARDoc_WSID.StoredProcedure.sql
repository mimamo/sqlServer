USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_WSID]    Script Date: 12/21/2015 13:44:45 ******/
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
