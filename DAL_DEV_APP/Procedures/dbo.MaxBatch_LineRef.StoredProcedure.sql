USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[MaxBatch_LineRef]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[MaxBatch_LineRef]
	@BATNBR		VARCHAR(10)
AS
	SELECT MAX(LINEREF) FROM INTran (NoLock) Where BatNbr = @BATNBR
GO
