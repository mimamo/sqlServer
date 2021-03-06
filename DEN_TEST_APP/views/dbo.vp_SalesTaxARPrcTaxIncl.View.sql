USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[vp_SalesTaxARPrcTaxIncl]    Script Date: 12/21/2015 14:10:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_SalesTaxARPrcTaxIncl] AS

SELECT UserAddress, tRecordID = t.RecordID, OldTranAmt = MAX(TranAmt), OldCuryTranAmt = MAX(CuryTranAmt), 
	NewTranAmt = ROUND(MAX(TranAmt) - SUM(TaxAmt), MAX(bc.DecPl)), 
	NewCuryTranAmt = ROUND(MAX(CuryTranAmt) - SUM(CuryTaxAmt), MAX(fc.DecPl))
FROM  vp_08400SalesTaxTran t INNER JOIN ARDoc d
                                       ON t.Custid = d.CustID
                                      AND t.RefNbr = d.RefNbr
                                      AND t.TranType = d.DocType
                               INNER JOIN Currncy fc (NOLOCK)
                                       ON t.CuryId = fc.CuryId
                               INNER JOIN GLSetup g (NOLOCK)
                                       ON g.SetupID = 'GL'
                               INNER JOIN Currncy bc (NOLOCK)
                                       ON g.BaseCuryId = bc.CuryId
WHERE EXISTS(SELECT * FROM vp_SalesTax WHERE RecordID = t.TaxID AND CatID = t.TaxCat AND TaxCalcType = 'I' AND PrcTaxIncl = 'Y')
GROUP BY UserAddress, t.RecordID
GO
