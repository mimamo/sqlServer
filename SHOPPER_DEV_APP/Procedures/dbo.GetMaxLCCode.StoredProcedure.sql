USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GetMaxLCCode]    Script Date: 12/21/2015 14:34:20 ******/
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
