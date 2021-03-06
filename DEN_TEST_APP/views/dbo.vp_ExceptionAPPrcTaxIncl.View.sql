USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[vp_ExceptionAPPrcTaxIncl]    Script Date: 12/21/2015 14:10:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE view [dbo].[vp_ExceptionAPPrcTaxIncl] AS


SELECT t.UserAddress,  tBatNbr = t.batnbr, 
       tRefNbr = t.RefNbr,
       tTranTot= Sum( t.CurytaxAmt)
  FROM vp_SalesTaxAPTran t
  WHERE EXISTS(SELECT * FROM vp_SalesTaxID WHERE RecordID = t.TaxID AND PrcTaxIncl = 'Y')

 group by t.UserAddress, t.Batnbr, t.Refnbr
GO
