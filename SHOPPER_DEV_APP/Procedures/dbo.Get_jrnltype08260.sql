USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Get_jrnltype08260]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Get_jrnltype08260] @Batnbr varchar(10), @Custid VARCHAR(15), @Doctype VARCHAR(2), @Refnbr VARCHAR(10) AS

SELECT Jrnltype = ISNULL(b.Jrnltype,'BI')
  FROM ARDoc d LEFT JOIN Batch b
               ON d.batnbr = b.batnbr AND b.module = 'AR'
 WHERE d.batnbr = @batnbr AND
       d.custid = @Custid AND
       d.Doctype = @Doctype AND
       d.refnbr = @Refnbr
GO
