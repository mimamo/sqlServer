USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLPmtHdr_Lookup]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLPmtHdr_Lookup] @parm1 VARCHAR(20), @parm2 VARCHAR(10) AS
  SELECT * FROM PSSLLPmtHdr WHERE LoanNo = @parm1 AND Refnbr LIKE @parm2 ORDER BY LoanNo
GO
