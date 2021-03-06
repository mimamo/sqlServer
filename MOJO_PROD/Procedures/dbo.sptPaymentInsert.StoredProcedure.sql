USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentInsert]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentInsert]
	@CompanyKey int,
	@CashAccountKey int,
	@ClassKey int,
	@UnappliedPaymentAccountKey int,
	@PaymentDate smalldatetime,
	@PostingDate smalldatetime,
	@CheckNumber varchar(50),
	@PaymentAmount money,
	@VendorKey int,
	@PayToName varchar(300),
	@PayToAddress1 varchar(300),
	@PayToAddress2 varchar(300),
	@PayToAddress3 varchar(300),
	@PayToAddress4 varchar(300),
	@PayToAddress5 varchar(300),
	@Memo varchar(500),
	@GLCompanyKey int,
	@OpeningTransaction tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel     What
|| 09/21/07 BSH 8.5     (9659)Insert GLCompanyKey
|| 06/18/08 GHL 8.513   Added OpeningTransaction
*/

DECLARE @OnHold tinyint

if len(@CheckNumber) > 0 or not @CheckNumber is null
	if exists(Select 1 from tPayment (NOLOCK) Where CheckNumber = @CheckNumber and CashAccountKey = @CashAccountKey and CompanyKey = @CompanyKey)
		return -1
	Select @OnHold = OnHold from tCompany (nolock) WHERE CompanyKey = @VendorKey
	If @OnHold = 1 
		return -2

	INSERT tPayment
		(
		CompanyKey,
		CashAccountKey,
		ClassKey,
		UnappliedPaymentAccountKey,
		PaymentDate,
		PostingDate,
		CheckNumber,
		PaymentAmount,
		VendorKey,
		PayToName,
		PayToAddress1,
		PayToAddress2,
		PayToAddress3,
		PayToAddress4,
		PayToAddress5,
		Memo,
		GLCompanyKey,
		OpeningTransaction
		)

	VALUES
		(
		@CompanyKey,
		@CashAccountKey,
		@ClassKey,
		@UnappliedPaymentAccountKey,
		@PaymentDate,
		@PostingDate,
		@CheckNumber,
		@PaymentAmount,
		@VendorKey,
		@PayToName,
		@PayToAddress1,
		@PayToAddress2,
		@PayToAddress3,
		@PayToAddress4,
		@PayToAddress5,
		@Memo,
		@GLCompanyKey,
		@OpeningTransaction
		)
	
	SELECT @oIdentity = @@IDENTITY

	Return 1
GO
