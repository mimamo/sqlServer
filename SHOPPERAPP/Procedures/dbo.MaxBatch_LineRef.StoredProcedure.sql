USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[MaxBatch_LineRef]    Script Date: 12/21/2015 16:13:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[MaxBatch_LineRef]
	@BATNBR		VARCHAR(10)
AS
	SELECT MAX(LINEREF) FROM INTran (NoLock) Where BatNbr = @BATNBR
GO
