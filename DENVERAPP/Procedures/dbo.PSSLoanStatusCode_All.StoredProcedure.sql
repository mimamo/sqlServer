USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLoanStatusCode_All]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSSLoanStatusCode_All] @parm1 VARCHAR(10) AS
SELECT * FROM PSSLoanStatusCode WHERE LoanStatusCode LIKE @parm1 ORDER BY LoanStatusCode
GO
