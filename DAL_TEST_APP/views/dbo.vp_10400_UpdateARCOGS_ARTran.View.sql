USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[vp_10400_UpdateARCOGS_ARTran]    Script Date: 12/21/2015 13:56:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_10400_UpdateARCOGS_ARTran] As
    SELECT T.Id,
           T.ARLineId,
           T.RefNbr,
           ExtCost = Sum(T.TranAmt),
           W.UserAddress
           FROM INTran T, WrkRelease W
          Where T.TranType = 'CG'               
            And T.BatNbr = W.BatNbr
       GROUP BY W.UserAddress, T.Id, T.RefNbr, T.ARLineId
GO
