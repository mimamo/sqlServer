USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRCheckTran_ASID]    Script Date: 12/21/2015 16:01:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PRCheckTran_ASID] @parm1 int
AS
	SELECT *
	FROM PRCheckTran
	WHERE ASID = @parm1
	ORDER BY ASID
GO
