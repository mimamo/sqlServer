USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[OMManualConf_ASID]    Script Date: 12/21/2015 15:42:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[OMManualConf_ASID] @parm1 int
AS
	SELECT *
	FROM SOHeader
	WHERE ASID01 = @parm1
	ORDER BY ASID01
GO
