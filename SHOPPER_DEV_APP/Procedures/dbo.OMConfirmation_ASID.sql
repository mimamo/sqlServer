USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[OMConfirmation_ASID]    Script Date: 12/16/2015 15:55:25 ******/
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
