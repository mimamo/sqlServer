USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCDelete_APTran]    Script Date: 12/21/2015 15:42:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LCDelete_APTran]
	@RcptNbr varchar(15)
as
DELETE FROM APTran
WHERE
	JrnlType = 'LC'
	and crtd_Prog LIKE '61200%'
	AND Rlsed = 0
	and ExtRefnbr = @RcptNbr
GO
