USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRCheckTran_ASID]    Script Date: 12/16/2015 15:55:30 ******/
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
