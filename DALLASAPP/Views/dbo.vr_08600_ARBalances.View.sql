USE [DALLASAPP]
GO
/****** Object:  View [dbo].[vr_08600_ARBalances]    Script Date: 12/21/2015 13:44:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vr_08600_ARBalances] as
SELECT   AgeBal01 = Sum(a.AgeBal01),
         AgeBal02 = Sum(a.AgeBal02),
         AgeBal03 = Sum(a.AgeBal03),
         AgeBal04 = Sum(a.AgeBal04),
         LastStmtBal00 = Sum(a.LastStmtBal00),
         LastStmtBal01 = Sum(a.LastStmtBal01),
         LastStmtBal02 = Sum(a.LastStmtBal02),
         LastStmtBal03 = Sum(a.LastStmtBal03),
         LastStmtBal04 = Sum(a.LastStmtBal04),
         LastStmtBegBal = Sum(a.LastStmtBegBal),
         LastStmtDate = Max(a.LastStmtDate),
         a.Custid, 
         r.RI_ID

FROM  AR_Balances a, Rptcompany r
WHERE a.cpnyid = r.cpnyid
GROUP BY a.Custid,r.RI_ID
GO
