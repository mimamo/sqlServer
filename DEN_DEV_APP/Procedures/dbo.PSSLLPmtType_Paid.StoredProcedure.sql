USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLPmtType_Paid]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLPmtType_Paid] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSLLPmtType WHERE PmtTypeCode LIKE @parm1 AND PmtType = 'LPR' ORDER BY PmtTypeCode
GO
