USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[GetMaxLCCode]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[GetMaxLCCode]
	@parm1 VARCHAR (10)
AS
	SELECT MAX(LCCode)
	FROM APTran
	WHERE batnbr = @parm1
GO
