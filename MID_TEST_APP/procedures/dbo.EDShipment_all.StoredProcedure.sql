USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_all]    Script Date: 12/21/2015 15:49:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipment_all]
	@parm1 varchar( 20 )
AS
	SELECT *
	FROM EDShipment
	WHERE BOLNbr LIKE @parm1
	ORDER BY BOLNbr
GO
