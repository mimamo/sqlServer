USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[OMShipNotice_WSID]    Script Date: 12/21/2015 15:36:59 ******/
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
