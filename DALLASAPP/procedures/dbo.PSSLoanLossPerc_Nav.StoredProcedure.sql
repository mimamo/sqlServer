USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLoanLossPerc_Nav]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLoanLossPerc_Nav] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSLoanLossPerc WHERE LoanLossCode LIKE @parm1 ORDER BY LoanLossCode
GO
