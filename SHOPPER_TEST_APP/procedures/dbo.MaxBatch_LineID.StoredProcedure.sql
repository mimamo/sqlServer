USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[MaxBatch_LineID]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[MaxBatch_LineID]
	@BATNBR		VARCHAR(10)
AS
	SELECT MAX(LINEID) FROM INTran (NoLock) Where BatNbr = @BATNBR
GO
