USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SNPrintQueue_all]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SNPrintQueue_all]
	@parm1 smallint

AS
	SELECT *
	FROM SNPrintQueue
	WHERE RI_ID = @Parm1
	ORDER BY RI_ID
GO
