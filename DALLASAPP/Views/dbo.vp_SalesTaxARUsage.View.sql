USE [DALLASAPP]
GO
/****** Object:  View [dbo].[vp_SalesTaxARUsage]    Script Date: 12/21/2015 13:44:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX


CREATE VIEW [dbo].[vp_SalesTaxARUsage] AS 

SELECT DISTINCT t.UserAddress, t.RefNbr, t.TranType, s.RefType, s.TaxID, t.RecordID
FROM vp_SalesTaxARTran t, vp_SalesTaxID s
WHERE t.TaxID = s.RecordID
GO
