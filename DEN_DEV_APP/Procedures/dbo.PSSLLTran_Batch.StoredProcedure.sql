USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLTran_Batch]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLTran_Batch] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSLLTranHdr WHERE BatNbr LIKE @parm1 ORDER BY BatNbr
GO
