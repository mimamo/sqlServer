USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[OMManualConf_ASID]    Script Date: 12/21/2015 14:34:26 ******/
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
