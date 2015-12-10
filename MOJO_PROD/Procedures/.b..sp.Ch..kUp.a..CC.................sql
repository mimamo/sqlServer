USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckUpdateCC]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckUpdateCC]
	@CheckKey int,
	@CardHolderName varchar(250),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@CustomerContactKey int,
	@Comment varchar(500),
	@CCNumber varchar(200),
	@ExpMonth varchar(2),
	@ExpYear varchar(2),
	@CVV varchar(10),
	@AuthCode varchar(100)

AS --Encrypt

/*
|| When      Who Rel     What
|| 03/04/10  MFT 10.519  Added @@ROWCOUNT test
|| 02/01/12  MFT 10.552  Added CASE to handle obsured CCNumbers
|| 02/29/12  RLB 10.552  set the clients default CCNuber when a new one is not passed in
*/


UPDATE
	tCheck
SET
	tCheck.CardHolderName = @CardHolderName,
	tCheck.Address1 = @Address1,
	tCheck.Address2 = @Address2,
	tCheck.Address3 = @Address3,
	tCheck.City = @City,
	tCheck.State = @State,
	tCheck.PostalCode = @PostalCode,
	tCheck.CustomerContactKey = @CustomerContactKey,
	tCheck.Comment = @Comment,
	tCheck.CCNumber = CASE LEFT(@CCNumber, 1) WHEN '*' THEN tCompany.CCNumber ELSE @CCNumber END,
	tCheck.ExpMonth = @ExpMonth,
	tCheck.ExpYear = @ExpYear,
	tCheck.CVV = @CVV,
	tCheck.AuthCode = @AuthCode
FROM tCheck (nolock)
INNER JOIN tCompany (nolock) on tCheck.ClientKey = tCompany.CompanyKey

WHERE
	tCheck.CheckKey = @CheckKey 

IF @@ROWCOUNT = 0
	RETURN -1
ELSE
	RETURN 1
GO
