USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCDelete_APRefnbr]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LCDelete_APRefnbr]
	@RcptNbr varchar(15)
as
Delete from Refnbr
WHERE
	Refnbr in (Select Refnbr from Aptran where
			JrnlType = 'LC'
			and crtd_Prog LIKE '61200%'
			AND Rlsed = 0
			and ExtRefnbr = @RcptNbr)
GO
