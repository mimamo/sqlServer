USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLPmtType_EXP]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLPmtType_EXP] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSLLPmtType WHERE left(PmtType,2) = 'EI' AND Status = 'A' AND PmtTypeCode LIKE @parm1  ORDER BY PmtTypeCode
GO
