USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[vr_SharePeriodList]    Script Date: 12/21/2015 14:33:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vr_SharePeriodList] AS

SELECT DISTINCT Period = h.FiscYr + v.Mon 
FROM AcctHist h, vr_ShareMonthList v
GO
