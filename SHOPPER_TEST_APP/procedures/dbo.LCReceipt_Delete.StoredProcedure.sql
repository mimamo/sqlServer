USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCReceipt_Delete]    Script Date: 12/21/2015 16:07:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[LCReceipt_Delete]
	@parm1 VARCHAR (10),
	@parm2 VARCHAR (10)
AS
	DELETE
	FROM LCReceipt
	WHERE batnbr = @parm1
	and rcptnbr = @parm2
GO
