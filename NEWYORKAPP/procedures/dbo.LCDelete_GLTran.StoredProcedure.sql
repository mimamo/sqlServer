USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCDelete_GLTran]    Script Date: 12/21/2015 16:01:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[LCDelete_GLTran]
	@RcptNbr varchar(15)
as
DELETE FROM GLTran
WHERE
	JrnlType = 'LC'
	and crtd_Prog LIKE '61200%'
	AND Rlsed = 0
	and Refnbr = @RcptNbr
GO
