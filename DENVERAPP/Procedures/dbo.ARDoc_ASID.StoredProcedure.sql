USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_ASID]    Script Date: 12/21/2015 15:42:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ARDoc_ASID] @parm1 int
AS
	SELECT *
	FROM ARDoc
	WHERE ASID = @parm1
	ORDER BY ASID
GO
