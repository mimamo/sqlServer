USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[vp_03400PPV_UpdateAPDOC]    Script Date: 12/21/2015 14:05:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  View dbo.vp_03400PPV_UpdateAPDOC     Script Date: 12/09/98 11:18:42 AM ******/
CREATE VIEW [dbo].[vp_03400PPV_UpdateAPDOC] As
SELECT T.RefNbr, W.UserAddress,
       DocBal = SUM(T.TranAmt)
       FROM APTran T Join WrkRelease_PO W
                       On T.BatNbr = W.PPVBatNbr 
       Where TranAmt <> 0     
       GROUP BY W.UserAddress, T.RefNbr
GO
