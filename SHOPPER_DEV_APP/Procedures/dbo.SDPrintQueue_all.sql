USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SDPrintQueue_all]    Script Date: 12/16/2015 15:55:33 ******/
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
