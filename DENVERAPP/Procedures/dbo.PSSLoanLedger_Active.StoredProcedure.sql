USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLoanLedger_Active]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLoanLedger_Active] @parm1 VARCHAR(20) AS 
  SELECT * FROM PSSLoanLedger WHERE LoanNo LIKE @parm1 And (Status = 'A' or Status = 'L') ORDER BY LoanNo
GO
