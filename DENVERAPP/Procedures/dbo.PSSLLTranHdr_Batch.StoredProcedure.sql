USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLTranHdr_Batch]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLTranHdr_Batch] @BatNbr VARCHAR(10) AS
  SELECT * FROM PSSLLTranHdr WHERE BatNbr LIKE @BatNbr ORDER BY BatNbr
GO
