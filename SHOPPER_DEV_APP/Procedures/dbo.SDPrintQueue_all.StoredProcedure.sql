USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SDPrintQueue_all]    Script Date: 12/21/2015 14:34:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SDPrintQueue_all]
	@parm1 smallint

AS
	SELECT *
	FROM SDPrintQueue
	WHERE RI_ID = @Parm1
	ORDER BY RI_ID
GO
