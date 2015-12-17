USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PI_Lines_With_No_Qty]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PI_Lines_With_No_Qty]
	@PIID VarChar(10),
	@StartRange Int,
	@EndRange Int

AS
 Select Count(*)
	From PIDetail
	WHERE Status = 'N' AND
		PIID = @PIID AND
		(Number < @StartRange OR
		Number > @EndRange)
GO
