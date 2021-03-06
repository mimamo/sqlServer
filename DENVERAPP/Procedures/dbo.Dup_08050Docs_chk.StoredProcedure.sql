USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Dup_08050Docs_chk]    Script Date: 12/21/2015 15:42:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[Dup_08050Docs_chk] @Batnbr VARCHAR (10), @Custid VARCHAR (15),
                              @Doctype VARCHAR (2), @Refnbr VARCHAR (10) AS

SELECT *
  FROM ARDoc
 WHERE batnbr <> @Batnbr AND
       Custid = @Custid AND
       Doctype = @Doctype AND
       refnbr = @Refnbr
GO
