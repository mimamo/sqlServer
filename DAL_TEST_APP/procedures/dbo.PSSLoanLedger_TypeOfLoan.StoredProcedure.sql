USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLoanLedger_TypeOfLoan]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLoanLedger_TypeOfLoan] @parm1 VARCHAR(1), @parm2 VARCHAR(20) AS
  SELECT * FROM PSSLoanLedger WHERE LoanTypeCode in (Select LoanTypeCode From PSSLoanType WHERE TypeOfLoan = @parm1) and LoanNo LIKE @parm2 ORDER BY LoanNo
GO
