USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_APAdjust_Ref3_CpnyID]    Script Date: 12/21/2015 14:17:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[APDoc_APAdjust_Ref3_CpnyID] @parm1 varchar ( 15), @parm2 varchar ( 10) As
Select
VO.*, APAdjust.AdjAmt, APAdjust.AdjBatNbr,
APAdjust.AdjdDocType, APAdjust.AdjDiscAmt, APAdjust.AdjdRefNbr, APAdjust.AdjgAcct,
APAdjust.AdjgDocDate, APAdjust.AdjgDocType, APAdjust.AdjgPerPost,
APAdjust.AdjgRefNbr, APAdjust.AdjgSub, APAdjust.Crtd_DateTime, APAdjust.Crtd_Prog,APAdjust.Crtd_User,
APAdjust.CuryAdjdAmt,
APAdjust.CuryAdjdCuryId, APAdjust.CuryAdjdDiscAmt, APAdjust.CuryAdjdMultDiv,
APAdjust.CuryAdjdRate, APAdjust.CuryAdjgAmt, APAdjust.CuryAdjgDiscAmt,
APAdjust.CuryRGOLAmt, APAdjust.DateAppl, APAdjust.PerAppl, APAdjust.User1 AdjUser1,
APAdjust.User2 AdjUser2, APAdjust.User3 AdjUser3, APAdjust.User4 AdjUser4,
APAdjust.VendId AdjVendID

from APDoc VO
	left outer join APAdjust
		on VO.RefNbr = APAdjust.AdjdRefNbr
		and VO.DocType = APAdjust.AdjdDocType
Where
VO.VendId = @parm1 and
VO.CpnyId LIKE @parm2 and
VO.DocClass = 'N' and
VO.Rlsed = 1
And (VO.OpenDoc = 1 or VO.CurrentNbr = 1)
Order by VO.VendId, VO.DocClass, VO.Rlsed, VO.BatNbr, VO.RefNbr
GO
