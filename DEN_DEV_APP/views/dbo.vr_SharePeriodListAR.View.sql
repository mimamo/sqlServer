USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[vr_SharePeriodListAR]    Script Date: 12/21/2015 14:05:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vr_SharePeriodListAR] AS

SELECT DISTINCT Period = h.FiscYr + v.Mon 
FROM AcctHist h, vr_ShareMonthList v
UNION
SELECT SUBSTRING(CurrPerNbr,1,4) + v.Mon 
  FROM ARSetup, vr_ShareMonthList v
GO
