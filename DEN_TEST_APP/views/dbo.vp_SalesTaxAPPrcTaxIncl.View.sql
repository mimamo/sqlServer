USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[vp_SalesTaxAPPrcTaxIncl]    Script Date: 12/21/2015 14:10:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vp_SalesTaxAPPrcTaxIncl] AS

/****** FileName: 0305vp_03400SalesTaxAPPrcTaxIncl.Sql			******/
/****** Last Modified by Jason Hong on 9/11/98 					******/
/****** View to determine & select records with inclusive tax amounts. 	******/
/****** Must have vp_SalesTaxAPTranRls.						******/

SELECT  UserAddress, tRecordID = RecordID, OldTranAmt = MAX(TranAmt), OldCuryTranAmt = MAX(CuryTranAmt), 
	NewTranAmt = ROUND((MAX(CONVERT(DEC(28,3),TranAmt))) - (SUM(CONVERT(DEC(28,3),TaxAmt))), DecPl), 
	NewCuryTranAmt = ROUND((MAX(CONVERT(DEC(28,3),CuryTranAmt))) - (SUM(CONVERT(DEC(28,3),CuryTaxAmt))), DecPl)
FROM	vp_SalesTaxAPTran t INNER JOIN Currncy c (NOLOCK)
	ON c.CuryId = t.CuryId
WHERE	EXISTS(SELECT * FROM vp_SalesTax WHERE RecordID = t.TaxID AND CatID = t.TaxCat AND PrcTaxIncl = 'Y')
GROUP	BY UserAddress, RecordID, DecPl
GO
