USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[OMOrderConf_WSID]    Script Date: 12/21/2015 14:34:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[OMOrderConf_WSID] @parm1 int
AS
	SELECT *
	FROM SOHeader
	WHERE WSID = @parm1
	ORDER BY WSID
GO
