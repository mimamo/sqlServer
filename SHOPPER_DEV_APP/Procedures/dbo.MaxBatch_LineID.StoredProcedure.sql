USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[MaxBatch_LineID]    Script Date: 12/21/2015 14:34:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[MaxBatch_LineID]
	@BATNBR		VARCHAR(10)
AS
	SELECT MAX(LINEID) FROM INTran (NoLock) Where BatNbr = @BATNBR
GO
