USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCDelete_INTran]    Script Date: 12/21/2015 16:07:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LCDelete_INTran]
	@RcptNbr varchar(15)
as
Delete FROM INTran
WHERE
	JrnlType = 'LC'
	and crtd_Prog LIKE '61200%'
	AND Rlsed = 0
	and RcptNbr = @rcptnbr
GO
