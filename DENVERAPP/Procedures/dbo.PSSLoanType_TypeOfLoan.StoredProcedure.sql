USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLoanType_TypeOfLoan]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSLoanType_TypeOfLoan] @parm1 VARCHAR(1), @parm2 VARCHAR(10) AS
  SELECT * FROM PSSLoanType WHERE TypeOfLoan = @parm1 and LoanTypeCode LIKE @parm2 ORDER BY LoanTypeCode
GO
