USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[vw_PSSFALMSLookUp]    Script Date: 12/21/2015 14:10:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vw_PSSFALMSLookUp] AS SELECT LoanNo, [Name] FROM PSSLoanLedger
GO
