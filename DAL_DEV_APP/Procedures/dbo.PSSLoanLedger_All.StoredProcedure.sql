USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLoanLedger_All]    Script Date: 12/21/2015 13:35:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLoanLedger_All] @parm1 VARCHAR(20) AS
  SELECT * FROM PSSLoanLedger WHERE LoanNo LIKE @parm1 ORDER BY LoanNo
GO
