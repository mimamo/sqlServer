USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLPmtType_Chrgd]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLPmtType_Chrgd] @parm1 VARCHAR(10) AS 
  SELECT * FROM PSSLLPmtType WHERE PmtTypeCode LIKE @parm1 AND PmtType = 'LIR' ORDER BY PmtTypeCode
GO
