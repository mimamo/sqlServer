USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[OMShipNotice_WSID]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[OMShipNotice_WSID] @parm1 int
AS
	SELECT *
	FROM SOShipHeader
	WHERE WSID01 = @parm1
	ORDER BY WSID01
GO
