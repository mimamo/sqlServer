USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Grid_LCReceipt_LCCode]    Script Date: 12/21/2015 14:17:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[Grid_LCReceipt_LCCode]
	@parm1 		VARCHAR (10),
	@parm2beg 	SMALLINT,
	@parm2end 	SMALLINT
AS
	SELECT *
	FROM	LCReceipt
		left outer join LCCode
			on LCReceipt.lccode = lccode.lccode
	WHERE	rcptnbr = @parm1
	and linenbr between @parm2beg and @parm2end
	ORDER BY rcptnbr, linenbr
GO
