USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[p08030_DisableBankAcct]    Script Date: 12/21/2015 13:44:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[p08030_DisableBankAcct] @Custid VARCHAR (15), @Doctype VARCHAR (2), @Refnbr VARCHAR (10) AS
SELECT d.BATNBR,d.ApplBatnbr,d.CUSTID,d.DOCTYPE,d.REFNBR,b.BatType
  FROM ARDoc d JOIN Batch b
                 ON d.Batnbr = b.Batnbr AND b.Module = 'AR'
 WHERE d.CUSTID = @Custid
       AND d.Doctype = @Doctype
       AND d.Refnbr = @Refnbr
       AND (d.Batnbr <> Applbatnbr OR
           (d.Batnbr = d.applbatnbr AND b.BatType = 'C'))
GO
