USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[vp_11400_Variance]    Script Date: 12/21/2015 16:00:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_11400_Variance] As
	SELECT T.Batnbr, T.KitId, T.InvtId, T.RefNbr, T.Cpnyid, T.Fiscyr, T.PerEnt, T.PerPost, T.JrnlType,
       		TranAmt = (T.Qty * T.UnitPrice), T.BMITranAmt, T.Extcost, T.BMIExtCost, T.OvrhdAmt
	FROM INTran T
	Where T.TranType = 'AS'
		AND T.KitId <> ''
		And T.Rlsed = 0
	GROUP BY T.Batnbr, T.KitId, T.InvtId, T.RefNbr, T.Cpnyid, T.Fiscyr, T.PerEnt, T.PerPost, T.JrnlType,
       		T.Qty, T.UnitPrice, T.BMITranAmt, T.Extcost, T.BMIExtCost, T.OvrhdAmt
GO
