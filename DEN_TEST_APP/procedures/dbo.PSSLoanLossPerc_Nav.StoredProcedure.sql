USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLoanLossPerc_Nav]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLoanLossPerc_Nav] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSLoanLossPerc WHERE LoanLossCode LIKE @parm1 ORDER BY LoanLossCode
GO
