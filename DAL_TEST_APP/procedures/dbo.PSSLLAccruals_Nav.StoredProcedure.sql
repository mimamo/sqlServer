USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLLAccruals_Nav]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLLAccruals_Nav] @CpnyId VARCHAR(10), @LoanTypeCode VARCHAR(10) AS
  SELECT * FROM PSSLoanLedger WHERE Status = 'A' AND CpnyId = @CpnyId AND LoanTypeCode LIKE @LoanTypeCode ORDER BY LoanTypeCode, LoanNo
GO
