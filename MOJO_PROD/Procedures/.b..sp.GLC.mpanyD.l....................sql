USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLCompanyDelete]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLCompanyDelete]
	@GLCompanyKey int

AS --Encrypt


	if exists(Select 1 from tVoucher Where GLCompanyKey = @GLCompanyKey)
		return -2
	if exists(Select 1 from tInvoice Where GLCompanyKey = @GLCompanyKey)
		return -3
	if exists(Select 1 from tPayment Where GLCompanyKey = @GLCompanyKey)
		return -4
	if exists(Select 1 from tCheck Where GLCompanyKey = @GLCompanyKey)
		return -5
	if exists(Select 1 from tJournalEntry Where GLCompanyKey = @GLCompanyKey)
		return -6
	if exists(Select 1 from tTransaction Where GLCompanyKey = @GLCompanyKey)
		return -1




	DELETE
	FROM tGLCompany
	WHERE
		GLCompanyKey = @GLCompanyKey 

	RETURN 1
GO
