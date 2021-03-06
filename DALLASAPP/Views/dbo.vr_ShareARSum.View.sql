USE [DALLASAPP]
GO
/****** Object:  View [dbo].[vr_ShareARSum]    Script Date: 12/21/2015 13:44:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX


CREATE VIEW [dbo].[vr_ShareARSum] AS

SELECT v.Parent, v.PDocType, v.CustID, l.Period, ParentPerClosed = MAX(CASE WHEN (v.Ord=1 AND v.PerClosed > "000000") THEN v.PerClosed ELSE "000000" END), 
	Balance = ROUND(SUM(v.OrigDocAmt), 6), CurrBalance = ROUND(SUM(v.CuryOrigDocAmt), 6)
FROM vr_ShareARDetail v, vr_SharePeriodListAR l
WHERE v.PerPost <= l.Period
GROUP BY v.Parent, v.PDocType, v.CustID, l.Period
GO
