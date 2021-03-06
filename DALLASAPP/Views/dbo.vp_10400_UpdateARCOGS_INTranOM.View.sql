USE [DALLASAPP]
GO
/****** Object:  View [dbo].[vp_10400_UpdateARCOGS_INTranOM]    Script Date: 12/21/2015 13:44:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_10400_UpdateARCOGS_INTranOM] As

    SELECT T.BatNbr,
           T.CpnyId,
           CurPer = (RIGHT(RTRIM(I.PerNbr), 2)),
           CurYr = (SUBSTRING(I.PerNbr, 1, 4)),
           T.Id,
           FiscYr = (SUBSTRING(T.PerPost, 1, 4)),
           T.JrnlType,
	   T.InvtMult,
           T.TranType,
           T.LineNbr,
           I.PerNbr,
           T.PerPost,
           T.RefNbr,
           S.SlsperId,
	   TranAmt = Round((T.TranAmt * S.S4Future03)/100, C.DecPl),
           W.UserAddress
           FROM INTran T Join WrkRelease W
                           On T.BatNbr = W.BatNbr           
                         Join INSetup I
                           On 'IN' = I.SetUpId
                         Join SOShipHeader H
                           On T.RefNbr = H.InvcNbr
                          And T.CpnyId = H.CpnyId
                         Join SOShipLineSplit S
                           On H.CpnyId = S.CpnyId
                          And H.ShipperId = S.ShipperId
                          And T.ARLineRef = S.LineRef                          
                      	 Join GLSetup G
			   On 'GL' = G.SetUpID
			 Join Currncy C
			   On G.BaseCuryID = C.CuryID
           Where T.TranType IN ('IN', 'CM', 'DM', 'CG')
GO
