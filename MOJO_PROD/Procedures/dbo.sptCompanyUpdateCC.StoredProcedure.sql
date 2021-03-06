USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyUpdateCC]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyUpdateCC]
	@CompanyKey int,
	@CardHolderName varchar(250),
	@CCNumber varchar(200),
	@ExpMonth varchar(2),
	@ExpYear varchar(2),
	@CVV varchar(10)

AS

/*
|| 02/01/12  MFT 10.552  Added CASE to handle obsured CCNumbers
*/

	UPDATE
		tCompany
	SET
		CardHolderName = @CardHolderName,
		CCNumber = CASE LEFT(@CCNumber, 1) WHEN '*' THEN CCNumber ELSE @CCNumber END,
		ExpMonth = @ExpMonth,
		ExpYear = @ExpYear,
		CVV = @CVV
	WHERE
		CompanyKey = @CompanyKey 

	RETURN 1
GO
