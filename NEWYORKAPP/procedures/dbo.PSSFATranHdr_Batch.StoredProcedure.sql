USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFATranHdr_Batch]    Script Date: 12/21/2015 16:01:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFATranHdr_Batch] @BatNbr VARCHAR(10) AS
  SELECT * FROM PSSFATranHdr WHERE BatNbr <> 'FORECAST' AND isnumeric(batnbr) = 1 AND len(batnbr) = 10 AND BatNbr LIKE @BatNbr ORDER BY BatNbr
GO
