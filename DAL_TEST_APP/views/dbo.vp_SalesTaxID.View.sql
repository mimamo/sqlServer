USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[vp_SalesTaxID]    Script Date: 12/21/2015 13:56:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vp_SalesTaxID] AS 

SELECT RecordID = t.TaxID, RefType = 'T', t.* 
FROM SalesTax t
WHERE TaxType = 'T'

UNION ALL

SELECT RecordID = g.GroupID, RefType = 'G', t.* 
FROM SalesTax t inner loop join SlsTaxGrp g ON g.TaxID = t.TaxID and t.TaxType = 'T'
GO
