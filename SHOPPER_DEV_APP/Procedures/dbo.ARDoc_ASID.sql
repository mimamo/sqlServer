USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_ASID]    Script Date: 12/16/2015 15:55:13 ******/
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
