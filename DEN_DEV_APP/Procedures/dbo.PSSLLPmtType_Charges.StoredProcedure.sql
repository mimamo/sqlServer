USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLPmtType_Charges]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLPmtType_Charges] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSLLPmtType WHERE PmtType = 'CIR' AND Status = 'A' AND PmtTypeCode LIKE @parm1  ORDER BY PmtTypeCode
GO
