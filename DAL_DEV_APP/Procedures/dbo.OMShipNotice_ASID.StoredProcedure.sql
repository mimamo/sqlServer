USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[OMShipNotice_ASID]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[OMShipNotice_ASID] @parm1 int
AS
	SELECT *
	FROM SOShipHeader
	WHERE ASID01 = @parm1
	ORDER BY ASID01
GO
