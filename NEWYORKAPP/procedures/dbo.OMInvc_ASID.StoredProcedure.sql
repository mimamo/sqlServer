USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[OMInvc_ASID]    Script Date: 12/21/2015 16:01:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[OMInvc_ASID] @parm1 int
AS
	SELECT *
	FROM SOShipHeader
	WHERE ASID = @parm1
	ORDER BY ASID
GO
