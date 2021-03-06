USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[vp_PORelease_Intran_TotQty]    Script Date: 12/21/2015 14:26:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create View [dbo].[vp_PORelease_Intran_TotQty]

AS

SELECT t.JrnlType,
       t.BatNbr,
       t.InvtId,
       t.SiteId,
       t.Rlsed,
       Qty=SUM(t.Qty)
 FROM INTran t
 Where JrnlType = 'PO'
 GROUP BY t.JrnlType, t.BatNbr, t.InvtId, t.SiteId, t.Rlsed
GO
