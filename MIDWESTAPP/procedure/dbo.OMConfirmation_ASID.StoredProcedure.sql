USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[OMConfirmation_ASID]    Script Date: 12/21/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[OMConfirmation_ASID] @parm1 int
AS
	SELECT *
	FROM SOHeader
	WHERE ASID = @parm1
	ORDER BY ASID
GO
