USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCDelete_APBatch]    Script Date: 12/21/2015 14:17:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LCDelete_APBatch]
	@RcptNbr varchar(15)
as
Delete from Batch
	WHERE Module = 'AP'
	and Crtd_Prog LIKE '61200%'
	and Batnbr in (Select Batnbr from APTran where
			JrnlType = 'LC'
			and crtd_Prog LIKE '61200%'
			AND Rlsed = 0
			and ExtRefnbr = @RcptNbr)
GO
