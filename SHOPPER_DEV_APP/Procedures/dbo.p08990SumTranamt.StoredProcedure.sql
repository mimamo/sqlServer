USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990SumTranamt]    Script Date: 12/21/2015 14:34:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p08990SumTranamt] @Batnbr VARCHAR (10) AS

SELECT d.Batnbr, d.Custid, d.Refnbr, d.Doctype, d.OrigDocamt,v.TranAmtTot
  FROM ARDoc d JOIN vi_08990SumTrans v
                 ON d.batnbr = v.batnbr AND
                    d.custid = v.custid AND
                    d.doctype = v.trantype ANd
                    d.refnbr = v.refnbr
 WHERE d.origdocamt <> v.TranAmtTot AND d.batnbr = @batnbr
   AND NOT (d.doctype IN ('NS','RP') AND S4Future12 = 'PP')
GO
