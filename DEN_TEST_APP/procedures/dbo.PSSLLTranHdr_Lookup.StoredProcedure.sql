USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLTranHdr_Lookup]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLTranHdr_Lookup] @BatNbr VARCHAR(10) AS
  SELECT * FROM PSSLLTranHdr WHERE BatNbr LIKE @BatNbr ORDER BY BatNbr
GO
