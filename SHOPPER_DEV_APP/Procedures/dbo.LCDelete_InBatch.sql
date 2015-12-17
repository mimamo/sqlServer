USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCDelete_InBatch]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LCDelete_InBatch]
	@RcptNbr Varchar(15)
	AS
Delete from Batch
	WHERE Module = 'IN'
	and Crtd_Prog LIKE '61200%'
	and Batnbr in
	(Select batnbr from intran Where
		JrnlType = 'LC'
		and crtd_Prog LIKE '61200%'
		AND Rlsed = 0
		and RcptNbr = @rcptnbr)
GO
