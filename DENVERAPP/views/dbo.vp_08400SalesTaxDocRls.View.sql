USE [DENVERAPP]
GO
/****** Object:  View [dbo].[vp_08400SalesTaxDocRls]    Script Date: 12/21/2015 15:42:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_08400SalesTaxDocRls] AS
						
/****** View to select all tax amounts for a given batch's doc records  ******/

SELECT DISTINCT t.CpnyID, t.UserAddress, t.CuryId, 
       t.CuryTaxAmt, t.CuryTxblAmt, t.TaxAmt, t.TxblAmt,
       t.Custid, t.RefNbr, t.DocDate, t.BatNbr,
       dCuryId = t.CuryId, t.DocType, TaxAcct = v.SlsTaxAcct , 
       GrpTaxID = CASE WHEN v.RefType = 'G' THEN v.RecordID ELSE ' ' END,
       TaxSub = v.SlsTaxSub, v.TaxID, TaxRate = CONVERT(DEC(9,6),v.TaxRate), c.DecPl, 
       TaxDate =  LTRIM(RTRIM(STR(DATEPART(YEAR, t.DocDate)))) + 
                      RIGHT('0' + LTRIM(RTRIM(STR(DATEPART(MONTH, t.DocDate)))),2) ,
       v.reftype
  FROM vp_08400SalesTaxDoc t JOIN vp_SalesTax v
                            ON t.TaxId = v.RecordId 
                          JOIN Currncy c
                            ON t.CuryId = c.CuryId
 WHERE v.TaxCalcType = 'D'
GO
