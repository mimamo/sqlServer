USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARPrintQueue_all]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ARPrintQueue_all]
	@parm1 smallint

AS
	SELECT *
	FROM ARPrintQueue
	WHERE RI_ID = @parm1
	ORDER BY RI_ID
GO
