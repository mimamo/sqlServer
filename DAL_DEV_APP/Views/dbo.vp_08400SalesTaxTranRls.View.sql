USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[vp_08400SalesTaxTranRls]    Script Date: 12/21/2015 13:35:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400SalesTaxTranRls] AS
/********************************************************************************
*             Copyright Solomon Software, Inc. 1994-1999 All Rights Reserved
*
*    View Name: vp_08400SalesTaxTranRls
*
*++* Narrative:  
*     
*
*
*   Called by: pp_08400, and vp_SalesTaxARPrcTaxIncl
* 
*/

SELECT  t.UserAddress, d.CpnyID, 
        t.CuryTaxAmt, t.CuryTranAmt, t.CuryTxblAmt, 
        t.TaxAmt, t.TranAmt, t.TxblAmt,  
        t.Custid, d.doctype, t.RefNbr, d.DocDate, d.BatNbr, 
        tRecordID = t.RecordID,  
        GrpTaxID = CASE WHEN v.RefType = 'G' THEN v.RecordID ELSE ' ' END,
	TaxAcct = v.SlsTaxAcct, TaxSub = v.SlsTaxSub, v.TaxID, 
        TaxRate = CONVERT(dec(9,6),v.TaxRate), v.PrcTaxIncl, c.DecPl,
	TaxDate = LTRIM(RTRIM(STR(DATEPART(YEAR, d.DocDate)))) 
                  + RIGHT('0' + LTRIM(RTRIM(STR(DATEPART(MONTH, d.DocDate)))),2),
        v.RefType
  FROM  vp_08400SalesTaxTran t INNER JOIN ARDoc d
                                       ON t.Custid = d.CustID
                                      AND t.RefNbr = d.RefNbr
                                      AND t.TranType = d.DocType
                               INNER JOIN vp_SalesTax v
                                       ON t.TaxId = v.RecordId
                                      AND t.TaxCat = v.CatId
                               INNER JOIN Currncy c
                                       ON t.CuryId = c.CuryId
 WHERE v.TaxCalcType = 'I'
GO
