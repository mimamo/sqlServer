USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAInvHdr_Batch]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAInvHdr_Batch] @BatNbr VARCHAR(10) AS
  SELECT * FROM PSSFAInvHdr WHERE isnumeric(batnbr) = 1 AND len(batnbr) = 10 AND BatNbr LIKE @BatNbr ORDER BY BatNbr
GO
