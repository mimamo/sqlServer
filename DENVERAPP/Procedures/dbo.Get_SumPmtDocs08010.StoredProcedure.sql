USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Get_SumPmtDocs08010]    Script Date: 12/21/2015 15:42:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[Get_SumPmtDocs08010] @batnbr varchar ( 10), @custdid varchar ( 15), @refnbr varchar ( 10)
as

SELECT CuryOrigSum = SUM(curyorigdocamt),
       OrigSum = SUM(OrigDocAmt)
  FROM ARDoc (nolock)
 WHERE BatNbr = @batnbr AND
       NOT (CustID = @custdid AND
            RefNbr = @refnbr)
       AND doctype IN ('CS','RF')
GO
