USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportPayment]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportPayment]
	@CompanyKey int,
	@CashAccountNumber varchar(100),
	@PaymentDate smalldatetime,
	@CheckNumber varchar(50),
	@VendorID varchar(50),
	@PayToName varchar(300),
	@PayToAddress1 varchar(300),
	@PayToAddress2 varchar(300),
	@PayToAddress3 varchar(300),
	@PayToAddress4 varchar(300),
	@PayToAddress5 varchar(300),
	@Memo varchar(500),
	@ClassID varchar(50),
	@OpeningTransaction tinyint = 0,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel   What
|| 06/18/08 GHL 8.513 Added OpeningTransaction
|| 06/20/08 GHL 8.514 Corrected source of payment address
*/

Declare @CashAccountKey int, @VendorKey int, @ClassKey int

Select @VendorKey = CompanyKey from tCompany (nolock) Where OwnerCompanyKey = @CompanyKey and VendorID = @VendorID
if @VendorKey is null
	return -1
	
if @CashAccountNumber is not null
begin
	Select @CashAccountKey = GLAccountKey from tGLAccount (nolock) 
		Where AccountNumber = @CashAccountNumber and CompanyKey = @CompanyKey and Rollup = 0 and AccountType = 10
	if @CashAccountKey is null
		return -2
end 

if len(ISNULL(@CheckNumber, '')) > 0
	if exists(Select 1 from tPayment (nolock) Where CheckNumber = @CheckNumber and CompanyKey = @CompanyKey)
		return -3

if @ClassID is not null
begin
	select @ClassKey = ClassKey from tClass (nolock) where CompanyKey = @CompanyKey and ClassID = @ClassID
	if @ClassKey is null
		return -5
end
		
if @ClassKey is null and (select isnull(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
	return -5
			
if @PayToName is null
begin
	Select
		@PayToName = c.CompanyName,
		@PayToAddress1 = b.Address1,
		@PayToAddress2 = b.Address2,
		@PayToAddress3 = b.Address3,
		@PayToAddress4 = ISNULL(b.City, '') + ' ' + ISNULL(b.State, '') + ' ' + ISNULL(b.PostalCode, ''),
		@PayToAddress5 = b.Country
	From tCompany c (nolock)
		Left Outer Join tAddress b (NOLOCK) On c.PaymentAddressKey = b.AddressKey 
	Where c.CompanyKey = @VendorKey
	
	if @PayToName is null
		return -4
		
	Select @PayToAddress2 = ISNULL(@PayToAddress2, ISNULL(@PayToAddress3, ISNULL(@PayToAddress4, '')))
	Select @PayToAddress3 = ISNULL(@PayToAddress3, ISNULL(@PayToAddress4, ''))
end

	INSERT tPayment
		(
		CompanyKey,
		CashAccountKey,
		PaymentDate,
		PostingDate,
		CheckNumber,
		VendorKey,
		PayToName,
		PayToAddress1,
		PayToAddress2,
		PayToAddress3,
		PayToAddress4,
		PayToAddress5,
		Memo,
		ClassKey,
		OpeningTransaction
		)

	VALUES
		(
		@CompanyKey,
		@CashAccountKey,
		@PaymentDate,
		@PaymentDate,
		@CheckNumber,
		@VendorKey,
		@PayToName,
		@PayToAddress1,
		@PayToAddress2,
		@PayToAddress3,
		@PayToAddress4,
		@PayToAddress5,
		@Memo,
		@ClassKey,
		@OpeningTransaction
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
