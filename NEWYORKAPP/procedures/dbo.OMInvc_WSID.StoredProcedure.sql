USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[OMInvc_WSID]    Script Date: 12/21/2015 16:01:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[OMInvc_WSID] @parm1 int
AS
	SELECT *
	FROM SOShipHeader
	WHERE WSID = @parm1
	ORDER BY WSID
GO
