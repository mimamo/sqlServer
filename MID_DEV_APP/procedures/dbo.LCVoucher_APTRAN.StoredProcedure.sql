USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_APTRAN]    Script Date: 12/21/2015 14:17:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCVoucher_APTRAN]
	@parm1 VARCHAR(10),
	@parm2 VARCHAR(10),
	@parm3 VARCHAR(5)
AS
	SELECT *
	FROM aptran
	WHERE batnbr = @parm1
	and refnbr = @parm2
	and lineref = @parm3
	ORDER BY batnbr, refnbr, lineref
GO
