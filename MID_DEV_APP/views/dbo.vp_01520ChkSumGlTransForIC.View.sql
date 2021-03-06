USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[vp_01520ChkSumGlTransForIC]    Script Date: 12/21/2015 14:17:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_01520ChkSumGlTransForIC] AS

SELECT g.batnbr, g.cpnyID, g.Module, p.UserAddress,
       cramt = SUM(CONVERT(dec(28,3),g.cramt)), 
       dramt = SUM(CONVERT(dec(28,3),g.dramt))
  FROM WrkPost p INNER JOIN Batch b
                    ON p.batnbr = b.batnbr
                   AND p.module = b.module
		 INNER JOIN GLTran g
                    ON b.batnbr = g.batnbr
                   AND b.module = g.module
                 INNER JOIN Ledger l
                    ON b.LedgerID = l.LedgerID
 WHERE b.BatType <> 'J' AND l.BalRequired = 1
GROUP BY g.batnbr,g.module,g.cpnyID,p.UserAddress
GO
