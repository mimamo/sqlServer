USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertMCGL]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertMCGL]
	
AS --Encrypt

	-- convert the 
	SET NOCOUNT ON

	update tJournalEntry
	set    ExchangeRate = 1
	
	update tTransaction
	set    ExchangeRate = 1
	      ,HDebit = Debit
		  ,HCredit = Credit

	update tCashTransactionLine
	set    ExchangeRate = 1
	      ,HDebit = Debit
		  ,HCredit = Credit

	update tCashTransaction
	set    ExchangeRate = 1
	      ,HDebit = Debit
		  ,HCredit = Credit

	RETURN 1
GO
