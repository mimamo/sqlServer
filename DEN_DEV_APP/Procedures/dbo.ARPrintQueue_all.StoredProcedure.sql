USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARPrintQueue_all]    Script Date: 12/21/2015 14:05:57 ******/
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
