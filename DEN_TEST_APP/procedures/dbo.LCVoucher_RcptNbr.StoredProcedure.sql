USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_RcptNbr]    Script Date: 12/21/2015 15:36:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE	PROCEDURE [dbo].[LCVoucher_RcptNbr]
	@parm1	VARCHAR(10),
	@parm2 VARCHAR(10),
	@parm3 VARCHAR(10),
	@parm4 VARCHAR(5)
AS
	SELECT	*
		FROM	LCVoucher
		WHERE	TranStatus = 'P'
		AND RcptNbr = @parm1
		AND	(APBatNbr <> @parm2 OR APRefNbr <> @parm3 OR APLineRef <> @parm4)
GO
