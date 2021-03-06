USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[vp_10400_UpdateARCOGS_INTran]    Script Date: 12/21/2015 14:17:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  View dbo.vp_10400_UpdateARCOGS_INTran    Script Date: 7/13/98 11:18:43 AM ******/
CREATE VIEW [dbo].[vp_10400_UpdateARCOGS_INTran] As

    SELECT T.BatNbr,
           T.CpnyId,
           CurPer = (RIGHT(RTRIM(S.PerNbr), 2)),
           CurYr = (SUBSTRING(S.PerNbr, 1, 4)),
           T.Id,
           FiscYr = (SUBSTRING(T.PerPost, 1, 4)),
	   T.InvtMult,
           T.JrnlType,
           T.LineNbr,
           S.PerNbr,
           T.PerPost,
           T.RefNbr,
           T.SlsperId,
           T.TranAmt,
           W.UserAddress
           FROM INTran T, WrkRelease W, INSetup S
          Where T.BatNbr = W.BatNbr
            And T.TranType = 'CG'
GO
