USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLPmtType_All]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLPmtType_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSLLPmtType WHERE PmtTypeCode LIKE @parm1 ORDER BY PmtTypeCode
GO
