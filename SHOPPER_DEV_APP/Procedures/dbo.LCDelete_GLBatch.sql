USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCDelete_GLBatch]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[LCDelete_GLBatch]
	@RcptNbr varchar(15)
as
Delete from Batch
WHERE
	Module = 'GL'
	and Crtd_Prog LIKE '61200%'
	and Batnbr in
		(Select Batnbr from GlTran where
			JrnlType = 'LC'
			and crtd_Prog LIKE '61200%'
			AND Rlsed = 0
			and Refnbr = @RcptNbr)
GO
