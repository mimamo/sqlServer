USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vw_PSSFALMSLookUp]    Script Date: 12/21/2015 16:12:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_PSSFALMSLookUp] AS SELECT LoanNo, [Name] FROM PSSLoanLedger
GO
